open Gfile
open Tools
open Graph
open Money_sharing
open Ford_fulkerson

let print_path pth = 
  let rec print_path_aux pth = 
    match pth with 
    | [] -> ()
    | head::tail -> print_string (string_of_int head.src^"->"^string_of_int head.tgt^" lbl : "^string_of_int head.lbl^" "); print_path_aux tail
  in
  print_path_aux pth; print_newline();;

let print_nodes gr = 
  n_iter_sorted gr (fun n -> print_string ("id: "^string_of_int n); print_newline());;
  
let print_persons l_persons = 
  let rec print_persons_aux l_pers =
    match l_pers with 
   | [] -> ()
   | pers :: rest -> print_string("name : "^pers.name^" exp : "^string_of_int pers.exp^" due : "^string_of_int pers.due^" id : "^string_of_int pers.pid);
   print_newline(); print_persons_aux rest 
  in
  print_persons_aux l_persons;;

let () =

  (* Check the number of command-line arguments *)
  if (Array.length Sys.argv <> 5 && Array.length Sys.argv <> 3) then
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

  if Array.length Sys.argv = 5 then 
  
    let infile = Sys.argv.(1)
    and outfile = Sys.argv.(4)
    
    (* These command-line arguments are not used for the moment. *)
    and _source = int_of_string Sys.argv.(2)
    and _sink = int_of_string Sys.argv.(3) 
    in
    

    (* Open file *)
    let graph = from_file infile in

    let graphInt = gmap graph (fun str -> int_of_string str) in
    let graphInit = init_labels graphInt in
    
    let graphTest =  ford_fulkerson_algo graphInit _source _sink in
    let graphFinal = flow_capacity graphInt graphTest in
    (*let graphStr = gmap graphFinal (fun x -> (string_of_int (Stdlib.fst x))^"/"^(string_of_int (Stdlib.snd x))) in*)
    let () = export outfile graphFinal in
    ()
    (* Rewrite the graph that has been read. *)

  (*---------------------APPLICATION OF FORD FULKERSON ALGORITHM : MONEY SHARING PROBLEM---------------------*)

  else if Array.length Sys.argv = 3 then 

  let _source = int_of_string Sys.argv.(1)
  and _sink = int_of_string Sys.argv.(2) in 

  (* NEXT LINES USED TO MODELISE THE PROBLEM*)
  let l_persons = [{name = "John";exp = 40;due=0;pid=1} ;{name= "Kate";exp=10;due=0;pid=2};{name= "Ann";exp=10;due=0;pid=3}] in  
  let l_persons_pid = init_due_pid l_persons in
  let node_graph = init_person_graph l_persons_pid in
  let linked_graph = connect_person_graph node_graph l_persons_pid in
  let problem_graph = add_src_sink linked_graph l_persons_pid in
  let graphStr = gmap problem_graph (fun a -> string_of_int a) in

 
  
  let () = 
    write_file "graphMS.txt" graphStr; 
    print_persons l_persons_pid;
    export_MS "outfileMS.txt" graphStr l_persons;
    (*NEXT LINES USED TO USE FORD FULKERSON ALGO ON THE PROBLEM GRAPH*)
    let graph = from_file "graphMS.txt" in

    let graphInt = gmap graph (fun str -> int_of_string str) in
    let graphInit = init_labels graphInt in
  
    let graphTest =  ford_fulkerson_algo graphInit _source _sink in
    let graphFinal = flow_capacity graphInt graphTest in
    export_MS "outfileMSApp.txt" graphFinal l_persons_pid in
  ()
