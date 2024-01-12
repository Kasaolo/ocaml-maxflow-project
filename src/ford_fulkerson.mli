open Graph

(* Create a gap graph from a capacity graph *)
val init_labels : int graph -> int graph

(*Return the minimum flow on a selected path*)
val min_flow : int arc list -> int

(*Find a path in a graph from a source node to a taget node*)
val find_path : int graph -> id -> id -> int arc list

(*Increase the flow of arcs on a path, with the minimum flow on this path*)
val increase_flow : int graph -> int arc list -> int graph

(*Ford fulkerson algorithm to find the max flow*)
val ford_fulkerson_algo : int graph -> id -> id -> int graph 

val print_path : int arc list -> unit

(*Return the flow of an arc based on the gap graph*)
val find_flow : 'a graph -> 'a arc -> 'a

(*Convert a gap graph to a flow/capacity graph*)
val flow_capacity: int graph -> int graph -> string graph