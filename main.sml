type pattern_paths = symbol list list
val showPattern_paths = fn t0 =>
  "["
  ^
  String.concatWith ", "
    (List.map
       (fn t0 => "[" ^ String.concatWith ", " (List.map showSymbol t0) ^ "]") t0)
  ^ "]"

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
