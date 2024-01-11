open Graph
open Tools

(* mets les labels au bon format avec un débit actuel à 0 *)
let init_labels gr = 
  let aux_init gr arc = add_arc gr arc.tgt arc.src 0 in
  e_fold gr aux_init gr ;; 

(* débit disponible sur cet arc (capacité - débit actuel) *)
let available_flow gr id1 id2 = 
  let arc1 = 
    match (find_arc gr id1 id2) with
   | None -> failwith "Arc not found"
   | Some a -> a.lbl and  
  arc2 = 
    match (find_arc gr id2 id1) with
   | None -> failwith "Arc not found"
   | Some a -> a.lbl  
  in    
  if (arc1.lbl > arc2.lbl) then ((arc1.lbl-arc2.lbl),arc1)
  else ((arc2.lbl-arc1.lbl),arc2) ;;

(* renvoie le débit dispo le + petit sur ce chemin *)
let min_flow pth = 
  List.fold_left (fun acu a -> if a.lbl <= acu 
    then a.lbl else acu) ((List.hd pth).lbl) pth ;;
 
(* Trouve le chemin optimal entre la source et la destination en réalisant un parcours en largeur*)

  let find_path gr src dst =
    let rec aux marked_arcs pth arc =
      if arc.tgt = dst then List.sort_uniq compare (List.rev (arc :: pth))
      else if List.mem arc marked_arcs then []
      else
        let successors = out_arcs gr arc.tgt in
        let valid_successors = 
          List.filter (fun a -> (a.lbl>0) && (not (List.mem a.tgt (List.map (fun arc -> arc.src) pth)))) successors 
        in
        List.fold_left (fun acu successor ->
          if acu <> [] then acu
          else aux (arc :: marked_arcs) (arc :: pth) successor) [] valid_successors
    in
    let start_arcs = out_arcs gr src in
    let valid_start_arcs = List.filter (fun a -> a.lbl>0) start_arcs in
    List.fold_left (fun acu start_arc -> 
      if acu <> [] then acu 
      else aux [] (start_arc::[]) start_arc) [] valid_start_arcs;;
    

(* augmente tous les flots sortants du chemin du maximum possible *)
let increase_flow gr pth =
  let rec increase_flow_loop gr pth flow_to_add = 
    match pth with 
    | [] -> gr 
    | head::tail -> increase_flow_loop (add_arc (add_arc gr head.tgt head.src flow_to_add) head.src head.tgt (-flow_to_add)) tail flow_to_add
  in
increase_flow_loop gr pth (min_flow pth);;


let ford_fulkerson_algo gr src dst = 
  let rec ford_fulkerson_aux gr =  
    let pth = find_path gr src dst in
    match pth with 
    | [] -> gr
    | path -> ford_fulkerson_aux (increase_flow gr path)
  in
  ford_fulkerson_aux gr ;;


let print_path pth = 
  let rec print_path_aux pth = 
    match pth with 
    | [] -> ()
    | head::tail -> print_string (string_of_int head.src^"->"^string_of_int head.tgt^" "); print_path_aux tail
  in
  print_path_aux pth; print_newline();;



(*let state_to_flow grInit grState =
  let rec modify_arcs grInit grState acu = 
    (*On parcours tout le graphe de flow initial*)
    match grInit with 
   |[] -> acu
   |(idInit,larcI) :: restI  -> 
    match grState with 
   |[] -> [] 
   |(idState,larcS) :: restS -> 
    if (idInit=idState) then 
      match larcS with 
   | [] -> []
   | arc :: restarc ->  
    match (find_arc arc.src arc.tgt grInit) with
   | None -> arc.lbl
     
  e_fold grInit (modify_arcs) grInit;;*)

  (*let state_to_flow gr = 
    let blankGraph = clone_nodes grState in
    let rec aux gr larc = 
      match larc with
     | [] -> gr
     | arc :: rest -> 
      let first_arc = (available_flow gr arc.src arc.tgt).snd and
      flow = (available_flow gr arc.src arc.tgt).fst in
      if (first_arc = arc) 
        then 
          add_arc blankGraph arc.src arc.tgt flow
      else 
        add_arc blankGraph arc.tgt arc.src flow
    in
    n_fold grState (fun n -> (aux grState out_arcs gr n)) *)


let state_to_flow gr = 
let blankGraph = clone_nodes gr in
let aux gr arc = 
  let first_arc = Stdlib.snd (available_flow gr arc.src arc.tgt) and
  flow = Stdlib.fst (available_flow gr arc.src arc.tgt) in
  if (first_arc = arc) 
    then 
      add_arc blankGraph arc.src arc.tgt flow
  else 
    add_arc blankGraph arc.tgt arc.src flow
in
e_fold gr (fun a -> (aux gr a)) ;;