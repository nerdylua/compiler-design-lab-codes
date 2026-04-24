%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token FOR ID NUM RELOP INCDEC
%left '+' '-'
%left '*' '/'

%%
program         : level1                  { printf("Valid nested for loop\n"); }
                ;

level1          : FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' '{' level2 '}'
                ;

level2          : FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' '{' level3 '}'
                ;

level3          : FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' '{' stmt_list '}'
                ;

stmt_list       : stmt_list stmt
                | stmt
                ;

stmt            : ';'
                | simple_stmt ';'
                | FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' '{' stmt_list '}'
                ;

opt_expr        :
                | simple_stmt
                | condition
                ;

simple_stmt     : ID '=' expr
                | ID INCDEC
                | INCDEC ID
                ;

condition       : expr RELOP expr
                ;

expr            : expr '+' term
                | expr '-' term
                | term
                ;

term            : term '*' factor
                | term '/' factor
                | factor
                ;

factor          : '(' expr ')'
                | ID
                | NUM
                ;
%%

int main(void)
{
    printf("Enter a nested for loop\n");
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    (void)s;
    printf("Invalid nested for loop\n");
    exit(EXIT_FAILURE);
}
