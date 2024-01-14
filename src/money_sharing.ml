open Graph
open Tools
 
type person = 
  { name: string ;
    exp: int;
    due: int;
    pid: int }


(* Compute the total expenses of a persons list *)
let expenses l_persons = 
  let rec loop l acu =
    match l with 
   |[] -> acu
   |pers :: rest -> loop rest (acu+pers.exp)
  in
  loop l_persons 0;;       


(* Compute the due to be paid by each person on the list (Total expenses / Number of persons) *)
let due_per_person l_persons = 
  (expenses l_persons / List.length l_persons) ;; 

(* Compute the amount that still need to be paid by a person *)
let diff pers l_persons = 
  (pers.exp - due_per_person l_persons);;


(* Initialize due and pid (used to construct a graph) for all person in a list *)
let init_due_pid l_persons = 
  let rec loop l_pers pacu acu = 
    match l_pers with
   |[] -> acu
   | pers :: rest ->
    loop rest (pacu+1) ({pers with due=(diff pers l_persons);pid=pacu} :: acu) 
   in
   loop l_persons 1 [] ;; 

(* Create a graph from a person list*)
let init_person_graph l_persons =
  let rec ipg_loop l_pers gr_acu =
    match l_pers with
    | [] -> gr_acu 
    | h::t -> ipg_loop t (new_node gr_acu h.pid)
  in
  ipg_loop l_persons empty_graph ;;


(* Create outgoing and ingoing arcs of infinite capacity between each person in a graph*)
let connect_person_graph p_gr l_persons =
  n_fold p_gr (fun p_gr n1 -> 
    (n_fold p_gr (fun p_gr n2 -> 
                      if n2<>n1 
                      then add_arc p_gr n1 n2 (expenses l_persons)
                      else p_gr) p_gr)) p_gr;;


(* Add a Source node and a Sink node to a graph. 
   If a person still needs to pay (due < 0), an arc is created from Source to this person with a label = -pers.due
   If a person still needs to be paid (due > 0), an arc is created from this person to Sink with a label = pers.due *)                      
let add_src_sink p_gr l_persons=
  (* Source node creation*)
  let gr_1 = new_node p_gr 0 
  (* Sink node will take a the next pid after the last person' pid in the list *)
  and sink_pid = (List.length l_persons + 1) in
  (* Sink node creation *)
  let gr_2 = new_node gr_1 sink_pid in
  let rec add_src_sink_aux gr l_pers =
    match l_pers with 
   | [] -> gr
   | pers :: rest -> 
    if (pers.due < 0) 
      (* Add an arc between Source and person *)
    then (add_src_sink_aux (new_arc gr {src=0;tgt=pers.pid;lbl=(-pers.due)} ) rest)
    else if (pers.due > 0)
      (* Add an arc between person and Sink *)
    then (add_src_sink_aux (new_arc gr {src=pers.pid;tgt=sink_pid;lbl=pers.due}) rest)
    else (add_src_sink_aux gr rest) 
  in
  add_src_sink_aux gr_2 l_persons;;


(* Create a graph from a person list, with source and sink node*)
let graph_from_l_persons l_persons =
  add_src_sink(connect_person_graph(init_person_graph l_persons)l_persons) l_persons;;


(*Used in gfile, export_MS and export_MS_better methods method to display : 
   get a person from a person list with the given pid*) 
let get_person l_persons pid = 
  let rec get_person_aux l_pers pid = 
    match l_pers with
   | [] -> failwith "Person with the specified pid not found"   
   | pers :: rest -> if (pers.pid = pid) then pers else get_person_aux rest pid 
  in
  get_person_aux l_persons pid ;;
