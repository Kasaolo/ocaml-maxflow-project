open Graph
open Printf
open Money_sharing
    
type path = string

(* Format of text files:
   % This is a comment

   % A node with its coordinates (which are not used), and its id.
   n 88.8 209.7 0
   n 408.9 183.0 1

   % Edges: e source dest label id  (the edge id is not used).
   e 3 1 11 0 
   e 0 2 8 1

*)

(* Compute arbitrary position for a node. Center is 300,300 *)
let iof = int_of_float
let foi = float_of_int

let index_i id = iof (sqrt (foi id *. 1.1))

let compute_x id = 20 + 180 * index_i id

let compute_y id =
  let i0 = index_i id in
  let delta = id - (i0 * i0 * 10 / 11) in
  let sgn = if delta mod 2 = 0 then -1 else 1 in

  300 + sgn * (delta / 2) * 100
  

let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "%% This is a graph.\n\n" ;

  (* Write all nodes (with fake coordinates) *)
  n_iter_sorted graph (fun id -> fprintf ff "n %d %d %d\n" (compute_x id) (compute_y id) id) ;
  fprintf ff "\n" ;

  (* Write all arcs *)
  let _ = e_fold graph (fun count arc -> fprintf ff "e %d %d %d %s\n" arc.src arc.tgt count arc.lbl ; count + 1) 0 in
  
  fprintf ff "\n%% End of graph\n" ;
  
  close_out ff ;
  ()

(* Reads a line with a node. *)
let read_node graph line =
  try Scanf.sscanf line "n %f %f %d" (fun _ _ id -> new_node graph id)
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Ensure that the given node exists in the graph. If not, create it. 
 * (Necessary because the website we use to create online graphs does not generate correct files when some nodes have been deleted.) *)
let ensure graph id = if node_exists graph id then graph else new_node graph id

(* Reads a line with an arc. *)
let read_arc graph line =
  try Scanf.sscanf line "e %d %d %_d %s@%%"
        (fun src tgt lbl -> let lbl = String.trim lbl in new_arc (ensure (ensure graph src) tgt) { src ; tgt ; lbl } )
  with e ->
    Printf.printf "Cannot read arc in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a comment or fail. *)
let read_comment graph line =
  try Scanf.sscanf line " %%" graph
  with _ ->
    Printf.printf "Unknown line:\n%s\n%!" line ;
    failwith "from_file"

let from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. *)
  let rec loop graph =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      let graph2 =
        (* Ignore empty lines *)
        if line = "" then graph

        (* The first character of a line determines its content : n or e. *)
        else match line.[0] with
          | 'n' -> read_node graph line
          | 'e' -> read_arc graph line

          (* It should be a comment, otherwise we complain. *)
          | _ -> read_comment graph line
      in      
      loop graph2

    with End_of_file -> graph (* Done *)
  in

  let final_graph = loop empty_graph in
  
  close_in infile ;
  final_graph

let export path graph = 
  
  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "digraph finite_graph {\n" ;
  fprintf ff "  fontname=\"Helvetica,Arial,sans-serif\"\n";
  fprintf ff "  node [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  edge [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  rankdir=LR;\n";
  fprintf ff "  node [shape = circle];";

  (* Write all arcs *)
  let _ = e_fold graph (fun count arc -> fprintf ff "  %d -> %d [label = \"%s\"];\n" arc.src arc.tgt arc.lbl ; count + 1) 0 in
  
  fprintf ff "}" ;
  
  close_out ff ;
  ()
  
let read_person l_persons line =
  try Scanf.sscanf line "%s %d" (fun name expenses -> ({name=name;exp=expenses;due=0;pid=0}::l_persons) )
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

let l_persons_from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. *)
  let rec loop l_persons =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      let l_persons2 =
        (* Ignore empty lines *)
        if line = "" then l_persons

        (* The first character of a line determines its content : n or e. *)
        else match line.[0] with
          | '%' -> read_comment l_persons line
          | _ -> read_person l_persons line

          (* It should be a comment, otherwise we complain. *)
          
      in      
      loop l_persons2

    with End_of_file -> l_persons (* Done *)
  in

  let final_l_persons = loop [] in
  
  close_in infile ;
  final_l_persons;;

let export_MS path graph l_persons = 

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "digraph finite_graph {\n" ;
  fprintf ff "  fontname=\"Helvetica,Arial,sans-serif\"\n";
  fprintf ff "  node [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  edge [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  rankdir=LR;\n";
  fprintf ff "  node [shape = circle];";

  (* Write all arcs *)
  let _ = e_fold graph (fun count arc -> 
    if (arc.src=0)
    then (fprintf ff "  Source -> %s [label = \"%s\"];\n" (get_person l_persons arc.tgt).name arc.lbl; count + 1)
    else if (arc.tgt=(List.length l_persons + 1))
    then (fprintf ff "  %s -> Sink [label = \"%s\"];\n" (get_person l_persons arc.src).name arc.lbl; count + 1)
    else (fprintf ff "  %s -> %s [label = \"%s\"];\n" (get_person l_persons arc.src).name (get_person l_persons arc.tgt).name ((List.hd(String.split_on_char '/'arc.lbl))^"/inf"); count + 1)) 0 in
  
  fprintf ff "}" ;
  
  close_out ff ;
  ()

let export_MS_better path graph l_persons = 

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "digraph finite_graph {\n" ;
  fprintf ff "  fontname=\"Helvetica,Arial,sans-serif\"\n";
  fprintf ff "  node [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  edge [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  rankdir=LR;\n";
  fprintf ff "  node [shape = circle];";

  (* Write all arcs *)
  let _ = e_fold graph (fun count arc -> 
    if (String.starts_with ~prefix:"0" (List.hd (String.split_on_char '/' arc.lbl))) 
    then (();count + 1)
    else if (arc.src=0)
    then (();count + 1)
    else if (arc.tgt=(List.length l_persons + 1))
    then (();count + 1)
    else (fprintf ff "  %s -> %s [label = \"%s\"];\n" (get_person l_persons arc.src).name (get_person l_persons arc.tgt).name ("doit "^(List.hd (String.split_on_char '/' arc.lbl))^"€ à"); count + 1)) 0 in
  
  fprintf ff "}" ;
  
  close_out ff ;
  ()
