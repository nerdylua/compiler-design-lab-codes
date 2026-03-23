%{
#include <stdio.h>

int positive_int = 0;
int negative_int = 0;
int positive_frac = 0;
int negative_frac = 0;
%}

DIGIT   [0-9]
INT     {DIGIT}+
DEC     ({DIGIT}+"."{DIGIT}+)|({DIGIT}*"."{DIGIT}+)|({DIGIT}+"."{DIGIT}*)
RAT     {INT}"/"{INT}

%%
"+"?{INT}        { positive_int++; }
"-"{INT}         { negative_int++; }

"+"?{DEC}        { positive_frac++; }
"-"{DEC}         { negative_frac++; }

"+"?{RAT}        { positive_frac++; }
"-"{RAT}         { negative_frac++; }

[ \t\r\n]+       ;
"#"              return 0;
.                ;
%%

int yywrap(void)
{
    return 1;
}

int main(void)
{
    printf("Enter numbers (use # to end):\n");
    yylex();
    printf("Number of positive integers = %d\n", positive_int);
    printf("Number of negative integers = %d\n", negative_int);
    printf("Number of positive fractions = %d\n", positive_frac);
    printf("Number of negative fractions = %d\n", negative_frac);
    return 0;
}
