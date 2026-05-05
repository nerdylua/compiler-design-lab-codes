# Generate target code in assembly language for simple source statements

## Method 1: Simple C Program

### Files
- `prog.c` - simple target code generator

### Compile
```bash
gcc prog.c -o prog5.exe
```

### Run
```bash
.\prog5.exe input.c
```

---

## Method 2: Lex/Flex + Bison

### Files
- `prog.l` - lexer
- `prog.y` - parser and code generation
- `input.c` - sample input file

### Compile
```bash
flex prog.l
bison -d prog.y
gcc lex.yy.c prog.tab.c -o prog5.exe
```

### Run
```bash
.\prog5.exe input.c
```

### Expected output for `input.c`
```text
Assembly code:
MOV a,45
MOV b,25
MOV AX,a
ADD AX,b
MOV c,AX
CALL PRINT
RET
```
