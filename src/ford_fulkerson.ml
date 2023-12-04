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
 
(* augmente tous les labels du chemin du maximum possible *)
let increase_flow gr pth = 
  let aux_increase gr arc = if (List.exists (fun a -> a == arc) pth) then 
    let gr = add_arc gr arc.src arc.tgt (-(min_flow pth)) in  
    let gr = add_arc gr arc.tgt arc.src (min_flow pth) in
    gr 
  else
      gr
  in
  e_fold gr aux_increase gr;; 
