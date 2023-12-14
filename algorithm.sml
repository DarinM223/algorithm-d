
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

structure Tree1 =
struct
  open Tree

  (* Creates a labelled tree from the main tree to do matches on. *)
  fun instantiate (t: Tree.t) : LabelledTree.t =
    case t of
      Tree.Node (x, xs) =>
        let
          val xs' = List.map instantiate xs
        in
          { value = LabelledTree.Node (x, xs')
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

structure Vector1 =
struct
  type 'a t = 'a DynamicArray.array * int ref

  fun mkVector t = (DynamicArray.array t, ref 0)
  fun top (vec, len) =
    DynamicArray.sub (vec, !len - 1)
  fun push (vec, len) v =
    (DynamicArray.update (vec, !len, v); len := !len + 1)
  fun isEmpty (_, len) = !len <= 0
  fun length (_, len) = !len
  fun sub (vec, _) a = DynamicArray.sub (vec, a)
  fun update (vec, _) a b = DynamicArray.update (vec, a, b)
  fun pop (vec as (_, len)) =
    top vec before len := !len - 1
end

structure LabelledTree1 =
struct
  open LabelledTree

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
      val subject = Tree1.instantiate (Parser.parse subject)
      val paths = Tree1.toPaths pattern
      val trie = Trie.create ()
      val () = List.app (Trie.add trie) paths
      val () = Trie.compute trie
      val first = Trie.Node.follow (#root trie) (LabelledTree1.label subject)
      val label = {node = subject, state = first, visited = ref ~1}
      val stack = Vector1.mkVector (100, label)
      val () = Vector1.push stack label
      fun tabulate state =
        let
          val outs = Trie.Node.outputs state
          fun register out =
            let
              val out' = List.filter (fn Label _ => true | _ => false) out
              val len = List.length out'
              val entry = Vector1.sub stack (Vector1.length stack - len)
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
      while not (Vector1.isEmpty stack) do
        let
          val {node, state, visited} = Vector1.top stack
        in
          if !visited = LabelledTree1.arity node - 1 then
            ignore (Vector1.pop stack)
          else
            let
              val () = visited := !visited + 1
              val intState = Trie.Node.follow state (Child (!visited))
              val () = tabulate intState
              val node' = LabelledTree1.child (!visited) node
              val state' = Trie.Node.follow intState (LabelledTree1.label node')
            in
              Vector1.push stack {node = node', state = state', visited = ref ~1};
              tabulate state'
            end
        end;
      print (LabelledTree.show subject ^ "\n")
    end
end
