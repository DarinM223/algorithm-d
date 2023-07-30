infix +`

datatype symbol = Label of string | Child of int
val symbol =
  let
    open Generic
  in
    data' (C1' "Label" string +` C1' "Child" int)
      ( fn Child ? => INR ? | Label ? => INL ?
      , fn INR ? => Child ? | INL ? => Label ?
      )
  end
val showSymbol =
  fn Label t0 => "Label " ^ "(" ^ "\"" ^ t0 ^ "\"" ^ ")"
   | Child t1 => "Child " ^ "(" ^ Int.toString t1 ^ ")"

structure Trie =
  Node
    (struct
       type t = symbol
       val hash = Generic.hash symbol
       val equal = fn (a, b) => a = b
     end)

structure Tree =
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
      val paths: symbol list list ref = ref []
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

structure LabelledTree =
struct
  open LabelledTree

  val arity: t -> int =
    fn {value = Node (_, xs), ...} => List.length xs | _ => 0
  val child: int -> t -> t = fn i =>
    fn {value = Node (_, xs), ...} => List.nth (xs, i)
     | _ => raise Fail "Must have an ith child!"
end

val parse: string -> Tree.t = raise Fail ""

fun run pattern subject =
  let
    val pattern = parse pattern
    val subject = Tree.instantiate (parse subject)
    val paths = Tree.toPaths pattern
    val trie = Trie.create ()
    val () = List.app (Trie.add trie) paths
    (* val () = Trie.compute trie *)
  in
    ()
  end
