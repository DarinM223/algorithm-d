structure Lex =
struct
  structure UserDeclarations =
  struct
    (*#line 1.1 "lexer.lex"*)
    datatype lexresult =
      LPAREN
    | RPAREN
    | COMMA
    | WILD
    | ID of string
    | EOF
    val showLexresult =
      fn LPAREN => "LPAREN"
       | RPAREN => "RPAREN"
       | COMMA => "COMMA"
       | WILD => "WILD"
       | ID t0 => "ID " ^ "(" ^ "\"" ^ t0 ^ "\"" ^ ")"
       | EOF => "EOF"

    val eof = fn () => EOF

  (*#line 9.1 "lexer.lex.sml"*)
  end (* end of user routines *)
  exception LexError (* raised if illegal leaf action tried *)
  structure Internal =
  struct

    datatype yyfinstate = N of int
    type statedata = {fin: yyfinstate list, trans: string}
    (* transition & final state table *)
    val tab =
      let
        val s =
          [ ( 0
            , "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000"
            )
          , ( 1
            , "\000\000\000\000\000\000\000\000\000\008\009\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\008\000\000\000\000\000\000\000\007\006\000\000\005\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\
              \\003\003\003\003\003\003\003\003\003\003\003\000\000\000\000\004\
              \\000\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\
              \\003\003\003\003\003\003\003\003\003\003\003\000\000\000\000\000\
              \\000"
            )
          , ( 3
            , "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\
              \\003\003\003\003\003\003\003\003\003\003\003\000\000\000\000\000\
              \\000\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\
              \\003\003\003\003\003\003\003\003\003\003\003\000\000\000\000\000\
              \\000"
            )
          , ( 8
            , "\000\000\000\000\000\000\000\000\000\008\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\008\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
              \\000"
            )
          , (0, "")
          ]
        fun f x = x
        val s = List.map f (List.rev (tl (List.rev s)))
        exception LexHackingError
        fun look ((j, x) :: r, i: int) =
              if i = j then x else look (r, i)
          | look ([], i) = raise LexHackingError
        fun g {fin = x, trans = i} =
          {fin = x, trans = look (s, i)}
      in
        Vector.fromList (List.map g
          [ {fin = [], trans = 0}
          , {fin = [], trans = 1}
          , {fin = [], trans = 1}
          , {fin = [(N 15)], trans = 3}
          , {fin = [(N 12)], trans = 0}
          , {fin = [(N 10)], trans = 0}
          , {fin = [(N 8)], trans = 0}
          , {fin = [(N 6)], trans = 0}
          , {fin = [(N 4)], trans = 8}
          , {fin = [(N 1)], trans = 0}
          ])
      end
    structure StartStates =
    struct
      datatype yystartstate = STARTSTATE of int

      (* start state definitions *)

      val INITIAL = STARTSTATE 1;

    end
    type result = UserDeclarations.lexresult
    exception LexerError (* raised if illegal leaf action tried *)
  end

  structure YYPosInt: INTEGER = Int
  fun makeLexer yyinput =
    let
      val yygone0 = YYPosInt.fromInt ~1
      val yyb = ref "\n" (* buffer *)
      val yybl = ref 1 (*buffer length *)
      val yybufpos = ref 1 (* location of next character to use *)
      val yygone = ref yygone0 (* position in file of beginning of buffer *)
      val yydone = ref false (* eof found yet? *)
      val yybegin = ref 1 (*Current 'start state' for lexer *)

      val YYBEGIN = fn (Internal.StartStates.STARTSTATE x) => yybegin := x

      fun lex () : Internal.result =
        let
          fun continue () = lex ()
        in
          let
            fun scan (s, AcceptingLeaves: Internal.yyfinstate list list, l, i0) =
              let
                fun action (i, nil) = raise LexError
                  | action (i, nil :: l) =
                      action (i - 1, l)
                  | action (i, (node :: acts) :: l) =
                      case node of
                        Internal.N yyk =>
                          (let
                             fun yymktext () =
                               String.substring (!yyb, i0, i - i0)
                             val yypos =
                               YYPosInt.+ (YYPosInt.fromInt i0, !yygone)
                             open UserDeclarations Internal.StartStates
                           in
                             ( yybufpos := i
                             ; case yyk of

                               (* Application actions *)
                                 1 =>
                                   ( (*#line 15.8 "lexer.lex"*)
                                     lex () (*#line 124.1 "lexer.lex.sml"*))
                               | 10 =>
                                   ( (*#line 19.9 "lexer.lex"*)
                                     COMMA (*#line 126.1 "lexer.lex.sml"*))
                               | 12 =>
                                   ( (*#line 20.9 "lexer.lex"*)
                                     WILD (*#line 128.1 "lexer.lex.sml"*))
                               | 15 =>
                                   let
                                     val yytext = yymktext ()
                                   in (*#line 21.14 "lexer.lex"*)
                                     ID yytext (*#line 130.1 "lexer.lex.sml"*)
                                   end
                               | 4 =>
                                   ( (*#line 16.11 "lexer.lex"*)
                                     lex () (*#line 132.1 "lexer.lex.sml"*))
                               | 6 =>
                                   ( (*#line 17.9 "lexer.lex"*)
                                     LPAREN (*#line 134.1 "lexer.lex.sml"*))
                               | 8 =>
                                   ( (*#line 18.9 "lexer.lex"*)
                                     RPAREN (*#line 136.1 "lexer.lex.sml"*))
                               | _ => raise Internal.LexerError

                             )
                           end)

                val {fin, trans} = Vector.sub (Internal.tab, s)
                val NewAcceptingLeaves = fin :: AcceptingLeaves
              in
                if l = !yybl then
                  if trans = #trans (Vector.sub (Internal.tab, 0)) then
                    action (l, NewAcceptingLeaves)
                  else
                    let
                      val newchars = if !yydone then "" else yyinput 1024
                    in
                      if (String.size newchars) = 0 then
                        ( yydone := true
                        ; if (l = i0) then UserDeclarations.eof ()
                          else action (l, NewAcceptingLeaves)
                        )
                      else
                        ( if i0 = l then
                            yyb := newchars
                          else
                            yyb
                            := String.substring (!yyb, i0, l - i0) ^ newchars
                        ; yygone := YYPosInt.+ (!yygone, YYPosInt.fromInt i0)
                        ; yybl := String.size (!yyb)
                        ; scan (s, AcceptingLeaves, l - i0, 0)
                        )
                    end
                else
                  let
                    val NewChar = Char.ord (CharVector.sub (!yyb, l))
                    val NewChar = if NewChar < 128 then NewChar else 128
                    val NewState = Char.ord (CharVector.sub (trans, NewChar))
                  in
                    if NewState = 0 then action (l, NewAcceptingLeaves)
                    else scan (NewState, NewAcceptingLeaves, l + 1, i0)
                  end
              end
          (*
          	val start= if String.substring(!yyb,!yybufpos-1,1)="\n"
          then !yybegin+1 else !yybegin
          *)
          in
            scan (!yybegin (* start *), nil, !yybufpos, !yybufpos)
          end
        end
    in
      lex
    end
end