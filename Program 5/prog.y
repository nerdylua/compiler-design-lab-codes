%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s) { (void)s; }
%}

%union {
    char *str;
}

%token PRINTF RETURN ASSIGN PLUS MINUS MUL DIV SEMI LPAREN RPAREN COMMA
%token <str> ID NUM STR
%type <str> expr

%%

program
    :
    | program statement
    | program junk
    ;

statement
    : ID ASSIGN expr SEMI
      { printf("MOV %s,%s\n", $1, $3); }
    | ID ASSIGN ID PLUS ID SEMI
      { printf("MOV AX,%s\nADD AX,%s\nMOV %s,AX\n", $3, $5, $1); }
    | ID ASSIGN ID MINUS ID SEMI
      { printf("MOV AX,%s\nSUB AX,%s\nMOV %s,AX\n", $3, $5, $1); }
    | ID ASSIGN ID MUL ID SEMI
      { printf("MOV AX,%s\nMUL %s\nMOV %s,AX\n", $3, $5, $1); }
    | ID ASSIGN ID DIV ID SEMI
      { printf("MOV AX,%s\nDIV %s\nMOV %s,AX\n", $3, $5, $1); }
    | PRINTF LPAREN STR COMMA ID RPAREN SEMI
      { printf("CALL PRINT\n"); }
    | PRINTF LPAREN STR RPAREN SEMI
      { printf("CALL PRINT\n"); }
    | RETURN NUM SEMI
      { printf("RET\n"); }
    | RETURN SEMI
      { printf("RET\n"); }
    ;

expr
    : ID   { $$ = $1; }
    | NUM  { $$ = $1; }
    ;

junk
    : ID
    | NUM
    | STR
    | ASSIGN
    | PLUS
    | MINUS
    | MUL
    | DIV
    | LPAREN
    | RPAREN
    | COMMA
    | SEMI
    ;

%%

int main(int argc, char *argv[]) {
    if (argc == 2) {
        FILE *fp = fopen(argv[1], "r");
        if (fp == NULL) {
            printf("Cannot open file\n");
            return 1;
        }
        yyin = fp;
    }
    printf("Assembly code:\n");
    yyparse();
    return 0;
}
