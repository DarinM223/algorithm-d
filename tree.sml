signature P =
sig
  type 'a t
end

functor TreeFn(P: P) =
struct datatype t' = Node of string * t list | Wildcard withtype t = t' P.t end

structure Tree = TreeFn (struct type 'a t = 'a end)

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
