open Graph
open Tools

let init_labels gr = 
  (*For each arc of a capacity graph, we create an opposite arc, from the intial arc's tgt to its src, with a lbl equal to 0 *)
  let aux_init gr arc = add_arc gr arc.tgt arc.src 0 in
  e_fold gr aux_init gr ;; 
  

(* Return the minimum flow on a path *)
let min_flow pth = 
  List.fold_left (fun acu a -> if a.lbl <= acu 
    then a.lbl else acu) ((List.hd pth).lbl) pth ;;
 
(*Find a valid path between a source and a target in a graph*)

  let find_path gr src dst =
    (*Go through arcs, marked each time they are met*)
    let rec aux marked_arcs pth arc =
      (*If the target of an arc is the wanted destination, this arc is added to the marked arcs list 
         and we return the reversed marked arcs list*)
      if (arc.tgt = dst && arc.lbl > 0) then List.sort_uniq compare (List.rev (arc :: pth))
        (*Else if an arc is already in our marked list, we do nothing*)
      else if (List.mem arc marked_arcs) then []
        (*Else, we check that the next arcs are valid (all out arcs from the target node)*)
      else
        let successors = out_arcs gr arc.tgt in
        let valid_successors = 
          List.filter (fun a -> (a.lbl>0) && (not (List.mem a.tgt (List.map (fun arc -> arc.src) pth)))) successors 
        in
        (*For all the valid arcs, we apply our algorithm to construct a path*)
        List.fold_left (fun acu successor ->
          if acu <> [] then acu
          else aux (arc :: marked_arcs) (arc::pth) successor) [] valid_successors
    in
    (*Application of the above algorithm at the selected start node*)
    let start_arcs = out_arcs gr src in
    let valid_start_arcs = List.filter (fun a -> a.lbl>0) start_arcs in
    List.fold_left (fun acu start_arc -> 
      if acu <> [] then acu 
      else aux [] (start_arc::[]) start_arc) [] valid_start_arcs;;
    

(* Increase all outgoing flows of a path as much as possible *)
let increase_flow gr pth =
  let rec increase_flow_loop gr pth flow_to_add = 
    match pth with 
    | [] -> gr 
    (*Increase flows of the outgoing arcs and decrease flows from the incoming arcs on a path*)
    | head::tail -> increase_flow_loop (add_arc (add_arc gr head.tgt head.src flow_to_add) head.src head.tgt (-flow_to_add)) tail flow_to_add
  in
increase_flow_loop gr pth (min_flow pth);;

let print_path pth = 
  let rec print_path_aux pth = 
    match pth with 
    | [] -> ()
    | head::tail -> print_string (string_of_int head.src^"->"^string_of_int head.tgt^" "); print_path_aux tail
  in
  print_string "Début : "; print_path_aux pth; print_string "Fin"; print_newline();;


let ford_fulkerson_algo gr src dst = 
  (*Application of our find path algortihm until there is no more valid path on the graph to the destination*)
  let rec ford_fulkerson_aux gr =  
    let pth = find_path gr src dst in
    print_path pth;
    match pth with 
    | [] -> gr
    | path -> ford_fulkerson_aux (increase_flow gr path)
  in
  ford_fulkerson_aux gr ;;




let find_flow gr_gap a = 
  match (find_arc gr_gap a.tgt a.src) with
  (*Return the lbl of the opposite arc which corresponds to the flow of an arc*)
  | None -> failwith "Arc does not exist"
  | Some arc -> if arc.lbl > a.lbl then a.lbl else arc.lbl;;     
  

let flow_capacity gr_orig gr_gap =  
  (* Go through all arcs of the intial capacity graph and replace its label by a flow/capacity label*)
  e_fold gr_orig (fun gr_res a -> 
    new_arc gr_res {a with lbl = ((string_of_int (find_flow gr_gap a))^"/"^(string_of_int a.lbl))}) (clone_nodes gr_orig) ;;
