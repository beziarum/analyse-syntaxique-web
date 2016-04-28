%{
#define _XOPEN_SOURCE 700
#include <string.h>

#include "ast.h"
#include "web.tab.h"


%}

%s TXT
%%


<TXT>\" {printf("guillemet : %s\n",yytext);BEGIN INITIAL;return DQUOTE;}
<TXT>[^[:space:]"]+ {printf("mot : %s\n",yytext);yylval.txt=strdup(yytext);return TXTWORD;}//"


let {return LET;}
emit {yylval.txt=strdup(yytext); return BINARYOP;}
[+*/] {yylval.txt=strdup(yytext); return BINARYOP;}

[xX][mM][lL]([[:alpha:]][[:alpha:][:digit:]'._]*)|(_[[:alpha:][:digit:]'._]+) {
 printf("world : %s\n",yytext);
 yylval.txt=strdup(yytext);
 return NAME;
 }
([[:alpha:]][[:alpha:][:digit:]'._]*)|(_[[:alpha:][:digit:]'._]+) {
 printf("[L] etiquette valide : %s\n",yytext);
 yylval.txt=strdup(yytext);
 return TAG;
 }
\[ {printf("ouverture crochet : %s\n",yytext);return OPEN_BRACKET;}
\] {printf("fermeture crochet : %s\n",yytext);return CLOSE_BRACKET;}
\{ {printf("[L] ouverture accolade : %s\n",yytext);return OPEN_BRACES;}
\} {printf("[L] fermeture accolade : %s\n",yytext);return CLOSE_BRACES;}
\/ {printf("slash : %s\n",yytext);return SLASH;}
\n {return EOL;}
[[:space:]]+ {printf("espaces : %s\n",yytext); return SPACES;}
\= {printf("egal : %s\n",yytext);return EQUAL;}
\,  {printf("comma : %s\n",yytext);return COMMA;}
<INITIAL>\" {printf("guillemet : %s\n",yytext);BEGIN TXT;return DQUOTE;}
\; {printf("semicolon : %s\n",yytext);return SEMICOLON;}

%%
