%{
#include <stdlib.h>
#include <string.h>
#include "prog.tab.h"

static char *dup_text(const char *s) {
    size_t n = strlen(s) + 1;
    char *p = (char *)malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}
%}

%%
printf                          { return PRINTF; }
return                          { return RETURN; }
\"[^\n"]*\"                     { yylval.str = dup_text(yytext); return STR; }
[a-zA-Z_][a-zA-Z0-9_]*          { yylval.str = dup_text(yytext); return ID; }
[0-9]+                          { yylval.str = dup_text(yytext); return NUM; }
"="                             { return ASSIGN; }
"+"                             { return PLUS; }
"-"                             { return MINUS; }
"*"                             { return MUL; }
"/"                             { return DIV; }
";"                             { return SEMI; }
"("                             { return LPAREN; }
")"                             { return RPAREN; }
","                             { return COMMA; }
[ \t\r\n]+                      { }
.                               { }
%%

int yywrap(void) { return 1; }
