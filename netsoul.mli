(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*                   Bartholomew de La Villardière                     *)
(***********************************************************************)

exception Protocol_error
val client : string -> int -> string -> string -> unit
