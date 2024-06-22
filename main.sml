structure Main =
struct
  type pattern_paths = Symbol.t list list

  fun main () =
    let
      val showPattern_paths = fn t0 =>
        "["
        ^
        String.concatWith ", "
          (List.map
             (fn t0 =>
                "["
                ^ String.concatWith ", " (List.map (Generic.show Symbol.t) t0)
                ^ "]") t0) ^ "]"

      val tree = Tree.Node
        ( "a"
        , [Tree.Node ("b", []), Tree.Wildcard, Tree.Node ("c", [Tree.Wildcard])]
        )
      val tree2 = Tree.instantiateCounter 1 (Tree.Node
        ("a", [Tree.Node ("b", []), Tree.Node ("c", [Tree.Node ("d", [])])]))
      val paths = Tree.toPaths tree

      val () = print "Pattern tree:\n"
      val () = print (Tree.show tree ^ "\n\n")

      val () = print "Pattern paths:\n"
      val () = print (showPattern_paths paths ^ "\n\n")

      val () = print "Labelled counter tree instantiated from subject tree:\n"
      val () = print (TreeWithCounter.show tree2 ^ "\n\n")

      val () = print "First test:\n"
      val result = Algorithm.run ["f(x)"] "z(f(x, u), f(x), f(x))"
      val () = print (TreeWithCounter.show result ^ "\n\n")
      val result = AlgorithmWithBitset.run ["f(x)"] "z(f(x, u), f(x), f(x))"
      val () = print (TreeWithBitset.show result ^ "\n\n\n")

      val () = print "Second test:\n"
      val result = Algorithm.run ["a(a(b, _), c)"]
        "z(f(x, u), a(a(b, f(x)), c), a(a(b, f(x)), d))"
      val () = print (TreeWithCounter.show result ^ "\n\n")
      val result = AlgorithmWithBitset.run ["a(a(b, _), c)"]
        "z(f(x, u), a(a(b, f(x)), c), a(a(b, f(x)), d))"
      val () = print (TreeWithBitset.show result ^ "\n\n\n")

      val _ = print "Third test:\n"
      val result = Algorithm.run ["g(_)"] "f(g(g(f(g(x)))))"
      val () = print (TreeWithCounter.show result ^ "\n\n")
      val result = AlgorithmWithBitset.run ["g(_)"] "f(g(g(f(g(x)))))"
      val () = print (TreeWithBitset.show result ^ "\n\n\n")
    in
      ()
    end
end

fun main () = Main.main ()

val () = Main.main ()
