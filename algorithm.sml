structure Symbol =
struct
  infix +`
  datatype t = Label of string | Child of int
  val show =
    fn Label t0 => "Label " ^ "(" ^ "\"" ^ t0 ^ "\"" ^ ")"
     | Child t1 => "Child " ^ "(" ^ Int.toString t1 ^ ")"
  local
    val combine = fn (a, b) => 0w31 * a + b
    val hashString =
      #1
      o
      Substring.foldl
        (fn (ch, (h, p)) =>
           ( Word.mod (h + Word.fromInt (Char.ord ch + 1) * p, 0w1000000009)
           , Word.mod (p * 0w31, 0w1000000009)
           )) (0w0, 0w1) o Substring.full
  in
    val hash =
      fn Label t0 => combine (hashString "Label", hashString t0)
       | Child t1 => combine (hashString "Child", Word.fromInt t1)
  end
end

structure Trie = TrieFn (type t = Symbol.t val hash = Symbol.hash)

structure Tree =
struct
  open Tree

  (* Returns a list of all paths from the pattern tree. *)
  fun toPaths tree =
    let
      open Symbol
      val paths: t list list ref = ref []
      fun go acc (Tree.Node (f, [])) =
            paths := List.rev (Label (f ^ "0") :: acc) :: !paths
        | go acc (Tree.Node (f, xs)) =
            List.appi
              (fn (i, x) =>
                 go
                   (Child i :: Label (f ^ Int.toString (List.length xs)) :: acc)
                   x) xs
        | go acc Tree.Wildcard =
            paths := List.rev acc :: !paths
    in
      go [] tree;
      !paths
    end

  val largestPathSize =
    foldl (fn (path, acc) => Int.max (length path, acc)) 0 o toPaths

  (* Creates a labelled counter tree from the main tree to do matches on. *)
  fun instantiateCounter numRules (t: Tree.t) : TreeWithCounter.t =
    case t of
      Tree.Node (x, xs) =>
        let
          val xs' = List.map (instantiateCounter numRules) xs
        in
          { value = TreeWithCounter.Node (x, xs')
          , hits = Array.array (numRules, 0)
          , matches = ref []
          }
        end
    | Tree.Wildcard => raise Fail "Cannot instantiate pattern"

  fun instantiateBitset mkBitset (t: Tree.t) : TreeWithBitset.t =
    let
      fun go t =
        case t of
          Tree.Node (x, xs) =>
            let
              val xs' = List.map go xs
            in
              { value = TreeWithBitset.Node (x, xs')
              , bitset = mkBitset ()
              , matches = ref []
              }
            end
        | Tree.Wildcard => raise Fail "Cannot instantiate pattern"
    in
      go t
    end
end

structure S =
struct
  open DynamicArray

  val top = fn v => DynamicArray.sub (v, DynamicArray.bound v)
  val push = fn (v, e) => DynamicArray.update (v, DynamicArray.bound v + 1, e)
  val length = fn v => DynamicArray.bound v + 1
  val isEmpty = fn v => length v <= 0
  val pop = fn v => top v before DynamicArray.truncate (v, DynamicArray.bound v)
end

structure TreeWithCounter =
struct
  open TreeWithCounter

  val label: t -> Symbol.t =
    fn {value = Node (x, xs), ...} =>
      Symbol.Label (x ^ Int.toString (List.length xs))
     | _ => raise Fail "Tree must be root labelled!"
  val arity: t -> int =
    fn {value = Node (_, xs), ...} => List.length xs | _ => 0
  val child: int -> t -> t = fn i =>
    fn {value = Node (_, xs), ...} => List.nth (xs, i)
     | _ => raise Fail "Must have an ith child!"
end

structure TreeWithBitset =
struct
  open TreeWithBitset

  val label: t -> Symbol.t =
    fn {value = Node (x, xs), ...} =>
      Symbol.Label (x ^ Int.toString (List.length xs))
     | _ => raise Fail "Tree must be root labelled!"
  val arity: t -> int =
    fn {value = Node (_, xs), ...} => List.length xs | _ => 0
  val child: int -> t -> t = fn i =>
    fn {value = Node (_, xs), ...} => List.nth (xs, i)
     | _ => raise Fail "Must have an ith child!"
end

signature ALGORITHM =
sig
  structure ResultTree: TREE
  val run: string list -> string -> ResultTree.t
end

structure Algorithm: ALGORITHM =
struct
  structure ResultTree = TreeWithCounter
  fun run patterns subject =
    let
      open Symbol
      val patterns = List.map Parser.parse patterns
      val subject =
        Tree.instantiateCounter (List.length patterns) (Parser.parse subject)
      val patternPaths =
        List.foldl
          (fn ((i, tree), acc) =>
             IntRedBlackMap.insert (acc, i, Tree.toPaths tree))
          IntRedBlackMap.empty
          (ListPair.zip
             (List.tabulate (List.length patterns, fn i => i), patterns))
      val trie = Trie.create ()
      val () =
        IntRedBlackMap.appi (fn (i, paths) => List.app (Trie.add trie i) paths)
          patternPaths
      val () = Trie.compute trie
      val first = Trie.Node.follow (#root trie) (TreeWithCounter.label subject)
      val label = {node = subject, state = first, visited = ref ~1}
      val stack = S.array (100, label)
      val () = S.push (stack, label)
      fun tabulate state =
        let
          val outs = Trie.Node.outputs state
          fun register (out, rules) =
            let
              val out' = List.filter (fn Label _ => true | _ => false) out
              val len = List.length out'
              val entry = S.sub (stack, S.length stack - len)
              fun updateRule rule =
                let
                  val hits' = Array.sub (#hits (#node entry), rule) + 1
                  val matchHits = List.length
                    (IntRedBlackMap.lookup (patternPaths, rule))
                in
                  Array.update (#hits (#node entry), rule, hits');
                  if hits' = matchHits then
                    #matches (#node entry) := rule :: !(#matches (#node entry))
                  else
                    ()
                end
            in
              List.app updateRule rules
            end
        in
          List.app register outs
        end
      val () = tabulate first
    in
      while not (S.isEmpty stack) do
        let
          val {node, state, visited} = S.top stack
        in
          if !visited = TreeWithCounter.arity node - 1 then
            ignore (S.pop stack)
          else
            let
              val () = visited := !visited + 1
              val intState = Trie.Node.follow state (Child (!visited))
              val () = tabulate intState
              val node' = TreeWithCounter.child (!visited) node
              val state' =
                Trie.Node.follow intState (TreeWithCounter.label node')
            in
              S.push (stack, {node = node', state = state', visited = ref ~1});
              tabulate state'
            end
        end;
      subject
    end
end

structure AlgorithmWithBitset: ALGORITHM =
struct
  structure ResultTree = TreeWithBitset
  fun run patterns subject =
    let
      open Symbol
      val patterns = List.map Parser.parse patterns
      val largestPathSizes =
        List.map (fn pattern => Tree.largestPathSize pattern + 1) patterns
      val subject =
        Tree.instantiateBitset
          (fn () =>
             Vector.fromList (List.map Word8BitVector.create largestPathSizes))
          (Parser.parse subject)
      val patternPaths = List.map Tree.toPaths patterns
      val trie = Trie.create ()
      val () =
        List.appi (fn (i, paths) => List.app (Trie.add trie i) paths)
          patternPaths
      val () = Trie.compute trie
      val first = Trie.Node.follow (#root trie) (TreeWithBitset.label subject)
      val label = {node = subject, state = first, visited = ref ~1}
      val stack = S.array (100, label)
      val () = S.push (stack, label)
      fun tabulate (node: TreeWithBitset.t) state isArity =
        let
          val outs = Trie.Node.outputs state
          fun register (out, rules) =
            let
              val out' = List.filter (fn Label _ => true | _ => false) out
              (* If the path matches when following an arity, we set the length at the child's depth *)
              val len =
                if isArity then List.length out' else List.length out' - 1
            in
              List.app
                (fn rule =>
                   Word8BitVector.set len true (Vector.sub (#bitset node, rule)))
                rules;
              if len = 0 then #matches node := rules else ()
            end
        in
          List.app register outs
        end
      fun merge (node: TreeWithBitset.t) =
        case node of
          {value = TreeWithBitset.Node (_, child :: children), ...} =>
            let
              open Word8BitVector MLtonVector
              val bitset = Vector.map clone (#bitset child)
              val matchingRules = fn (rule, bits, acc) =>
                if Word8BitVector.get 0 bits then rule :: acc else acc
            in
              (* For every child of node, shift its bit string right 1 bit
                 and bitwise and them together (logical product), then bitwise or
                 the result with the original bit string *)
              List.app
                (fn child =>
                   foreach2 (bitset, #bitset child, fn (a, b) => andd a b))
                children;
              Vector.app (shr 1) bitset;
              foreach2 (#bitset node, bitset, fn (a, b) => or a b);
              #matches node := Vector.foldli matchingRules [] (#bitset node)
            end
        | _ => ()
      val () = tabulate subject first false
    in
      while not (S.isEmpty stack) do
        let
          val {node, state, visited} = S.top stack
        in
          if !visited = TreeWithBitset.arity node - 1 then
            (merge node; ignore (S.pop stack))
          else
            let
              val () = visited := !visited + 1
              val intState = Trie.Node.follow state (Child (!visited))
              val node' = TreeWithBitset.child (!visited) node
              val () = tabulate node' intState true
              val state' =
                Trie.Node.follow intState (TreeWithBitset.label node')
              val () = tabulate node' state' false
            in
              S.push (stack, {node = node', state = state', visited = ref ~1})
            end
        end;
      subject
    end
end
