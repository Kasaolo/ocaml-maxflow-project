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
  List.fold_left (fun acu a -> if (available_flow a) <= acu then (available_flow a) else acu) (available_flow (List.hd pth)) pth ;;
 
(* Trouve le chemin optimal entre la source et la destination en réalisant un parcours en largeur*)

let rec choose_aux l_arc gr dest acu = 
  match l_arc with
  | [] -> []
  | arc :: rest -> if (arc.lbl > 0 && arc.tgt == dest) then arc :: acu 
  else if (arc.lbl > 0) then choose_aux (out_arcs gr arc.tgt) gr dest (arc :: acu)
  else choose_aux rest gr dest acu;;


let find_path gr src dest =
  let src_arcs = out_arcs gr src in
    let pth = choose_aux (src_arcs) gr dest [] in
    pth;;
 


(* Vrai si l'arc mène à la destination *)
let find_path gr src dest =
  let rec find_path_loop gr src dest acu = 
  match (out_arcs src) with 
  | arc::rest -> if arc.lbl > 0 then (if arc.tgt = dest then Some arc::acu else find_path_loop gr arc.tgt dest arc::acu; find_path_loop gr src dest acu) else None
  | [] -> None
       
    
    
(* augmente tous les flots sortants du chemin du maximum possible *)
let increase_flow gr pth =
  let rec increase_flow_loop gr pth flow_to_add = 
    match pth with 
    | [] -> gr 
    | head::tail -> increase_flow_loop (add_arc (add_arc gr head.tgt head.src flow_to_add) head.src head.tgt (-flow_to_add)) tail flow_to_add
  in
increase_flow_loop gr pth (min_flow pth);;