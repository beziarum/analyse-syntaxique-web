%{



%}

%%

([[:alpha:]][[:alpha:][:digit:]'._]*)|(_[[:alpha:][:digit:]'._]+) {printf("etiquette valide : %s\n",yytext);}
\[ {printf("ouverture crochet : %s\n",yytext);}
\] {printf("fermeture crochet : %s\n",yytext);}
\{ {printf("ouverture accolade : %s\n",yytext);}
\} {printf("fermeture accolade : %s\n",yytext);}
\/ {printf("slash : %s\n",yytext);}
[:space:] {printf("espace : %s\n",yytext);}
[:alpha:]+ {printf("mot : %s\n",yytext);}
" {printf("guillemet : %s\n",yytext);}
= {printf("egal : %s\n",yytext);}

%%

