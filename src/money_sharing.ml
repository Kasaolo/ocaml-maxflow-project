open Graph
open Tools
 
type person = 
  { name: string ;
    exp: int;
    due: int;
    pid: int }


let expenses l_persons = 
  let rec loop l acu =
    match l with 
   |[] -> acu
   |pers :: rest -> loop rest (acu+pers.exp)
  in
  loop l_persons 0;;       


let due_per_person l_persons = 
  (expenses l_persons / List.length l_persons) ;; 

let diff pers l_persons = 
  (pers.exp - due_per_person l_persons);;

let init_due_pid l_persons = 
  let rec loop l_pers pacu acu = 
    match l_pers with
   |[] -> acu
   | pers :: rest ->
    loop rest (pacu+1) ({pers with due=(diff pers l_persons);pid=pacu} :: acu) 
   in
   loop l_persons 0 [] ;; 


let init_person_graph l_persons =
  let rec ipg_loop l_pers gr_acu =
    match l_pers with
    | [] -> gr_acu 
    | h::t -> ipg_loop t (new_node gr_acu h.pid)
  in
  ipg_loop l_persons empty_graph ;;

let connect_person_graph p_gr =
  n_fold p_gr (fun p_gr n1 -> 
    (n_fold p_gr (fun p_gr n2 -> 
                      if n2<>n1 
                      then add_arc p_gr n1 n2 max_int 
                      else p_gr) p_gr)) p_gr;;

let add_src_sink p_gr l_persons=
  let gr_1 = new_node p_gr (-1) in
  let gr_2 = new_node gr_1 (-2) in
  let rec add_src_sink_aux gr l_pers =
    match l_pers with 
   | [] -> gr
   | pers :: rest -> 
    if (pers.due < 0) 
    then (add_src_sink_aux (new_arc gr {src=(-1);tgt=pers.pid;lbl=(-pers.due)} ) rest)
    else if (pers.due > 0)
    then (add_src_sink_aux (new_arc gr {src=pers.pid;tgt=(-2);lbl=pers.due}) rest)
    else (add_src_sink_aux gr rest) 
  in
  add_src_sink_aux gr_2 l_persons;;

let get_person l_persons pid = 
  let rec get_person_aux l_pers pid = 
    match l_pers with
   | [] -> failwith "Person with the specified pid not found"   
   | pers :: rest -> if (pers.pid = pid) then pers else get_person_aux rest pid 
  in
  get_person_aux l_persons pid ;;
