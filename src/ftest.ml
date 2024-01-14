open Gfile
open Tools
open Ford_fulkerson
open Graph
open Money_sharing

let print_persons lp = 
  let rec print_persons_aux lp = 
    match lp with 
    | [] -> ()
    | head::tail -> print_string (head.name^"->"^string_of_int head.exp^" "); print_persons_aux tail
  in
  print_persons_aux lp; print_newline();;

let print_path pth = 
  let rec print_path_aux pth = 
    match pth with 
    | [] -> ()
    | head::tail -> print_string (string_of_int head.src^"->"^string_of_int head.tgt^" lbl : "^string_of_int head.lbl^" "); print_path_aux tail
  in
  print_path_aux pth; print_newline();;

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
    let () = export outfile graphFinal in
    ()

  (*---------------------APPLICATION OF FORD FULKERSON ALGORITHM : MONEY SHARING PROBLEM---------------------*)

  else if Array.length Sys.argv = 3 then 

  let pers_file = Sys.argv.(1) 
  and outfile_MS = Sys.argv.(2) in

  (* NEXT LINES USED TO MODELISE THE PROBLEM*)
  let l_persons = l_persons_from_file pers_file 
  in
  print_persons l_persons;
  let l_persons_pid = init_due_pid l_persons in
  let person_graph = graph_from_l_persons l_persons_pid in
  
  let () = 
    print_persons l_persons_pid;
    let graphTest =  ford_fulkerson_algo person_graph 0 (List.length l_persons_pid + 1) in
    let graphFinal = flow_capacity person_graph graphTest in
    export_MS outfile_MS graphFinal l_persons_pid in
  ()
