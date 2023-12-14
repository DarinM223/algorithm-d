structure PatternLrVals = PatternLrValsFun (structure Token = LrParser.Token)
structure PatternLex = PatternLexFun (structure Tokens = PatternLrVals.Tokens)
structure PatternParser =
  Join
    (structure LrParser = LrParser
     structure ParserData = PatternLrVals.ParserData
     structure Lex = PatternLex)

structure Parser =
struct
  fun invoke lexstream =
    let
      fun print_error (s, i: int, _) =
        TextIO.output
          (TextIO.stdOut, "Error, line " ^ (Int.toString i) ^ ", " ^ s ^ "\n")
    in
      PatternParser.parse (0, lexstream, print_error, ())
    end

  fun parse s : Tree.t =
    let
      val inputString = TextIO.openString s
      val lexer = PatternParser.makeLexer (fn n =>
        TextIO.inputN (inputString, n))
      val dummyEOF = PatternLrVals.Tokens.EOF (0, 0)
      val resultTree = ref Tree.Wildcard
      fun loop lexer =
        let
          val (result: Tree.t option, lexer) = invoke lexer
          val (nextToken, lexer) = PatternParser.Stream.get lexer
        in
          case result of
            SOME r => resultTree := r
          | NONE => ();
          if PatternParser.sameToken (nextToken, dummyEOF) then ()
          else loop lexer
        end
    in
      loop lexer;
      !resultTree
    end
end
