%{
#include <stdio.h>
#include "struct.h"    
int yylex(void);
void yyerror(char  *);
%}
%token			OPEN_BRACKET //{
%token			CLOSE_BRACKET//}
%token			TAG
%union
{
    tree t;
    char* txt;
}

%type	<txt>		TAG
%type	<t>		NODE FOREST
%%

FOREST:		NODE FOREST
		{
		    set_right($1,$2);
		    $$=$1;
		    display_tree($1,0,0);
		}
	|	NODE
	;

NODE:		TAG OPEN_BRACKET CLOSE_BRACKET
		{
		    $$=tree_create($1,
				   false,
				   false,
				   TREE,
				   NULL,
				   NULL,
				   NULL);
		    
		    
		}
	;

