open Cil

let rec find_decl_iter_list name list = match list with (GCompTagDecl(info, loc))::xs -> if (String.compare name info.cname = 0) then Some (loc, name) else find_decl_iter_list name xs
                                                    | (GEnumTagDecl(info, loc))::xs -> if (String.compare name info.ename = 0) then Some (loc, name) else find_decl_iter_list name xs
                                                    | x::xs -> find_decl_iter_list name xs
                                                    | [] -> None

let rec find_userdef_iter_list name list = match list with (GType(info, loc))::xs -> if (String.compare name info.tname = 0) then Some (loc, name) else find_userdef_iter_list name xs
                                                    | (GCompTag(info, loc))::xs -> if (String.compare name info.cname = 0) then Some (loc, name) else find_userdef_iter_list name xs
                                                    | (GEnumTag(info, loc))::xs -> if (String.compare name info.ename = 0) then Some (loc, name) else find_userdef_iter_list name xs
                                                    | x::xs -> find_userdef_iter_list name xs
                                                    | [] -> None

let find_decl_helper name file = let result_userdef = find_userdef_iter_list name file.globals
in
let loc_default = {line = -1; file = ""; byte = -1}
in
let result_decl = find_decl_iter_list name file.globals
in if result_userdef = None then (if result_decl = None then (loc_default,"") else (match result_decl with (Some(res)) -> res
                                                                                                            | _ -> (loc_default, ""))) else (match result_userdef with Some(res) -> res
                                                                                                                                                                  | _ -> (loc_default, "")  )

let find_decl name file = match (find_decl_helper name file) with (loc, typename) -> ("", loc, typename, -1)