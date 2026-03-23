%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%start S
%%
S: A B
 ;

A: 'a' A 'b'
 | /* empty */
 ;

B: 'b' B 'c'
 | /* empty */
 ;
%%

int main(void)
{
    printf("Enter words\n");
    yyparse();
    printf("true\n");
    return 0;
}

void yyerror(const char *s)
{
    (void)s;
    fprintf(stderr, "Invalid\n");
    exit(EXIT_FAILURE);
}