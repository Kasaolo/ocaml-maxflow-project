open Graph

(* Initiate all arcs flow with 0 *)
val init_labels : int graph -> int graph

(* Return the flow of an arc *)
(*val available_flow : int graph -> id -> id -> (int*int arc)*)

val min_flow : int arc list -> int

val find_path : int graph -> id -> id -> int arc list

val increase_flow : int graph -> int arc list -> int graph

val ford_fulkerson_algo : int graph -> id -> id -> int graph 

val print_path : int arc list -> unit

(*val flow_capacity : int graph -> int graph -> int*int graph *)

val find_flow : 'a graph -> 'a arc -> 'a

val flow_capacity_pirate : int graph -> int graph -> string graph