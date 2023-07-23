structure List =
struct
  open List
  fun appi f l =
    let
      fun go acc f (x :: xs) =
            (f (acc, x); go (acc + 1) f xs)
        | go _ _ [] = ()
    in
      go 0 f l
    end
end
