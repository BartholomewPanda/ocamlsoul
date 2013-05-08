(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*                   Bartholomew de La Villardière                     *)
(***********************************************************************)

let login = "bartholomew"
let password = ""
let host = "163.5.255.5"
let port = 4242

let _ =
    try Netsoul.client host port login password
    with Netsoul.Login_error -> Printf.eprintf "Bad login ='(\n"
