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

val _ = run "f(x)" "z(f(x, u), f(x), f(x))"
val _ = print "\n"
val _ = run "a(a(b, _), c)" "z(f(x, u), a(a(b, f(x)), c), a(a(b, f(x)), d))"
val _ = print "\n"
val _ = run "g(_)" "f(g(g(f(g(x)))))"
val _ = print "\n"
