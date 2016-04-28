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

[xX][mM][lL][[:alpha:]]* {
 printf("world : %s\n",yytext);
 yylval.txt=strdup(yytext);
 return ALNUMSUITE;
 }
([[:alpha:]][[:alpha:][:digit:]'._]*)|(_[[:alpha:][:digit:]'._]+) {
 printf("[L] etiquette valide : %s\n",yytext);
 yylval.txt=strdup(yytext);
 return TAG;
 }
\[ {printf("ouverture crochet : %s\n",yytext);return OPEN_BRACKET;}
\] {printf("fermeture crochet : %s\n",yytext);return CLOSE_BRACKET;BEGIN INITIAL;}
\{ {printf("[L] ouverture accolade : %s\n",yytext);return OPEN_BRACES;}
\} {printf("[L] fermeture accolade : %s\n",yytext);return CLOSE_BRACES;}
\/ {printf("slash : %s\n",yytext);return SLASH;}
<TXT>[[:space:]]+ {return SPACES;}
[[:space:]]+ {}
[[:alpha:]]+ {printf("mot : %s\n",yytext);}
\= {printf("egal : %s\n",yytext);return EQUAL;}
\,  {printf("comma : %s\n",yytext);return COMMA;}
<INITIAL>\" {printf("guillemet : %s\n",yytext);BEGIN TXT;return DQUOTE;}

%%
