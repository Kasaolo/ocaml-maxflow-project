open Graph

type person = {
    name : string ;
    exp : int ; 
    due : int ; 
    pid : int
}

val due_per_person : person list -> int

val expenses : person list -> int 

val diff : person -> person list -> int 

val init_due_pid : person list -> person list

val init_person_graph : person list -> 'a graph

val connect_person_graph : id graph -> id graph