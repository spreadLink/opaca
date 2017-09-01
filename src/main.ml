(* Why all in one file? To make is ez-pz to install over various platforms.
   No ocamlfind, no ocamlbuild, no .merlin, no nothing, just ocamlopt
 *)

module Help: sig val print: unit -> unit end = struct
  let gen_use = "Opaca: A project-manager for the OCaml language \n"
                ^ "Usage: opaca ..."
                ^ "help | -help | -h: This help text"
                ^ "new 'name':        Scaffolds a new project in folder 'name'\n"
                ^ "run [-byte]:       Runs the ocaml program via 'ocaml´ or 'ocamlrun´\n"
                ^ "build [-byte]:     Build the project via 'ocamlopt´ or 'ocamlc´\n"
                ^ "test:              Runs test suite\n"
                ^ "doc:               Builds documentation via 'ocamldoc´\n"
                ^ "publish [-'pkg']:  Emitts a package suitable for opam or 'pkg´\n"
                ^ "   where 'pkg' =   aur:  Arch user repositories\n"
                ^ "                   brew: MacOS brew repository\n"
                ^ "                   deb:  Debian .deb package\n"

  let print () = print_string gen_use
end


module Manifest = struct

end

module New: sig val scaffold: unit -> unit end = struct
  let opamP name =
    let usr = Unix.getenv "USER" in
    let template = "opam-version: \"1.2\"\nname: \"" ^ name ^ "\"\n"
                   ^ "version: \"0.1\"\nauthors: \"" ^ usr ^ "\"\n"
                   ^ "maintainer: \"" ^ usr ^ "\"\nhomepage: \"\"\n"
                   ^"bug-reports: \"\"\ndev-repo: \"\"\nlicense: \"\"\n"
                   ^ "build: []\ninstall: []\nremove: []\ndepends: []"
    in let file = Unix.openfile (name ^ "/" ^ name ^ ".opam")
                                [Unix.O_WRONLY; Unix.O_CREAT] 0o666
                  |> Unix.out_channel_of_descr
       in try (output_bytes file template; flush file;
          Unix.descr_of_out_channel file |> Unix.close)
      with err -> Unix.descr_of_out_channel file |> Unix.close; raise err
  
  (* default umask 0o777 for dirs, 0o666 for files *)
  let dirs name =
    let umask = 0o777 in
    (Unix.mkdir name umask;
     Unix.mkdir (name ^ "/src") umask;
     Unix.mkdir (name ^ "/target") umask;
     Unix.mkdir (name ^ "/tests") umask;
     Unix.mkdir (name ^ "/docs") umask)

  let files name =
    let umask = 0o666 in
    let flgs = [Unix.O_RDWR; Unix.O_CREAT] in
    let fcreate path = Unix.close @@ Unix.openfile (name^"/"^path) flgs umask
    in
    (opamP name;
     fcreate ("README.md");
     fcreate ("src/" ^ name ^ ".ml");
     fcreate ("tests/test.ml");)

  let scaffold () =
    if Array.length Sys.argv = 3 then
    (dirs Sys.argv.(2);
     files Sys.argv.(2);)
    else
      (print_endline "Invalid number of command arguments!\n";
       Help.print ())
end


module Cmds: sig val parse : unit -> unit end = struct
  let nyi arg = "Function not yet implemented: " ^ arg |> print_endline
              
  let disp_first () =
    match String.lowercase_ascii Sys.argv.(1) with
    | "help" | "-help" | "-h" -> Help.print ()
    | "new"                   -> New.scaffold ()
    | "run"                   -> nyi "RUN"
    | "build"                 -> nyi "BUILD"
    | "test"                  -> nyi "TEST"
    | "doc"                   -> nyi "DOC"
    | "publish"               -> nyi "PUBLISH"
    | _ -> print_endline @@ "invalid command: " ^ Sys.argv.(1); Help.print ()

  let parse () =
    if Array.length Sys.argv > 1 then
      disp_first ()
    else
      Help.print ()

end
                
let () = Cmds.parse ();;
