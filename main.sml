type pattern_paths = symbol list list
val showPattern_paths = fn t0 =>
  "["
  ^
  String.concatWith ", "
    (List.map
       (fn t0 =>
          "[" ^ String.concatWith ", " (List.map (Generic.show symbol) t0) ^ "]")
       t0) ^ "]"

val tree = Tree.Node
  ("a", [Tree.Node ("b", []), Tree.Wildcard, Tree.Node ("c", [Tree.Wildcard])])
val tree2 = Tree.instantiate (Tree.Node
  ("a", [Tree.Node ("b", []), Tree.Node ("c", [Tree.Node ("d", [])])]))
val paths = Tree.toPaths tree

val _ = print "Pattern tree:\n"
val _ = print (Tree.show tree ^ "\n\n")

val _ = print "Pattern paths:\n"
val _ = print (showPattern_paths paths ^ "\n\n")

val _ = print "Labelled tree instantiated from subject tree:\n"
val _ = print (LabelledTree.show tree2 ^ "\n\n")

val inputString = TextIO.openString "((hello, world), _, _)"
val lexer = Lex.makeLexer (fn n => TextIO.inputN (inputString, n))
val tok: Lex.UserDeclarations.lexresult option ref = ref NONE
val () =
  while (tok := SOME (lexer ()); !tok <> SOME Lex.UserDeclarations.EOF) do
    print (Lex.UserDeclarations.showLexresult (Option.valOf (!tok)) ^ "\n")
