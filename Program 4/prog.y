%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

#define MAX_CODE 100

struct code_line {
    char op[8];
    char arg1[32];
    char arg2[32];
    char result[32];
} code[MAX_CODE];

struct temp_link {
    char name[32];
    int index;
} temp_map[MAX_CODE];

int code_count = 0;
int temp_count = 0;
int temp_link_count = 0;

char *copy_text(const char *text);
char *new_temp(void);
char *emit_binary(const char *op, const char *arg1, const char *arg2);
void emit_assign(const char *lhs, const char *rhs);
void print_output(void);
const char *triple_arg(const char *arg);
%}

%union {
    char *text;
}

%token <text> ID NUM
%type <text> expr term factor
%left '+' '-'
%left '*' '/'

%%
program         : stmt_list               { print_output(); }
                ;

stmt_list       : stmt_list stmt
                | stmt
                ;

stmt            : ID '=' expr ';'         { emit_assign($1, $3); }
                ;

expr            : expr '+' term           { $$ = emit_binary("+", $1, $3); }
                | expr '-' term           { $$ = emit_binary("-", $1, $3); }
                | term                    { $$ = $1; }
                ;

term            : term '*' factor         { $$ = emit_binary("*", $1, $3); }
                | term '/' factor         { $$ = emit_binary("/", $1, $3); }
                | factor                  { $$ = $1; }
                ;

factor          : '(' expr ')'            { $$ = $2; }
                | ID                      { $$ = $1; }
                | NUM                     { $$ = $1; }
                ;
%%

char *copy_text(const char *text)
{
    char *value = (char *)malloc(strlen(text) + 1);
    strcpy(value, text);
    return value;
}

char *new_temp(void)
{
    char name[32];
    sprintf(name, "t%d", ++temp_count);
    return copy_text(name);
}

char *emit_binary(const char *op, const char *arg1, const char *arg2)
{
    char *temp = new_temp();

    strcpy(code[code_count].op, op);
    strcpy(code[code_count].arg1, arg1);
    strcpy(code[code_count].arg2, arg2);
    strcpy(code[code_count].result, temp);

    strcpy(temp_map[temp_link_count].name, temp);
    temp_map[temp_link_count].index = code_count;

    code_count++;
    temp_link_count++;

    return temp;
}

void emit_assign(const char *lhs, const char *rhs)
{
    strcpy(code[code_count].op, "=");
    strcpy(code[code_count].arg1, rhs);
    strcpy(code[code_count].arg2, "-");
    strcpy(code[code_count].result, lhs);
    code_count++;
}

const char *triple_arg(const char *arg)
{
    static char buffer[32];
    int i;

    for (i = 0; i < temp_link_count; i++) {
        if (strcmp(temp_map[i].name, arg) == 0) {
            sprintf(buffer, "(%d)", temp_map[i].index);
            return buffer;
        }
    }

    return arg;
}

void print_output(void)
{
    int i;

    printf("Three Address Code:\n");
    for (i = 0; i < code_count; i++) {
        if (strcmp(code[i].op, "=") == 0) {
            printf("%s = %s\n", code[i].result, code[i].arg1);
        } else {
            printf("%s = %s %s %s\n", code[i].result, code[i].arg1, code[i].op, code[i].arg2);
        }
    }

    printf("\nQuadruples:\n");
    printf("Index\tOp\tArg1\tArg2\tResult\n");
    for (i = 0; i < code_count; i++) {
        printf("%d\t%s\t%s\t%s\t%s\n",
               i,
               code[i].op,
               code[i].arg1,
               code[i].arg2,
               code[i].result);
    }

    printf("\nTriples:\n");
    printf("Index\tRepresentation\n");
    for (i = 0; i < code_count; i++) {
        if (strcmp(code[i].op, "=") == 0) {
            printf("%d\t(=, %s, %s)\n", i, triple_arg(code[i].arg1), code[i].result);
        } else {
            printf("%d\t(%s, %s, %s)\n", i, code[i].op, triple_arg(code[i].arg1), triple_arg(code[i].arg2));
        }
    }
}

int main(void)
{
    printf("Enter assignment statements\n");
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    (void)s;
    printf("Invalid input\n");
    exit(EXIT_FAILURE);
}
