open Graph
open Tools

(* mets les labels au bon format avec un débit actuel à 0 *)
let init_labels gr = 
  let aux_init gr arc = add_arc gr arc.tgt arc.src 0 in
  e_fold gr aux_init gr ;; 

(* débit disponible sur cet arc (capacité - débit actuel) *)
let available_flow arc = 
  arc.lbl ;;

(* renvoie le débit dispo le + petit sur ce chemin *)
let min_flow pth = 
  List.fold_left (fun acu a -> if (available_flow a) <= acu 
    then (available_flow a) else acu) (available_flow (List.hd pth)) pth ;;
 
(* Trouve le chemin optimal entre la source et la destination en réalisant un parcours en largeur*)

  let find_path gr src dst =
    let rec aux marked_arcs pth arc =
      if arc.tgt = dst then List.rev (arc :: pth)
      else if List.mem arc marked_arcs then []
      else
        let successors = out_arcs gr arc.tgt in
        let valid_successors = 
          List.filter (fun a -> (a.lbl>0) && (not (List.mem a.tgt (List.map (fun arc -> arc.tgt) pth)))) successors 
        in
        List.fold_left (fun acu successor ->
          if acu <> [] then acu
          else aux (arc :: marked_arcs) (arc :: pth) successor) [] valid_successors
    in
    let start_arcs = out_arcs gr src in
    List.fold_left (fun acu start_arc -> 
      if acu <> [] then acu 
      else aux [] [] start_arc) [] start_arcs;;
    

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
