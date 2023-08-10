structure Unsafe =
struct
  structure Basis =
  struct
    structure Array = Array
    structure Vector = Vector
    structure CharArray = CharArray
    structure CharVector = CharVector
    structure Word8Array = Word8Array
    structure Word8Vector = Word8Vector
  end

  structure Vector = struct val sub = Basis.Vector.sub end

  structure Array =
  struct
    val sub = Basis.Array.sub
    val update = Basis.Array.update
    val create = Basis.Array.array
  end

  structure CharArray =
  struct
    open Basis.CharArray
    fun create i =
      array (i, chr 0)
  end

  structure CharVector =
  struct
    open Basis.CharVector
    fun create i =
      Basis.CharArray.vector (Basis.CharArray.array (i, chr 0))
    fun update (vec, i, el) =
      raise Fail "Unimplemented: Unsafe.CharVector.update"
  end

  structure Word8Array =
  struct
    open Basis.Word8Array
    fun create i = array (i, 0w0)
  end

  structure Word8Vector =
  struct
    open Basis.Word8Vector
    fun create i =
      Basis.Word8Array.vector (Basis.Word8Array.array (i, 0w0))
    fun update (vec, i, el) =
      raise Fail "Unimplemented: Unsafe.Word8Vector.update"
  end

  structure Real64Array =
  struct
    open Basis.Array
    type elem = Real.real
    type array = elem array
    fun create i = array (i, 0.0)
  end
end;
fun useProject root' file =
  let val root = OS.FileSys.getDir ()
  in
    OS.FileSys.chDir root';
    use file;
    OS.FileSys.chDir root
  end;
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/list-format-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/dynamic-array-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/dynamic-array.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-priorityq-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/priority-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/left-priorityq-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/ord-key-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/ord-map-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/lib-base-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/lib-base.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/int-redblack-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/uref-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/simple-uref.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/int-binary-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/list-xprod-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/list-xprod.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/path-util-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/bit-array-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/bit-array.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/ord-set-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/redblack-set-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-dynamic-array-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/bsearch-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/random-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/random.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/real-order-stats.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/io-util-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/io-util.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/fifo-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-key-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-hash-table-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-table-rep.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/int-hash-table.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/list-set-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/getopt-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/getopt.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/int-redblack-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/path-util.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/int-list-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/list-map-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/splaytree-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-array-sort-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/array-qsort-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-hash-set-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-set-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/graph-scc-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/redblack-map-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/graph-scc-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/base64-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/interval-domain-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/interval-set-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-hash2-table-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/format-comb-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/format-comb.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/fnv-hash.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/binary-map-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/fifo.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/parser-comb-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/parser-comb.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/int-binary-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-table-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/array-sort-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/array-qsort.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/format-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-table-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-table.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/char-map-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-redblack-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/queue-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/queue.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/word-redblack-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-table.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/int-list-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/splaytree.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/splay-set-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/base64.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/plist-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/plist.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/keyword-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/univariate-stats.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/binary-set-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-binary-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-binary-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/target64-prime-sizes.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-redblack-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/rand-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/char-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-array-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/real-format.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/fmt-fields.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/format.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/scan-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/scan.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/interval-set-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash2-table-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/splay-map-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/word-hash-table.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/utf8-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/utf8.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/rand.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-string.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/list-format.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/dynamic-array-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/word-redblack-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/listsort-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/list-mergesort.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/uref.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/ansi-term.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/base.sig";
use "/usr/local/lib/mlton/sml/mlyacc-lib/join.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/lrtable.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/stream.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/parser2.sml";
useProject "lib/github.com/DarinM223/extended-basis" "basis.sml";
use "lib/github.com/DarinM223/prettier/public/prettier.sig";
use "lib/github.com/DarinM223/prettier/detail/prettier.sml";
use "lib/github.com/DarinM223/prettier/public/export.sml";
use "lib/github.com/DarinM223/prettier/public/infixes.sml";
use "lib/github.com/DarinM223/random/public/rng.sig";
use "lib/github.com/DarinM223/random/public/random-gen.sig";
use "lib/github.com/DarinM223/random/detail/mk-random-gen.fun";
use "lib/github.com/DarinM223/random/public/numerical-recipes.sig";
use "lib/github.com/DarinM223/random/detail/numerical-recipes.sml";
use "lib/github.com/DarinM223/random/detail/ran0-gen.sml";
use "lib/github.com/DarinM223/random/detail/ranqd1-gen.sml";
use "lib/github.com/DarinM223/random/public/random-dev.sig";
use "lib/github.com/DarinM223/random/detail/ml/common/random-dev.sml";
use "lib/github.com/DarinM223/random/public/export.sml";
use "lib/github.com/DarinM223/ds/public/node.sig";
use "lib/github.com/DarinM223/ds/detail/node.sml";
use "lib/github.com/DarinM223/ds/public/queue.sig";
use "lib/github.com/DarinM223/ds/public/linked-queue.sig";
use "lib/github.com/DarinM223/ds/detail/linked-queue.sml";
use "lib/github.com/DarinM223/ds/public/unlinkable-list.sig";
use "lib/github.com/DarinM223/ds/detail/unlinkable-list.sml";
use "lib/github.com/DarinM223/ds/public/hash-map.sig";
use "lib/github.com/DarinM223/ds/detail/hash-map.sml";
use "lib/github.com/DarinM223/ds/public/export.sml";
use "lib/github.com/DarinM223/parsec/public/sequence.sig";
use "lib/github.com/DarinM223/parsec/detail/string-sequence.sml";
use "lib/github.com/DarinM223/parsec/public/parsec.sig";
use "lib/github.com/DarinM223/parsec/detail/mk-parsec.fun";
use "lib/github.com/DarinM223/parsec/public/export.sml";
useProject "lib/github.com/DarinM223/generic" "lib-all.sml";
use "utils.sml";
use "tree.sml";
use "parser.grm.sig";
use "parser.grm.sml";
use "lexer.lex.sml";
use "parser.sml";
use "trie.sml";
use "algorithm.sml";
use "main.sml";
