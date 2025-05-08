structure Int64 = Int63
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
(* Uncomment this and put library files in here to prevent reloading them each time. *)
(*
PolyML.SaveState.loadState "save" handle _ => (
PolyML.SaveState.saveState "save" );
*)
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-buffer/mono-buffer.sig";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-buffer/mono-buffer.fun";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-buffer/mono-buffer.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-vector.sig";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-vector.fun";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-vector-slice.sig";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-vector-slice.fun";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-array.sig";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-array.fun";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-array-slice.sig";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-array-slice.fun";
use "/usr/local/lib/mlton/sml/smlnj-lib/Compat/mono-sequence/mono-vector-slice.sml";
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
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/Target64Bit/native.sml";
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
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/base64-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/base64.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/Target64Bit/random.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/real-order-stats.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/edit-distance.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/io-util-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/io-util.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/fifo-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/hash-key-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/mono-hash-table-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/max-hash-table-size.sml";
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
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/plist-sig.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/plist.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/keyword-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/univariate-stats.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/binary-set-fn.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-binary-set.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/atom-binary-map.sml";
use "/usr/local/lib/mlton/sml/smlnj-lib/Util/Target64Bit/prime-sizes.sml";
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
use "lib/github.com/DarinM223/sml-bitvector/bitvector.sig";
use "lib/github.com/DarinM223/sml-bitvector/bitvector.sml";
use "lib/github.com/DarinM223/mlton-vector/utils.sml";
use "lib/github.com/DarinM223/mlton-vector/vector.sig";
use "lib/github.com/DarinM223/mlton-vector/vector.fun";
use "lib/github.com/DarinM223/mlton-vector/vector-generic.fun";
use "lib/github.com/DarinM223/mlton-vector/vector.polyml.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/base.sig";
use "/usr/local/lib/mlton/sml/mlyacc-lib/join.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/lrtable.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/stream.sml";
use "/usr/local/lib/mlton/sml/mlyacc-lib/parser2.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/basis.common.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/basis.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/detail/bootstrap.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/ext.common.sml";
use "lib/github.com/DarinM223/extended-basis/public/typing/phantom.sig";
use "lib/github.com/DarinM223/extended-basis/detail/typing/phantom.sml";
use "lib/github.com/DarinM223/extended-basis/public/typing/static-sum.sig";
use "lib/github.com/DarinM223/extended-basis/detail/typing/static-sum.sml";
use "lib/github.com/DarinM223/extended-basis/public/concept/bitwise.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/bounded.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/cased.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/cstringable.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/empty.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/equality.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/etaexp.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/flags.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/func.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/intable.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/largeable.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/monad.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/ordered.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/scannable.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/shiftable.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/signed.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/stringable.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/t.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/wordable.sig";
use "lib/github.com/DarinM223/extended-basis/public/concept/formattable.sig";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-bounded.fun";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-equality.fun";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-scannable.fun";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-stringable.fun";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-cstringable.fun";
use "lib/github.com/DarinM223/extended-basis/public/typing/void.sig";
use "lib/github.com/DarinM223/extended-basis/public/fn/fn.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/fn.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/cps.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/cps.sml";
use "lib/github.com/DarinM223/extended-basis/public/basic.sig";
use "lib/github.com/DarinM223/extended-basis/detail/basic.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/id.sig";
use "lib/github.com/DarinM223/extended-basis/public/data/unit.sig";
use "lib/github.com/DarinM223/extended-basis/public/data/sq.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/sq.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/bin-fn.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/bin-fn.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/un-op.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/un-op.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/thunk.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/thunk.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/univ.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/univ-ref.sml";
use "lib/github.com/DarinM223/extended-basis/detail/data/univ-exn.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/univ.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/bin-op.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/bin-op.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/effect.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/effect.sml";
use "lib/github.com/DarinM223/extended-basis/public/generic/fix.sig";
use "lib/github.com/DarinM223/extended-basis/detail/generic/fix.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/un-pr.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/un-pr.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/order.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/order.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/bin-pr.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/bin-pr.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/cmp.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fn/cmp.sml";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-ordered.fun";
use "lib/github.com/DarinM223/extended-basis/public/data/ref.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/ref.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/bool.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/bool.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/product-type.sig";
use "lib/github.com/DarinM223/extended-basis/public/data/pair.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/pair.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/product.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/product.sml";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-monad.fun";
use "lib/github.com/DarinM223/extended-basis/public/control/with.sig";
use "lib/github.com/DarinM223/extended-basis/detail/control/with.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/sum.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/sum.sml";
use "lib/github.com/DarinM223/extended-basis/public/control/exn.sig";
use "lib/github.com/DarinM223/extended-basis/detail/control/exn.sml";
use "lib/github.com/DarinM223/extended-basis/public/debug/contract.sig";
use "lib/github.com/DarinM223/extended-basis/detail/debug/contract.sml";
use "lib/github.com/DarinM223/extended-basis/public/generic/emb.sig";
use "lib/github.com/DarinM223/extended-basis/detail/generic/emb.sml";
use "lib/github.com/DarinM223/extended-basis/public/generic/iso.sig";
use "lib/github.com/DarinM223/extended-basis/detail/generic/iso.sml";
use "lib/github.com/DarinM223/extended-basis/public/fold/fold.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fold/fold.sml";
use "lib/github.com/DarinM223/extended-basis/public/fold/fru.sig";
use "lib/github.com/DarinM223/extended-basis/detail/fold/fru.sml";
use "lib/github.com/DarinM223/extended-basis/public/generic/tie.sig";
use "lib/github.com/DarinM223/extended-basis/detail/generic/tie.sml";
use "lib/github.com/DarinM223/extended-basis/public/sequence/array.sig";
use "lib/github.com/DarinM223/extended-basis/public/sequence/array-slice.sig";
use "lib/github.com/DarinM223/extended-basis/public/sequence/vector.sig";
use "lib/github.com/DarinM223/extended-basis/public/sequence/vector-slice.sig";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/mk-seq-common-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/array.sml";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/array-slice.sml";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/vector.sml";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/vector-slice.sml";
use "lib/github.com/DarinM223/extended-basis/public/data/option.sig";
use "lib/github.com/DarinM223/extended-basis/detail/data/option.sml";
use "lib/github.com/DarinM223/extended-basis/public/numeric/integer.sig";
use "lib/github.com/DarinM223/extended-basis/public/numeric/int-inf.sig";
use "lib/github.com/DarinM223/extended-basis/public/numeric/real.sig";
use "lib/github.com/DarinM223/extended-basis/public/numeric/word.sig";
use "lib/github.com/DarinM223/extended-basis/detail/numeric/mk-integer-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/numeric/mk-int-inf-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/numeric/mk-real-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/numeric/mk-word-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/ml/scalars.common.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/ints.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/reals.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/words.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/public/sequence/list.sig";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/list.sml";
use "lib/github.com/DarinM223/extended-basis/public/sequence/buffer.sig";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/mk-buffer-common.fun";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/buffer.sml";
use "lib/github.com/DarinM223/extended-basis/public/sequence/resizable-array.sig";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/resizable-array.sml";
use "lib/github.com/DarinM223/extended-basis/public/io/reader.sig";
use "lib/github.com/DarinM223/extended-basis/detail/io/reader.sml";
use "lib/github.com/DarinM223/extended-basis/public/io/writer.sig";
use "lib/github.com/DarinM223/extended-basis/detail/io/writer.sml";
use "lib/github.com/DarinM223/extended-basis/public/io/ios-monad.sig";
use "lib/github.com/DarinM223/extended-basis/detail/io/ios-monad.sml";
use "lib/github.com/DarinM223/extended-basis/public/control/exit.sig";
use "lib/github.com/DarinM223/extended-basis/detail/control/exit.sml";
use "lib/github.com/DarinM223/extended-basis/public/sequence/mono-vector.sig";
use "lib/github.com/DarinM223/extended-basis/public/sequence/mono-vector-slice.sig";
use "lib/github.com/DarinM223/extended-basis/public/sequence/mono-array.sig";
use "lib/github.com/DarinM223/extended-basis/public/sequence/mono-array-slice.sig";
use "lib/github.com/DarinM223/extended-basis/public/text/char.sig";
use "lib/github.com/DarinM223/extended-basis/public/text/string.sig";
use "lib/github.com/DarinM223/extended-basis/public/text/substring.sig";
use "lib/github.com/DarinM223/extended-basis/public/text/text.sig";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/mk-mono-seq-common-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/mk-mono-vector-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/mk-mono-vector-slice-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/mk-mono-array-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/mk-mono-array-slice-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/text/mk-text-ext.fun";
use "lib/github.com/DarinM223/extended-basis/detail/ml/mono-seqs.common.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/mono-vectors.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/mono-vector-slices.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/mono-arrays.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/mono-array-slices.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/detail/ml/texts.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/public/sequence/stream.sig";
use "lib/github.com/DarinM223/extended-basis/detail/sequence/stream.sml";
use "lib/github.com/DarinM223/extended-basis/public/control/iter.sig";
use "lib/github.com/DarinM223/extended-basis/detail/control/iter.sml";
use "lib/github.com/DarinM223/extended-basis/public/lazy/lazy.sig";
use "lib/github.com/DarinM223/extended-basis/detail/lazy/lazy.sml";
use "lib/github.com/DarinM223/extended-basis/public/fn/shift-op.sig";
use "lib/github.com/DarinM223/extended-basis/public/io/text-io.sig";
use "lib/github.com/DarinM223/extended-basis/detail/io/text-io.sml";
use "lib/github.com/DarinM223/extended-basis/public/os/os-file-sys.sig";
use "lib/github.com/DarinM223/extended-basis/public/os/os.sig";
use "lib/github.com/DarinM223/extended-basis/detail/os/os.sml";
use "lib/github.com/DarinM223/extended-basis/detail/concept/mk-word-flags.fun";
use "lib/github.com/DarinM223/extended-basis/public/time/time.sig";
use "lib/github.com/DarinM223/extended-basis/detail/time/time.sml";
use "lib/github.com/DarinM223/extended-basis/public/text/cvt.sig";
use "lib/github.com/DarinM223/extended-basis/detail/text/cvt.sml";
use "lib/github.com/DarinM223/extended-basis/public/export/export.polyml.sml";
use "lib/github.com/DarinM223/extended-basis/public/export/export.common.sml";
use "lib/github.com/DarinM223/extended-basis/public/export/top-level.sml";
use "lib/github.com/DarinM223/extended-basis/public/export/open-top-level.sml";
use "lib/github.com/DarinM223/extended-basis/public/export/infixes.sml";
use "utils.sml";
use "tree.sml";
use "parser.grm.sig";
use "parser.grm.sml";
use "lexer.lex.sml";
use "parser.sml";
use "trie.sml";
use "algorithm.sml";
use "main.sml";
