# Write a parser program to recognize a nested FOR loop statement for C language

## Files
`prog.l` - scanner for `for`, identifiers, numbers, operators and punctuation

`prog.y` - parser for a `for` loop nested at least 3 levels

## Commands
`flex prog.l`

`bison -d prog.y`

`gcc lex.yy.c prog.tab.c -o prog3a.exe`

`prog3a.exe < input.txt`
