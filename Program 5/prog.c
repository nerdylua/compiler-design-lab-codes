#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{

    FILE *fp = stdin;
    char line[100], lhs[20], op1[20], op2[20], op;

    if (argc > 2) {
        printf("Usage: prog5.exe [input_file]\n");
        return 1;
    }

    if (argc == 2) {
        fp = fopen(argv[1], "r");
        if (fp == NULL) {
            printf("Cannot open file\n");
            return 1;
        }
    } else {
        printf("Enter source statements (Ctrl+Z + Enter to finish):\n");
    }

    printf("Assembly code:\n");


    FILE *fp;
    char line[100], lhs[20], op1[20], op2[20], op;

    if (argc != 2) {
        printf("Usage: prog5.exe input.c\n");
        return 1;
    }

    fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Cannot open file\n");
        return 1;
    }

    printf("Assembly code:\n");

    while (fgets(line, sizeof(line), fp)) {
        if (strstr(line, "printf")) {
            printf("CALL PRINT\n");
        } else if (strstr(line, "return")) {
            printf("RET\n");
        } else if (sscanf(line, " %[^=]=%[^+-*/;]%c%[^;];", lhs, op1, &op, op2) == 4) {
            printf("MOV AX,%s\n", op1);

            if (op == '+')
                printf("ADD AX,%s\n", op2);
            else if (op == '-')
                printf("SUB AX,%s\n", op2);
            else if (op == '*')
                printf("MUL %s\n", op2);
            else if (op == '/')
                printf("DIV %s\n", op2);

            printf("MOV %s,AX\n", lhs);
        } else if (sscanf(line, " %[^=]=%[^;];", lhs, op1) == 2) {
            printf("MOV %s,%s\n", lhs, op1);
        }
    }

    if (fp != stdin) {
        fclose(fp);
    }
    return 0;
}