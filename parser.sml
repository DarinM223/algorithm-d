structure PatternLrVals = PatternLrValsFun (structure Token = LrParser.Token)
structure PatternLex = PatternLexFun (structure Tokens = PatternLrVals.Tokens)
structure PatternParser =
  Join
    (structure LrParser = LrParser
     structure ParserData = PatternLrVals.ParserData
     structure Lex = PatternLex)
