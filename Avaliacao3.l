%{
#include "avaliacao3.tab.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void printBorderedMessage(const char *message);
%}

%%

[0-9]+ { yylval.num = atoi(yytext); return NUM; }
[\n]   ; /* Ignorar nova linha */
.      { return yytext[0]; }

%%

int yywrap() {
    return 1;
}

void printBorderedMessage(const char *message) {
    int length = strlen(message);
    printf("+");
    for (int i = 0; i < length + 2; i++) printf("-");
    printf("+\n| %s |\n+", message);
    for (int i = 0; i < length + 2; i++) printf("-");
    printf("+\n");
}
