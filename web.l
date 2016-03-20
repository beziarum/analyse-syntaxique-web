%{



%}

%%

([[:alpha:]][[:alpha:][:digit:]'._]*)|(_?[[:alpha:][:digit:]'._]+) {printf("expression valide : %s",yytext);}

%%

