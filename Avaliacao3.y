%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Prototipação
void printMenu();
void clearScreen(); // Adicionado aqui
void convertCmToInchOption();
void convertInchToCmOption();
void romanConverterOption();
void calculatorOption();
void printBorderedMessage(const char *message);
void intToRoman(int num, char *result);

int yylex();
void yyerror(const char *s);
%}

%union {
    int num;
}

%token <num> NUM

%start menu

%%

menu:
    | menu option
    ;

option:
    NUM {
        switch ($1) {
            case 1:
                convertCmToInchOption();
                break;
            case 2:
                convertInchToCmOption();
                break;
            case 3:
                romanConverterOption();
                break;
            case 4:
                calculatorOption();
                break;
            case 5:
                printBorderedMessage("Saindo do programa. Até logo!");
                exit(0);
            default:
                printBorderedMessage("Opção inválida. Tente novamente.");
        }
        clearScreen(); // Limpar a tela antes de exibir o menu novamente
        printMenu();
    }
    ;

%%

void printMenu() {
    printBorderedMessage("Menu de Opções");
    printf("1. Converter cm para polegadas\n");
    printf("2. Converter polegadas para cm\n");
    printf("3. Conversor de números romanos\n");
    printf("4. Calculadora básica\n");
    printf("5. Sair\n");
    printf("Escolha uma opção e pressione Enter: ");
}

void clearScreen() {
    #ifdef _WIN32
    system("cls");
    #else
    system("clear");
    #endif
}

void convertCmToInchOption() {
    double cm;
    while (1) {
        printf("Digite o valor em cm (ou 'exit' para voltar): ");
        char input[100];
        scanf("%s", input);
        if (strcmp(input, "exit") == 0) break;
        if (sscanf(input, "%lf", &cm) != 1) {
            printBorderedMessage("Entrada inválida.");
            continue;
        }
        printf("%.2f cm = %.2f polegadas\n", cm, cm * 0.393701);
    }
}

void convertInchToCmOption() {
    double inch;
    while (1) {
        printf("Digite o valor em polegadas (ou 'exit' para voltar): ");
        char input[100];
        scanf("%s", input);
        if (strcmp(input, "exit") == 0) break;
        if (sscanf(input, "%lf", &inch) != 1) {
            printBorderedMessage("Entrada inválida.");
            continue;
        }
        printf("%.2f polegadas = %.2f cm\n", inch, inch * 2.54);
    }
}

void romanConverterOption() {
    while (1) {
        printf("Digite um número inteiro entre 1 e 3999 (ou 'exit' para voltar): ");
        char input[100];
        scanf("%s", input);
        if (strcmp(input, "exit") == 0) break;
        int num;
        if (sscanf(input, "%d", &num) != 1 || num < 1 || num > 3999) {
            printBorderedMessage("Número inválido. Deve estar entre 1 e 3999.");
            continue;
        }
        char roman[100];
        intToRoman(num, roman);
        printf("%d em números romanos é: %s\n", num, roman);
    }
}

void calculatorOption() {
    while (1) {
        printf("Digite a operação no formato (número operador número) ou 'exit' para voltar: ");
        char input[100];
        scanf(" %[^\n]", input); // Lê a linha inteira
        if (strcmp(input, "exit") == 0) break;

        double a, b;
        char op;
        if (sscanf(input, "%lf %c %lf", &a, &op, &b) != 3) {
            printBorderedMessage("Entrada inválida.");
            continue;
        }

        switch (op) {
            case '+':
                printf("%.2f + %.2f = %.2f\n", a, b, a + b);
                break;
            case '-':
                printf("%.2f - %.2f = %.2f\n", a, b, a - b);
                break;
            case '*':
                printf("%.2f * %.2f = %.2f\n", a, b, a * b);
                break;
            case '/':
                if (b == 0) {
                    printBorderedMessage("Erro: divisão por zero.");
                } else {
                    printf("%.2f / %.2f = %.2f\n", a, b, a / b);
                }
                break;
            default:
                printBorderedMessage("Operador inválido.");
        }
    }
}

void intToRoman(int num, char *result) {
    struct roman {
        int value;
        const char *symbol;
    };
    struct roman roman_numerals[] = {
        {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"},
        {100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"},
        {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}
    };
    int i = 0;
    result[0] = '\0';
    while (num > 0) {
        while (num >= roman_numerals[i].value) {
            strcat(result, roman_numerals[i].symbol);
            num -= roman_numerals[i].value;
        }
        i++;
    }
}

void yyerror(const char *s) {
    printBorderedMessage("Erro de análise! Verifique sua entrada.");
}

int main() {
    #ifdef _WIN32
    system("chcp 65001 > nul");
    #endif

    printMenu();
    return yyparse();
}
