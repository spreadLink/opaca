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
