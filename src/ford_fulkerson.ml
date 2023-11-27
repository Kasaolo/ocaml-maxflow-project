open Graph
open Tools

(* mets les labels au bon format avec un débit actuel à 0 *)
let init_labels gr = 
  gmap gr (fun x -> (0,x)) ;;

(* débit disponible sur cet arc (capacité - débit actuel) *)
let available_flow arc = 
  (Stdlib.snd arc.lbl) - (Stdlib.fst arc.lbl) ;;

(* renvoie le débit dispo le + petit dur ce chemin *)
let min_flow pth = 
  List.fold_left (fun acu a -> if (available_flow a) <= acu then (available_flow a) else acu) (available_flow (List.hd pth)) pth ;;

(* augmente tous les labels du chemin du maximum possible *)
let increase_flow gr pth = 
  e_fold gr (fun x -> if (List.exists (fun a -> if (a = x) then true else false) pth) then ((fst x + min_flow pth),x) else (fst x,x))  
