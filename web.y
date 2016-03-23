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


FOREST:		FOREST NODE
		{
		    if($1==NULL)
			$$=$2;
		    else
		    {
			set_right($1,$2);
			$$=$1;
		    }
		    display_tree($$);
		printf("\n");
		}
	|	%empty
		{
		    $$=NULL;
		}
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
	|	OPEN_BRACKET CLOSE_BRACKET { $$=NULL;}
	;
