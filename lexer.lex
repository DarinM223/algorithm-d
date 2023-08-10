(* All of these type aliases are necessary to work with mlyacc *)
(* Tokens is the structure passed as a parameter to PatternLexFun *)
type pos = int
type svalue = Tokens.svalue
type ('a, 'b) token = ('a, 'b) Tokens.token
type lexresult = (svalue, pos) token

(* pos is necessary to work with mlyacc *)
val pos = ref 0
val eof = fn () => Tokens.EOF (!pos, !pos)

%%

%header (functor PatternLexFun(structure Tokens : Pattern_TOKENS));

alpha=[A-Za-z];
digit=[0-9];
ws=[\ \t];

%%

\n => (pos := !pos + 1; lex());
{ws}+ => (lex());
"(" => (Tokens.LPAREN (!pos, !pos));
")" => (Tokens.RPAREN (!pos, !pos));
"," => (Tokens.COMMA (!pos, !pos));
"_" => (Tokens.WILD (!pos, !pos));
{alpha}+ => (Tokens.ID (yytext, !pos, !pos));