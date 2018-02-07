
let getenv nix dos =
  try Sys.getenv nix
  with Not_found -> Sys.getenv dos

let opam =
  "opam-version: \"1.2\"
maintainer:  \"" ^ getenv "USER" "%USERNAME%" ^ "\"
authors:     [\"\"]
license:     \"\"

homepage:    \"\"
dev-repo:    \"\"
bug-reports: \"\"
doc:         \"\"

build: [ [ \"jbuilder\" \"subst\" {pinned} ]
         [ \"jbuilder\" \"build\" \"-p\" name \"-j\" jobs ] ]

depends: [ 
    
]
"

let make =
  ".PHONY: all build clean test

build:
	jbuilder build --dev @install

all: build

test:
	jbuilder runtest --dev

install:
	jbuilder install --dev

uninstall:
	jbuilder uninstall

clean:
	rm -rf _build *.install
"

let jbuild_exe name =
  "(jbuild_version 1)

(executable
  ((name main)
   (package " ^ name ^ ")
   (public_name " ^ name ^ ")
   (libraries ())))"

let jbuild_lib name =
  "(jbuild_version 1)

(library
  ((name " ^ name ^ ")
   (public_name " ^ name ^ ")
   (synopsis \"\")
   (libraries ())))"

let pkg =
  "#use \"topfind\"\n#require \"topkg-jbuilder.auto\""

let main =
  "let () = print_endline \"Hello, world!\""
