# Write a YACC program to convert C statements into intermediate code

## Files
`prog.l` - scanner for identifiers, numbers and operators

`prog.y` - parser that prints three address code, quadruples and triples

## Commands
`flex prog.l`

`bison -d prog.y`

`gcc lex.yy.c prog.tab.c -o prog4.exe`

`prog4.exe < input.txt`
