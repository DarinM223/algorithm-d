signature NODE_TYPE =
sig
  eqtype t
  val hash: t -> word
end

signature NODE =
sig
  type 'a t
  val show: ('a -> string) -> 'a t -> string
  val follow: 'a t -> 'a -> 'a t
  val outputs: 'a t -> ('a list * int list) list
end

signature TRIE =
sig
  structure NodeType: NODE_TYPE
  structure Node: NODE
  type 'a t

  val create: unit -> NodeType.t t
  val add: NodeType.t t -> int -> NodeType.t list -> unit
  val compute: 'a t -> unit
end

functor TrieFn(NodeType: NODE_TYPE): TRIE =
struct
  structure NodeType = NodeType
  structure Node =
  struct
    datatype 'a t =
      TrieNode of
        { parent: 'a t option
        , goto: ('a, 'a t) HashTable.hash_table
        , failure: 'a t option ref
        , output: 'a t option ref
        , pattern: 'a list ref
        , matchedRules: int list ref
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
               (fn (t0, t1) =>
                  "(" ^ String.concatWith ", " [a_ t0, show t1] ^ ")") t0) ^ "]"
      fun showOption f (SOME s) = "SOME " ^ f s
        | showOption _ NONE = "NONE"
      val rec t = fn (t_0, a_) =>
        fn TrieNode
            { parent = t0
            , goto = t1
            , failure = ref t2
            , output = ref t3
            , pattern = ref t4
            , matchedRules = ref t5
            } =>
          "TrieNode " ^ "{"
          ^
          String.concatWith ", "
            [ "parent = " ^ showOption t_0 t0
            , "goto = " ^ showHashlist (t_0, a_) (HashTable.listItemsi t1)
            , "failure = " ^ "ref " ^ showOption t_0 t2
            , "output = " ^ "ref " ^ showOption t_0 t3
            , "pattern = " ^ "ref " ^ "["
              ^ String.concatWith ", " (List.map a_ t4) ^ "]"
            , "matchedRules = " ^ "ref " ^ "["
              ^ String.concatWith ", " (List.map Int.toString t5) ^ "]"
            ] ^ "}"
      val t = fn a_ => let val rec t_0 = fn ? => t (t_0, a_) ? in t_0 end
    in val show = t
    end


    fun create parent =
      TrieNode
        { parent = parent
        , goto = HashTable.mkTable (NodeType.hash, op=) (10, LibBase.NotFound)
        , failure = ref NONE
        , output = ref NONE
        , pattern = ref []
        , matchedRules = ref []
        }

    fun follow (t: 'a t) (x: 'a) =
      case HashTable.find (O #goto t) x of
        SOME target => target
      | NONE =>
          if Option.isNone (O #parent t) then t
          else follow (Option.valOf (!(O #failure t))) x

    fun outputs (t: 'a t) =
      let
        val out: ('a list * int list) list ref = ref []
        fun chase node =
          if not (List.null (!(O #pattern node))) then
            ( out := (!(O #pattern node), !(O #matchedRules node)) :: !out
            ; case !(O #output node) of
                SOME link => chase link
              | NONE => ()
            )
          else
            ()
      in
        chase t;
        !out
      end
  end

  type 'a t = {root: 'a Node.t}

  val create = fn () => {root = Node.create NONE}

  fun add (trie: NodeType.t t) rule xs =
    let
      open Node
      val node = ref (#root trie)
      fun go x =
        let
          val node' =
            case HashTable.find (O #goto (!node)) x of
              SOME node' => node'
            | NONE =>
                let val node' = create (SOME (!node))
                in HashTable.insert (O #goto (!node)) (x, node'); node'
                end
        in
          node := node'
        end
    in
      List.app go xs;
      O #pattern (!node) := xs;
      O #matchedRules (!node) := rule :: !(O #matchedRules (!node))
    end

  fun compute (trie: 'a t) =
    let
      open Node
      val root = #root trie
      val () = O #failure root := SOME root
      val q: ('a * 'a t) Queue.queue = Queue.mkQueue ()
      val () =
        HashTable.app
          (fn child =>
             ( O #failure child := SOME root
             ; HashTable.appi (fn t => Queue.enqueue (q, t)) (O #goto child)
             )) (O #goto root)
    in
      while (not (Queue.isEmpty q)) do
        let
          val (x, node) = Queue.dequeue q
          val p: 'a t = Option.valOf (O #parent node)
          val p's_failure: 'a t = Option.valOf (!(O #failure p))
          val failure = follow p's_failure x
          val () = O #failure node := SOME failure
          val output =
            case !(O #pattern failure) of
              [] => !(O #failure failure)
            | _ => SOME failure
        in
          O #output node := output;
          HashTable.appi (fn t => Queue.enqueue (q, t)) (O #goto node)
        end
    end
end
