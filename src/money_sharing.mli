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

val init_person_graph : int list -> 'a graph

val connect_person_graph : 'a graph -> 'a graph