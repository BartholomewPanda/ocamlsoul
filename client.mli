(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*                   Bartholomew de La Villardière                     *)
(***********************************************************************)

val run : string -> int -> (in_channel -> out_channel -> unit) -> unit
val recv_line : in_channel -> string
val send_line : out_channel -> string -> unit
