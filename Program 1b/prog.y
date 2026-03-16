%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void yyerror(char const*s);
%}
%start S
%%S: A B ;
A: 'a'A'b' | ;
B: 'b'B'c' | ;
%%
int yylex(){
	int c = getchar();
	if(c == EOF) return 0;
	if(c == 'a') return 'a';
	if(c == 'b') return 'b';
	if(c == 'c') return 'c';
	if(c == '\n') return 0;
	return c;
}
int main(){
printf("Enter words\n");
yyparse();
printf("true\n");
return 0;
}
void yyerror(char const *s){
	fprintf(stderr,"Invalid\n");
	exit(1);
}