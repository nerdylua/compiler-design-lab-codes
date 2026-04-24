# Write a YACC program that identifies Function Definition of C language

## Files
`prog.l` - scanner for keywords, identifiers, numbers and operators

`prog.y` - parser to identify a simple C function definition

## Commands
`flex prog.l`

`bison -d prog.y`

`gcc lex.yy.c prog.tab.c -o prog3b.exe`

`prog3b.exe < input.txt`
