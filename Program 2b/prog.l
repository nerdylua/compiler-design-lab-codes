%{
#include <stdlib.h>
#include "prog.tab.h"
%}

%%
[0-9]+      { yylval = atoi(yytext); return NUM; }
[ \t\r]+    { /* skip whitespace */ }
\n          { return 0; }
[-+*/()]    { return yytext[0]; }
.           { return yytext[0]; }
%%

int yywrap(void)
{
    return 1;
}
