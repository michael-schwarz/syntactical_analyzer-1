open SyntacticalAnalyzer.JsonParser
open SyntacticalAnalyzer.QueryMapping
open SyntacticalAnalyzer.ResultPrinter
open Cil
open Cabs2cil

let jsonFile = Sys.argv.(1)
let sourceFile = Sys.argv.(2)

(* This actually parses and executes the query *)
let executeQuery () = 
let query = parse_json_file jsonFile
in let result = map_query (query) (Frontc.parse sourceFile ())
in Printf.printf "%s" (print_result result query)

let print_varnameMapping () =
ignore(map_query (parse_json_file jsonFile) (Frontc.parse sourceFile ())); Hashtbl.iter (fun a b -> Printf.printf "%s is mapped to %s\n" a b) varnameMapping

let measure_runtime cilfile () = 
let time1 = Unix.gettimeofday ()
in let _ = map_query (parse_json_file jsonFile) cilfile
in let time2 = Unix.gettimeofday ()
in time2 -. time1

let measure_xruntime x () =
let cilfile = Frontc.parse sourceFile ()
in let rec iter_x acc n = if n <= 0 then acc else iter_x ((measure_runtime cilfile ()) +. acc) (n-1)
in Printf.printf "_____________\nAverage running time: %f\n" ((iter_x 0.0 x) /. (float_of_int x))

let print_cilfile () =
let cilfile = Frontc.parse sourceFile ()
in Cil.dumpFile defaultCilPrinter stdout "" cilfile

let count_matches () =
let cilfile = Frontc.parse sourceFile ()
in Printf.printf "____________\nresults: %i\n" (List.length (map_query (parse_json_file jsonFile) cilfile))

let _ = executeQuery ()
