open Graph

let clone_nodes (gr : 'a graph) = n_fold gr new_node empty_graph  ;;

let gmap gr f =  
  e_fold gr (fun x y -> new_arc x {y with lbl = (f y.lbl)}) (clone_nodes gr)  ;;

let add_arc gr id1 id2 n = 
  let arc = find_arc gr id1 id2 in
  match arc with  
  | None -> new_arc gr {src = id1; tgt = id2; lbl = n}
  | Some a -> new_arc gr {a with lbl = (a.lbl + n)};;
 