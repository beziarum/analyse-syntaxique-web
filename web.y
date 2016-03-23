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
%type	<t>		NODE FOREST
%%

WEB:		FOREST
		{
		    display_tree($1);
		    printf("\n");
		}
	;

FOREST:		FOREST NODE
		{
		    if($1==NULL)
			$$=$2;
		    else
		    {
			set_right($1,$2);
			$$=$1;
		    }
		}
	|	NFOREST FOREST {$$=$2;}
	|	FOREST NFOREST
	|	OPEN_BRACKET FOREST CLOSE_BRACKET {$$=$2;}
	|	NODE
	;

NFOREST:	NFOREST NFOREST
	|	OPEN_BRACKET CLOSE_BRACKET
	;

NODE:		TAG OPEN_BRACKET FOREST CLOSE_BRACKET
		{
		    $$=tree_create($TAG,
				   false,
				   false,
				   TREE,
				   NULL,
				   $FOREST,
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
