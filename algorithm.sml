structure Symbol =
struct
  infix +`
  datatype t = Label of string | Child of int
  val t =
    let
      open Sum Generic
    in
      data' (C1' "Label" string +` C1' "Child" int)
        ( fn Child ? => INR ? | Label ? => INL ?
        , fn INR ? => Child ? | INL ? => Label ?
        )
    end
end

structure Trie =
  TrieFn (type t = Symbol.t val hash = Word32.toWord o Generic.hash Symbol.t)

structure Tree =
struct
  open Tree

  (* Creates a labelled tree from the main tree to do matches on. *)
  fun instantiate (t: Tree.t) : TreeWithCounter.t =
    case t of
      Tree.Node (x, xs) =>
        let
          val xs' = List.map instantiate xs
        in
          { value = TreeWithCounter.Node (x, xs')
          , hits = ref 0
          , matches = ref false
          }
        end
    | Tree.Wildcard => raise Fail "Cannot instantiate pattern"

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

structure Algorithm =
struct
  fun run pattern subject =
    let
      open Symbol
      val pattern = Parser.parse pattern
      val subject = Tree.instantiate (Parser.parse subject)
      val paths = Tree.toPaths pattern
      val trie = Trie.create ()
      val () = List.app (Trie.add trie) paths
      val () = Trie.compute trie
      val first = Trie.Node.follow (#root trie) (TreeWithCounter.label subject)
      val label = {node = subject, state = first, visited = ref ~1}
      val stack = S.array (100, label)
      val () = S.push (stack, label)
      fun tabulate state =
        let
          val outs = Trie.Node.outputs state
          fun register out =
            let
              val out' = List.filter (fn Label _ => true | _ => false) out
              val len = List.length out'
              val entry = S.sub (stack, S.length stack - len)
              val () = #hits (#node entry) := !(#hits (#node entry)) + 1
            in
              if !(#hits (#node entry)) = List.length paths then
                #matches (#node entry) := true
              else
                ()
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
      print (TreeWithCounter.show subject ^ "\n")
    end
end
