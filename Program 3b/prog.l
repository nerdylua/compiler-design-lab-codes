%{
#include "prog.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"int"                   { return INT; }
"float"                 { return FLOAT; }
"char"                  { return CHAR; }
"double"                { return DOUBLE; }
"void"                  { return VOID; }
"return"                { return RETURN; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.text = strdup(yytext); return ID; }
[0-9]+                  { yylval.text = strdup(yytext); return NUM; }
[ \t\r\n]+              { /* skip whitespace */ }
.                       { return yytext[0]; }
%%

int yywrap(void)
{
    return 1;
}
