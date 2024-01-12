open Gfile
open Tools
open Graph
open Money_sharing


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
  
  (*let infile = Sys.argv.(1)*) 
  let outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in
  

  (* Open file *)
  (*let graph = from_file infile in


  (*let graphtest = clone_nodes graph in*)
  let graphInt = gmap graph (fun str -> int_of_string str) in
  let graphInit = init_labels graphInt in
  
  let graphTest =  ford_fulkerson_algo graphInit _source _sink in
  let graphFinal = flow_capacity graphInt graphTest in*)
  (*let graphStr = gmap graphTest (fun x -> (string_of_int (Stdlib.fst x))^"/"^(string_of_int (Stdlib.snd x))) in*)
  (* Rewrite the graph that has been read. *)

  let l_persons = [{name = "John";exp = 40;due=0;pid=0} ;{name= "Kate";exp=10;due=0;pid=1};{name= "Ann";exp=10;due=0;pid=2}] in  
  let l_persons_pid = init_due_pid l_persons in
  let node_graph = init_person_graph l_persons_pid in
  let linked_graph = connect_person_graph node_graph in
  (*let graphStr = gmap linked_graph (fun x -> (x.name ^ " " ^ string_of_int x.exp ^" " ^ string_of_int x.due)) in*)
  let graphStr = gmap linked_graph (fun a -> string_of_int a) in
  let () = export outfile graphStr in 

  ()
