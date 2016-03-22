%{

#include <string.h>

#include "struct.h"
#include "web.tab.h"


%}

%%

([[:alpha:]][[:alpha:][:digit:]'._]*)|(_[[:alpha:][:digit:]'._]+) {
 printf("[L] etiquette valide : %s\n",yytext);
 yylval.txt=strdup(yytext);
 return TAG;
 }
\[ {printf("ouverture crochet : %s\n",yytext);}
\] {printf("fermeture crochet : %s\n",yytext);}
\{ {printf("[L] ouverture accolade : %s\n",yytext);return OPEN_BRACKET;}
\} {printf("[L] fermeture accolade : %s\n",yytext);return CLOSE_BRACKET;}
\/ {printf("slash : %s\n",yytext);}
[:space:] {printf("espace : %s\n",yytext);}
[:alpha:]+ {printf("mot : %s\n",yytext);}
\" {printf("guillemet : %s\n",yytext);}
\= {printf("egal : %s\n",yytext);}

%%

