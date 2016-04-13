%{
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "struct.h"    
int yylex(void);
void yyerror(char  *);
%}
%token			OPEN_BRACES  // {
%token			CLOSE_BRACES // }
%token			OPEN_BRACKET // [
%token			CLOSE_BRACKET// ]
%token			SLASH        // /
%token			COMMA        // ,
%token			DQUOTE       // "
%token			EQUAL        // =
%token			SPACES
%token			TAG
%token			ALNUMSUITE
%token			TXTWORD
%token			TXTEWORD
%union
{
    tree t;
    attributes a;
    char* txt;
}

%type	<txt>		TAG ALNUMSUITE TXTWORD
%type	<t>		node forest word lword string
%type	<a>		attribut lattributs flattributs
%%

web:		forest
		{
		    printf("--------------------------------\n");
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
		    display_tree($node);
		    printf("\n");
		}
	|	nforest forest {$$=$2;}
	|	forest nforest
	|	string
	|	OPEN_BRACES forest CLOSE_BRACES {$$=$2;}
	|	node
		{
		    display_tree($node);
		    printf("\n");
		    $$=$node;
		}
	;

nforest:	nforest nforest
	|	OPEN_BRACES CLOSE_BRACES
	;

flattributs:	OPEN_BRACKET lattributs CLOSE_BRACKET
		{
		  $$=$lattributs;
		}
	|	%empty {$$=NULL;}
	;

lattributs:	lattributs COMMA attribut
		{
		  ajouter_suivant($1,$3);
		}
	|	attribut
		  
	;

attribut:	TAG EQUAL string
		{
		  $$=attributes_create($TAG,$string);
		}
	;

string:		DQUOTE lword DQUOTE {$$=$lword;}
	;

lword:		lword[lw1] word
		{
		if($1==NULL)
		  $$=$2;
		else
		{
		    ajouter_frere($lw1,$word);
		}
		}
	|	%empty { $$=NULL;}
	;

word:		TXTWORD {printf("nesp\n");$$=tree_create($TXTWORD,true,false,WORD,NULL,NULL,NULL);}
	|	TXTWORD SPACES {printf("eps\n");$$=tree_create($TXTWORD,true,true,WORD,NULL,NULL,NULL);}
	;

node:		TAG flattributs OPEN_BRACES forest CLOSE_BRACES
		{
		    $$=tree_create($TAG,
				   false,
				   false,
				   TREE,
				   $flattributs,
				   $forest,
				   NULL);
		}
	|	TAG flattributs SLASH
		{
		    $$=tree_create($TAG,
				   true,
				   false,
				   TREE,
				   $flattributs,
				   NULL,
				   NULL);
		}
	;
