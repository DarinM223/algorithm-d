datatype symbol = Label of string | Child of int
val showSymbol =
  fn Label t0 => "Label " ^ "(" ^ "\"" ^ t0 ^ "\"" ^ ")"
   | Child t1 => "Child " ^ "(" ^ Int.toString t1 ^ ")"

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
