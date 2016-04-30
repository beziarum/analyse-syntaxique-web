%{
#define _XOPEN_SOURCE 700
#include <string.h>

#include "ast.h"
#include "web.tab.h"

int lastIsSpace=0;
%}

LEX_LABEL [[:alpha:][:digit:]'._] //'

%s TXT
%x IMPORT

%%

<TXT>\"                       {
                                 BEGIN INITIAL;
                                 lastIsSpace=0;
                                 return DQUOTE;
                              }

<TXT>[^[:space:]"]+           {//"// pour la coloration
                                 lastIsSpace=0;
                                 yylval.txt=strdup(yytext);
                                 return TXTWORD;
                              }

<TXT>[[:space:]]+             {
                                 lastIsSpace = 1;
                                 return SPACES;
                              }


let                           {
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
                                 return LEMIT;
                              }

fun                           {
                                 lastIsSpace=0;
                                 return LFUN;
                              }

if                            {
                                 lastIsSpace=0;
                                 return IF;
                              }

then                          {
                                 lastIsSpace=0;
                                 return THEN;
                              }

else                          {
                                 lastIsSpace=0;
                                 return ELSE;
                              }

(_|([xX][mM][lL]){LEX_LABEL}+ {
                                 lastIsSpace=0;
                                 yylval.txt=strdup(yytext);
                                 return NAME;
                              }

(_|[[:alpha:]]){LEX_LABEL}+   {
                                 lastisspace=0;
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

"->"                            {
                                 lastIsSpace=0;
                                 return ARROW;
                              }

\+                            {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(PLUS);
                                 return BINARYOP;
                              }

\-                            {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(MINUS);
                                 return BINARYOP;
                              }

\*                            {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(MULT);
                                 return MULT;
                              }

"<="                          {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(LEQ);
                                 return LEQ;
                              }

\<                            {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(LE);
                                 return LE;
                              }

">="                          {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(GEQ);
                                 return GEQ;
                              }

\>                            {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(GE);
                                 return GE;
                              }

"!\="                         {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(NEQ);
                                 return NEQ;
                              }

"||"                          {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(OR);
                                 return OR;
                              }

"&&"                          {
                                 lastIsSpace=0;
                                 yylval.ast=mk_binop(AND);
                                 return AND;
                              }

\$                            {
                              	lastIsSpace=0;
                              	return DOLLAR;
                              }

\.										{
											lastIsSpace=0;
											return POINT;
										}


%%
