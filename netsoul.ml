
module type Netsoul =
sig
    val client : string -> int -> string -> string -> unit
end

module Netsoul =
struct
    exception Protocol_error

    (* Créer un token d'authentification *)
    let make_token hash host port password =
        Digest.to_hex
                (Digest.string (hash ^ "-" ^ host ^ "/" ^ port ^ password))

    (* Envoie une commande netsoul et attend l'ack du serveur *)
    let send_and_recv ichan ochan str =
        Client.Client.send_line ochan str;
        if (Client.Client.recv_line ichan) <> "rep 002 -- cmd end" then
            raise Protocol_error

    (* TODO: créer une fonction générique pour les commandes netsoul *)
    let auth_ag send_fct p1 p2 p3 =
        send_fct ("auth_ag " ^ p1 ^ " " ^ p2 ^ " " ^ p3)

    let ext_user_log send_fct login token client location =
        send_fct ("ext_user_log " ^ login ^ " " ^ token
                 ^ " " ^ client ^ " " ^ location)

    (* TODO: rendre cette fonction générique pour l'envoi d'autre commandes *)
    let user_cmd send_fct cmd p1 =
        send_fct ("user_cmd " ^ cmd ^ " " ^ p1)

    (* Gère la phase d'authentification *)
    let identify ichan ochan login password line =
        let send_fct = send_and_recv ichan ochan in
        let tokens =
            try
                Str.split_delim (Str.regexp " ") line
            with Not_found -> raise Protocol_error in
        begin
            auth_ag send_fct "ext_user" "none" "none";
            begin
                (* TODO: utiliser ocamllex pour parser en fonction d'une
                 * grammaire ? *)
                match tokens with
                    | _ :: _ :: hash :: host :: port :: _ ->
                        let token = make_token hash host port password in
                        ext_user_log send_fct login token
                                     "ocamlsoul" "none"
                    | _ -> raise Protocol_error
            end;
            user_cmd (Client.Client.send_line ochan) "state" "actif"
        end

    (* Permet la connexion au service *)
    (* TODO: traiter les messages reçus *)
    let manager login password ichan ochan =
        begin
            let line = Client.Client.recv_line ichan in
            identify ichan ochan login password line;
            while true do
                let _ = Client.Client.recv_line ichan in ()
            done
        end

    let client host port login password =
        while true do
            try
                Client.Client.run host port (manager login password)
            with _ -> Unix.sleep 2
        done
end

