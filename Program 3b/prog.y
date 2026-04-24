%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%union {
    char *text;
}

%token <text> ID NUM
%token INT FLOAT CHAR DOUBLE VOID RETURN
%left '+' '-'
%left '*' '/'

%%
program             : function_def            { printf("Valid function definition\n"); }
                    ;

function_def        : type ID '(' params ')' compound_stmt
                    ;

type                : INT
                    | FLOAT
                    | CHAR
                    | DOUBLE
                    | VOID
                    ;

params              :
                    | param_list
                    ;

param_list          : param
                    | param_list ',' param
                    ;

param               : type ID
                    | type
                    ;

compound_stmt       : '{' stmt_list_opt '}'
                    ;

stmt_list_opt       :
                    | stmt_list
                    ;

stmt_list           : stmt_list stmt
                    | stmt
                    ;

stmt                : declaration ';'
                    | assignment ';'
                    | RETURN expr_opt ';'
                    | compound_stmt
                    ;

declaration         : type declarator_list
                    ;

declarator_list     : declarator
                    | declarator_list ',' declarator
                    ;

declarator          : ID
                    | ID '=' expr
                    ;

assignment          : ID '=' expr
                    ;

expr_opt            :
                    | expr
                    ;

expr                : expr '+' term
                    | expr '-' term
                    | term
                    ;

term                : term '*' factor
                    | term '/' factor
                    | factor
                    ;

factor              : '(' expr ')'
                    | ID
                    | NUM
                    ;
%%

int main(void)
{
    printf("Enter a function definition\n");
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    (void)s;
    printf("Invalid function definition\n");
    exit(EXIT_FAILURE);
}
