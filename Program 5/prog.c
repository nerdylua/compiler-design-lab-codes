#include <ctype.h>
#include <stdio.h>
#include <string.h>

#define MAX_VARS 50

char vars[MAX_VARS][32];
int var_count = 0;

void trim(char *line)
{
    int start = 0;
    int end;
    int i;

    while (line[start] && isspace((unsigned char)line[start])) {
        start++;
    }

    end = (int)strlen(line) - 1;
    while (end >= start && isspace((unsigned char)line[end])) {
        line[end--] = '\0';
    }

    if (start > 0) {
        for (i = 0; line[start + i]; i++) {
            line[i] = line[start + i];
        }
        line[i] = '\0';
    }
}

void add_var(const char *name)
{
    int i;

    for (i = 0; i < var_count; i++) {
        if (strcmp(vars[i], name) == 0) {
            return;
        }
    }

    strcpy(vars[var_count++], name);
}

void handle_declaration(char *line)
{
    char *token;

    token = strtok(line + 3, ",;");
    while (token != NULL) {
        trim(token);
        if (*token != '\0') {
            add_var(token);
        }
        token = strtok(NULL, ",;");
    }
}

void print_variables(void)
{
    int i;

    printf("; Data Section\n");
    for (i = 0; i < var_count; i++) {
        printf("%s DW ?\n", vars[i]);
    }

    printf("\n; Code Section\n");
    printf("MAIN:\n");
}

void handle_assignment(const char *line)
{
    char lhs[32];
    char a1[32];
    char a2[32];
    char op;

    if (sscanf(line, "%31[^=]=%31[^+-*/;]%c%31[^;];", lhs, a1, &op, a2) == 4) {
        trim(lhs);
        trim(a1);
        trim(a2);
        printf("MOV AX, %s\n", a1);
        switch (op) {
        case '+':
            printf("ADD AX, %s\n", a2);
            break;
        case '-':
            printf("SUB AX, %s\n", a2);
            break;
        case '*':
            printf("MUL %s\n", a2);
            break;
        case '/':
            printf("DIV %s\n", a2);
            break;
        }
        printf("MOV %s, AX\n", lhs);
    } else if (sscanf(line, "%31[^=]=%31[^;];", lhs, a1) == 2) {
        trim(lhs);
        trim(a1);
        printf("MOV %s, %s\n", lhs, a1);
    }
}

void handle_printf(const char *line)
{
    char name[32];

    if (sscanf(line, "printf(\"%*[^\"]\",%31[^)]);", name) == 1) {
        trim(name);
        printf("PRINT %s\n", name);
    }
}

int main(int argc, char *argv[])
{
    FILE *fp;
    char line[256];

    if (argc < 2) {
        printf("Usage: prog5.exe input.c\n");
        return 1;
    }

    fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Cannot open input file\n");
        return 1;
    }

    while (fgets(line, sizeof(line), fp) != NULL) {
        trim(line);
        if (strncmp(line, "int ", 4) == 0 && strchr(line, '(') == NULL) {
            handle_declaration(line);
        }
    }

    rewind(fp);
    print_variables();

    while (fgets(line, sizeof(line), fp) != NULL) {
        trim(line);

        if (strchr(line, '=') != NULL && strncmp(line, "int ", 4) != 0) {
            handle_assignment(line);
        } else if (strncmp(line, "printf", 6) == 0) {
            handle_printf(line);
        } else if (strncmp(line, "return", 6) == 0) {
            printf("RET\n");
        }
    }

    fclose(fp);
    return 0;
}
