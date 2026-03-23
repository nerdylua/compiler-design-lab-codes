%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUM
%left '+' '-'
%left '*' '/'
%right UMINUS

%%
S  : E               { printf("Result is %d\n", $1); }
   ;

E  : E '+' E         { $$ = $1 + $3; }
   | E '-' E         { $$ = $1 - $3; }
   | E '*' E         { $$ = $1 * $3; }
   | E '/' E         {
                        if ($3 == 0) {
                            yyerror("division by zero");
                        }
                        $$ = $1 / $3;
                     }
   | '(' E ')'       { $$ = $2; }
   | '-' E %prec UMINUS
                     { $$ = -$2; }
   | NUM             { $$ = $1; }
   ;
%%

int main(void)
{
    printf("Enter an expression\n");
    yyparse();
    printf("Valid\n");
    return 0;
}

void yyerror(const char *s)
{
    (void)s;
    printf("Invalid\n");
    exit(EXIT_FAILURE);
}
