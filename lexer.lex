datatype lexresult = LPAREN | RPAREN | COMMA | WILD | ID of string | EOF

val eof = fn () => EOF

%%

%structure Lex

alpha=[A-Za-z];
digit=[0-9];
ws=[\ \t];

%%

\n => (lex());
{ws}+ => (lex());
"(" => (LPAREN);
")" => (RPAREN);
"," => (COMMA);
"_" => (WILD);
{alpha}+ => (ID yytext);