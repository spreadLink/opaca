
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
|   +-- dev/
|   |
|   \`-- release/
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

- [x] opaca help
- [x] opaca new (the mechanical bits, not sure if the structure remains tbh)
- [ ] opaca run
- [ ] opaca build
- [ ] opaca test
- [ ] opaca publish
- [ ] opaca doc
- [ ] the manifest/meta file idk

Sample manifest file:
```
Meta [
  name: Sample
  version: 0.1
  authors: spreadTest
  maintainer: spreadTest@testmail.org
  homepage: github.com/spreadlink/opaca
  bug-reports: github.com/spreadlink/opaca/issues
  dev-repo: github.com/spreadlink/opaca.git
]

Dependencies [
  OCaml: >= 4.04.0
]

Conflicts [
  acapo: > 0.0
]
  ```