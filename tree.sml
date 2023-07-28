signature P =
sig
  type 'a t
  val show: ('a -> string) -> 'a t -> string
end

functor TreeFn(P: P) =
struct
  datatype t' = Node of string * t list | Wildcard
  withtype t = t' P.t
  local
    val rec t = fn t'_1 => P.show t'_1
    and rec t' = fn t_0 =>
      fn Node (t0, t1) =>
        "Node " ^ "("
        ^
        String.concatWith ", "
          [ "\"" ^ t0 ^ "\""
          , "[" ^ String.concatWith ", " (List.map t_0 t1) ^ "]"
          ] ^ ")"
       | Wildcard => "Wildcard"
    val t_t' = fn () =>
      let val rec t'_1 = fn ? => t' t_0 ? and rec t_0 = fn ? => t t'_1 ?
      in (t_0, t'_1)
      end
  in val show = #1 (t_t' ()) val showT' = #2 (t_t' ())
  end
end

structure Tree = TreeFn (struct type 'a t = 'a val show = fn f => f end)

structure Labelled =
struct
  type 'a t = {value: 'a, hits: int ref, matches: bool ref}
  val show = fn a_ =>
    fn {value = t0, hits = ref t1, matches = ref t2} =>
      "{"
      ^
      String.concatWith ", "
        [ "value = " ^ a_ t0
        , "hits = " ^ "ref " ^ Int.toString t1
        , "matches = " ^ "ref " ^ Bool.toString t2
        ] ^ "}"
end

structure LabelledTree = TreeFn(Labelled)
