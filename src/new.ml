
module IO = struct

  let read_line inc =
    try Some (input_line inc)
    with End_of_file -> None
       | err -> raise err

  let print_line out str =
    output_string out @@ str ^ "\n"

  let copy src tgt =
    let inc = open_in src in
    let out = open_out tgt in
    let rec cp = function
      | Some line -> (print_line out line; cp @@ read_line inc)
      | None -> () in
    begin
      cp @@ read_line inc;
      flush out;
      close_out out
    end

end

(* default umask 0o777 for dirs, 0o666 for files *)
let dirs name =
  let umask = 0o777 in
  try begin
    Unix.mkdir name umask;
    Unix.mkdir (name ^ "/src") umask;
    Unix.mkdir (name ^ "/pkg") umask;
    Unix.mkdir (name ^ "/doc") umask
  end with
    Unix.Unix_error (Unix.EEXIST, _, _) ->
    begin
      print_endline @@ "ERROR: Cannot scaffold '" ^ name ^ "' - Directory already exists";
      exit 1
    end

let opam_init name =
  let exitp = Unix.system @@ "opam pin add " ^ name ^ " " ^ name ^ "/ -n" in
  let exitc = match exitp with
    | WEXITED n   -> n
    | WSIGNALED n -> n
    | WSTOPPED n  -> n in
  try if exitc = 0 then
      Unix.rename (name ^ "/opam") (name ^ "/" ^ name ^".opam")
    else
      begin
        print_endline @@ "Opam init exited with non-0 exit code: " ^ string_of_int exitc ^"
Please set it up manually!";
        IO.print_line (open_out @@ name ^ "/" ^ name ^ ".opam") "";
      end
  with Sys_error e ->
    begin
      print_endline "I'm so sorry, but i have to die now!";
      print_endline e;
      exit 1;
    end

                         

let files name =
  let fcreate path init=
    let oc = open_out @@ name ^ "/" ^ path
    in IO.print_line oc init in
  let exe () =
    (fcreate "src/main.ml" Resource.main;
     fcreate "src/jbuild" @@ Resource.jbuild_exe name) in
  let lib () =
    (fcreate ("src/" ^ name ^ ".ml") "";
     fcreate "src/jbuild" @@ Resource.jbuild_lib name) in 
  begin
    fcreate "README.md" "";
    fcreate "CHANGES.md" "";
    fcreate "LICENSE.md" "";
    fcreate "pkg/pkg.ml" Resource.pkg;
    fcreate "doc/api.odocl" "";
    fcreate "Makefile" Resource.make;
    (try
      match Sys.argv.(3) with
      | "--bin" | "-b" | "--exe" -> exe ()
      | _ -> lib ()
    with Invalid_argument _ -> lib ());
    opam_init name
  end


let scaffold () =
  if Array.length Sys.argv >= 3 then
    (dirs Sys.argv.(2);
     files Sys.argv.(2))
  else
    (print_endline "Invalid number of command arguments!\n";
     Help.print ())
