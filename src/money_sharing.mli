open Graph

(* A person is defined by its name and expenses. Due and pid will be determined later *)
type person = {
    name : string ;
    exp : int ; 
    due : int ; 
    pid : int
}

(* Compute the due to be paid by each person on the list (Total expenses / Number of persons) *)
val due_per_person : person list -> int

(* Compute the total expenses of a persons list *)
val expenses : person list -> int 

(* Compute the amount that still need to be paid by a person *)
val diff : person -> person list -> int 

(* Initialize due and pid (used to construct a graph) for all person in a list *)
val init_due_pid : person list -> person list

(* Create a graph from a persons list *)
val init_person_graph : person list -> 'a graph

(* Create outgoing and ingoing arcs of infinite capacity between each person in a graph*)
val connect_person_graph : id graph -> person list -> id graph

(* Add a Source node and a Sink node to a graph. 
   If a person still needs to pay (due < 0), an arc is created from Source to this person with a label = -pers.due
   If a person still needs to be paid (due > 0), an arc is created from this person to Sink with a label = pers.due *)
val add_src_sink : id graph -> person list -> id graph

(* Create a graph from a person list, with source and sink node*)
val graph_from_l_persons : person list -> id graph

(*Used in gfile, export_MS and export_MS_better methods method to display : 
   get a person from a person list with the given pid*)
val get_person : person list -> int -> person 