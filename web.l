%{
#define _XOPEN_SOURCE 700
#include <string.h>

#include "ast.h"
#include "web.tab.h"


%}

LEX_LABEL ([[:alpha:]][[:alpha:][:digit:]'._]*)|(_[[:alpha:][:digit:]'._]+)


%s TXT

%%


<TXT>\"                       {
                                 BEGIN INITIAL;
                                 return DQUOTE;
                              }

<TXT>[^[:space:]"]+           {
                                 yylval.txt=strdup(yytext);
                                 return TXTWORD;
                              }


let                           {return LET;}

emit                          {
                                 yylval.ast=mk_binop(BINOP);
                                 return BINARYOP;
                              }

[+*]                          {
                                 yylval.ast=mk_word(strdup(yytext));
                                 return BINARYOP;
                              }

[xX][mM][lL]{LEX_LABEL}       {
                                 yylval.txt=strdup(yytext);
                                 return NAME;
                              }


{LEX_LABEL}                   {
                                 yylval.txt=strdup(yytext);
                                 return TAG;
                              }


[[:space:]]+                  {}
<INITIAL>\"                   {
                                 BEGIN TXT;
                                 return DQUOTE;
                              }


\[                            {return OPEN_BRACKET;}
\]                            {return CLOSE_BRACKET;}
\{                            {return OPEN_BRACES;}
\}                            {return CLOSE_BRACES;}
\/                            {return SLASH;}
\=                            {return EQUAL;}
\,                            {return COMMA;}
\;                            {return SEMICOLON;}

%%
