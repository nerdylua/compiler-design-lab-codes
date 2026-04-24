%{
#include "prog.tab.h"
%}

%%
"for"                   { return FOR; }
"++"|"--"               { return INCDEC; }
"=="|"!="|"<="|">="|"<"|">" { return RELOP; }
[a-zA-Z_][a-zA-Z0-9_]*  { return ID; }
[0-9]+                  { return NUM; }
[ \t\r\n]+              { /* skip whitespace */ }
.                       { return yytext[0]; }
%%

int yywrap(void)
{
    return 1;
}
