signature NodeType =
sig
  type t
  val hash: t -> word
  val equal: t * t -> bool
end

functor Node(NodeType: NodeType) =
struct
  datatype 'a t =
    TrieNode of
      { parent: 'a t option
      , goto: ('a, 'a t) HashTable.hash_table
      , suffix: 'a t option ref
      , output: 'a t option ref
      , pattern: 'a list ref
      }
  fun O m (TrieNode t) = m t

  local
    type 'a hashlist = ('a * 'a t) list
    val showHashlist = fn (show, a_) =>
      fn t0 =>
        "["
        ^
        String.concatWith ", "
          (List.map
             (fn (t0, t1) => "(" ^ String.concatWith ", " [a_ t0, show t1] ^ ")")
             t0) ^ "]"
    fun showOption f (SOME s) = "SOME " ^ f s
      | showOption _ NONE = "NONE"
    val rec t = fn (t_0, a_) =>
      fn TrieNode
          { parent = t0
          , goto = t1
          , suffix = ref t2
          , output = ref t3
          , pattern = ref t4
          } =>
        "TrieNode " ^ "{"
        ^
        String.concatWith ", "
          [ "parent = " ^ showOption t_0 t0
          , "goto = " ^ showHashlist (t_0, a_) (HashTable.listItemsi t1)
          , "suffix = " ^ "ref " ^ showOption t_0 t2
          , "output = " ^ "ref " ^ showOption t_0 t3
          , "pattern = " ^ "ref " ^ "["
            ^ String.concatWith ", " (List.map a_ t4) ^ "]"
          ] ^ "}"
    val t = fn a_ => let val rec t_0 = fn ? => t (t_0, a_) ? in t_0 end
  in val show = t
  end

  fun create' parent =
    TrieNode
      { parent = parent
      , goto =
          HashTable.mkTable (NodeType.hash, NodeType.equal)
            (10, LibBase.NotFound)
      , suffix = ref NONE
      , output = ref NONE
      , pattern = ref []
      }

  type 'a t = {root: 'a t}

  val create = fn () => {root = create' NONE}

  fun add (trie: NodeType.t t) xs =
    let
      val node = ref (#root trie)
      fun go x =
        let
          val node' =
            case HashTable.find (O #goto (!node)) x of
              SOME node' => node'
            | NONE =>
                let val node' = create' (SOME (!node))
                in HashTable.insert (O #goto (!node)) (x, node'); node'
                end
        in
          node := node'
        end
    in
      List.app go xs;
      O #pattern (!node) := xs
    end
end
