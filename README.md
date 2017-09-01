
###### File structure:
```
project/
|
+-- project.opam
|
+-- README.md
|
+-- src/
|   |
|   \`-- project.ml
|
+-- target/
|   |
|   +-- byte/
|   |
|   \`-- native/
|   
+-- tests/
|   |
|   \`-- test.ml
|
\`-- docs/
```

###### Cmd interface:
```
opaca help	    -> help
opaca new "project" -> scaffold new project
opaca run 	    -> run project
opaca run -byte	    -> run bytecode interpreter
opaca build	    -> builds project to native
opaca build -byte   -> builds project to bytecode
opaca test  	    -> run tests
opaca doc	    -> run doc engine
opaca publish 	    -> generate opam package
opaca publish -aur  -> aur package
opaca publish -brew -> brew package
opaca publish -deb  -> debian package
```