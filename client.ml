
module type Client =
sig
    val run : string -> int -> (in_channel -> out_channel -> unit) -> unit
    val recv_line : in_channel -> string
    val send_line : out_channel -> unit
end

module Client =
struct
    (* Ouvre une socket et retourne deux channels (lecture et écriture) *)
    let open_connection sockaddr =
        let sock = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
        try
            Unix.connect sock sockaddr;
        (Unix.in_channel_of_descr sock, Unix.out_channel_of_descr sock)
        with excpt -> (Unix.close sock; raise excpt)

    (* Ferme une connexion *)
    let close_connection chan =
        Unix.shutdown (Unix.descr_of_in_channel chan) Unix.SHUTDOWN_SEND

    (* Récupère l'adresse de host *)
    let get_inet_addr host =
        try
            Unix.inet_addr_of_string host
        with Failure("inet_addr_of_string") ->
            let host = Unix.gethostbyname host in
            host.Unix.h_addr_list.(0)

    let recv_line ichan = String.trim (input_line ichan)
    let send_line ochan str = output_string ochan (str ^ "\r\n"); flush ochan

    (* Créer une connexion et appelle la fonction fct avec le channel d'entré et
     * de sorti *)
    let run host port fct =
        let sockaddr = Unix.ADDR_INET (get_inet_addr host, port) in
        let (sock_in, sock_out) = open_connection sockaddr in
        try
            fct sock_in sock_out
        with excpt -> (close_connection sock_in; raise excpt)
end

