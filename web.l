%{
#define _XOPEN_SOURCE 700
#include <string.h>

#include "ast.h"
#include "web.tab.h"

int lastIsSpace=0;
%}

LEX_LABEL ([[:alpha:]][[:alpha:][:digit:]'._]*)|(_[[:alpha:][:digit:]'._]+)


%s TXT

%%


<TXT>\"                       {
                                 BEGIN INITIAL;
                                 lastIsSpace=0;
                                 return DQUOTE;
                              }

<TXT>[^[:space:]"]+           {  //"// juste pour la coloration syntaxique qui plante pas mal sinon
                                 lastIsSpace=0;
                                 yylval.txt=strdup(yytext);
                                 return TXTWORD;
                              }

<TXT>[[:space:]]+             {
                              	lastIsSpace = 1;
                              	return SPACES;
                              }


let                          {
                                 lastIsSpace=0;
                                 return LET;
                              }

where                         {
                              	lastIsSpace=0;
                              	return WHERE;
                              }

in                            {
                               lastIsSpace=0;
                               return IN;
                              }

emit                          {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(EMIT);
                                 return BINARYOP;
                              }

fun                           {
                                 lastIsSpace=0;
                                 return LFUN;
                              }

[+*]                          {
                                 lastIsSpace=0;
                                 yylval.ast=mk_word(strdup(yytext));
                                 return BINARYOP;
                              }

[xX][mM][lL]{LEX_LABEL}       {
                                 lastIsSpace=0;
                                 yylval.txt=strdup(yytext);
                                 return NAME;
                              }


{LEX_LABEL}                   {
                                 lastIsSpace=0;
                                 yylval.txt=strdup(yytext);
                                 return TAG;
                              }


[[:space:]]+                  {
                                 lastIsSpace=1;
                              }

<INITIAL>\"                   {
                                 lastIsSpace=0;
                                 BEGIN TXT;
                                 return DQUOTE;
                              }


\[                            {
                                 int tmp=lastIsSpace;
                                 lastIsSpace=0;
                                 if(tmp)
                                    return E_OPEN_BRACKET;
                                 else
                                    return OPEN_BRACKET;
                              }

\]                            {
                                 lastIsSpace=0;
                                 return CLOSE_BRACKET;
                              }

\{                            {
                                 int tmp=lastIsSpace;
                                 lastIsSpace=0;
                                 if(tmp)
                                    return E_OPEN_BRACES;
                                 else
                                    return OPEN_BRACES;
                              }

\}                            {
                                 lastIsSpace=0;
                                 return CLOSE_BRACES;
                              }

\/                            {
                                 int tmp=lastIsSpace;
                                 lastIsSpace=0;
                                 if(tmp)
                                    return E_SLASH;
                                 else
                                    return SLASH;
                              }

\=                            {
                                 lastIsSpace=0;
                                 return EQUAL;
                              }

\,                            {
                                 int tmp=lastIsSpace;
                                 lastIsSpace=0;
											if(tmp)
												return E_COMMA;
											else
                                 	return COMMA;
                              }

\;                            {
                                 lastIsSpace=0;
                                 return SEMICOLON;
                              }

->                            {
                                 lastIsSpace=0;
                                 return ARROW;
                              }

%%
