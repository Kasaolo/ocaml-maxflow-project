open Gfile
open Tools
open Ford_fulkerson

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
  let graphtest = increase_flow graphInit (find_path graphInit 0 5) in
  
  (*[{src=0;tgt=1;lbl=7};{src=1;tgt=4;lbl=1};{src=4;tgt=5;lbl=14}]*)

  let graphStr = gmap graphtest (fun x -> string_of_int x) in
 
  (* Rewrite the graph that has been read. *)
  let () = export outfile graphStr in 

  ()
