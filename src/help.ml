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
