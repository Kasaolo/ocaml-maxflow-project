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
   |[] -> []
   | pers :: rest -> 
    let updated_person = {name = pers.name;exp = pers.exp;due=diff pers l_persons;pid=pacu} in
    loop rest (pacu+1) (updated_person :: acu) 
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

