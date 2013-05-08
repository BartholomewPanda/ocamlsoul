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

let _ = Netsoul.client host port login password
