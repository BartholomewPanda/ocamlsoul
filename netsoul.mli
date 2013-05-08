(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*                   Bartholomew de La Villardière                     *)
(***********************************************************************)

exception Protocol_error
exception Login_error
val client : string -> int -> string -> string -> unit
