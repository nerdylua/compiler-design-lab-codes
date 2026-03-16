%{
#include<stdio.h>
int lines=1, spaces=0, words=0, characters=0;
%}
%%
[ ]             { spaces++; }
[\t]            { spaces = spaces + 3; }
[\n]            { lines++; }
[a-zA-Z]+       { words++; characters = characters + yyleng; }
#               { return 0; }
%%
int yywrap() {
    return 1;
}
int main() {
    printf("Enter a paragraph (press # to end input):\n");
    yylex();
    printf("\nResults:\n");
    printf("Lines = %d\n", lines);
    printf("Spaces = %d\n", spaces);
    printf("Words = %d\n", words);
    printf("Characters = %d\n", characters);
    return 0;
}