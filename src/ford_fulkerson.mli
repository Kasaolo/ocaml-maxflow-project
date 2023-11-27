open Graph

(* Initiate all arcs flow with 0 *)
val init_labels : int graph -> (int*int) graph

(* Return the flow of an arc *)
val available_flow : (int*int) arc -> int

val min_flow : (int*int) arc list -> int

(*val find_path : int graph -> id -> id -> int arc list*)

(*val increase_flow : int graph -> int arc list -> int graph*)