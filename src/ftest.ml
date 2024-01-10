open Gfile
open Tools
open Ford_fulkerson
open Graph


let print_path pth = 
  let rec print_path_aux pth = 
    match pth with 
    | [] -> ()
    | head::tail -> print_string (string_of_int head.src^"->"^string_of_int head.tgt^" lbl : "^string_of_int head.lbl^" "); print_path_aux tail
  in
  print_path_aux pth; print_newline();;

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1) 
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in


  (* Open file *)
  let graph = from_file infile in


  (*let graphtest = clone_nodes graph in*)
  let graphInt = gmap graph (fun str -> int_of_string str) in
  let graphInit = init_labels graphInt in
  (*let pth = find_path graphInit 0 2 in
  (print_path pth);
  let graphTest = increase_flow graphInit (pth) in
  let pth2 = find_path graphTest 0 2 in
  (print_path pth2);
  let graphtest2 = increase_flow graphTest (pth2) in*) 
  (*let graphtest3 = increase_flow graphtest2 (find_path graphtest2 0 5) in*)
  
  (*Printf.printf "premier noeud du chemin : %d\n" (List.hd (find_path graphInit 0 5)).src;
  Printf.printf "deuxième noeud du chemin : %d\n" (List.hd (find_path graphInit 0 5)).tgt;
  Printf.printf "troisieme noeud du chemin : %d\n" (List.nth (find_path graphInit 0 5) 1).tgt;
  Printf.printf "4ième noeud du chemin : %d\n" (List.nth (find_path graphInit 0 5) 2).tgt;*)

  
  (*[{src=0;tgt=1;lbl=7};{src=1;tgt=4;lbl=1};{src=4;tgt=5;lbl=14}]*)
  let graphTest =  ford_fulkerson_algo graphInit 9 8 in
  let graphStr = gmap graphTest (fun x -> string_of_int x) in
 
  (* Rewrite the graph that has been read. *)
  let () = export outfile graphStr in 

  ()
