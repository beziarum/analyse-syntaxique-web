%{
#include <stdio.h>
#include "struct.h"    
int yylex(void);
void yyerror(char  *);
%}
%token			OPEN_BRACKET // {
%token			CLOSE_BRACKET// }
%token			SLASH// /
%token			TAG
%union
{
    tree t;
    char* txt;
}

%type	<txt>		TAG
%type	<t>		node forest
%%

web:		forest
		{
		    display_tree($1);
		    printf("\n");
		}
	;

forest:		forest node
		{
		    if($1==NULL)
			$$=$2;
		    else
		    {
			ajouter_frere($1,$2);
			$$=$1;
		    }
		}
	|	nforest forest {$$=$2;}
	|	forest nforest
	|	OPEN_BRACKET forest CLOSE_BRACKET {$$=$2;}
	|	node
	;

nforest:	nforest nforest
	|	OPEN_BRACKET CLOSE_BRACKET
	;

node:		TAG OPEN_BRACKET forest CLOSE_BRACKET
		{
		    $$=tree_create($TAG,
				   false,
				   false,
				   TREE,
				   NULL,
				   $forest,
				   NULL);
		}
	|	TAG SLASH
		{
		    $$=tree_create($TAG,
				   true,
				   false,
				   TREE,
				   NULL,
				   NULL,
				   NULL);
		}
	;
