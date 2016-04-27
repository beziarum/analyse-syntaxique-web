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

web:		SPACES forest SPACES
		{
		    printf("--------------------------------\n");
		    display_tree($1);
		    printf("\n");
		}
	;

forest:		forest[f1] SPACES node[f2]
		{
		    if($f1==NULL)
			$$=$f2;
		    else
		    {
			ajouter_frere($f1,$f2);
			$$=$f1;
		    }
		    display_tree($f2);
		    printf("\n");
		}
	|	nforest SPACES forest {$$=$2;}
	|	forest SPACES  nforest
	|	string
	|	OPEN_BRACES SPACES forest SPACES  CLOSE_BRACES {$$=$2;}
	|	node
		{
		    display_tree($node);
		    printf("\n");
		    $$=$node;
		}
	;

nforest:	nforest SPACES  nforest
	|	OPEN_BRACES SPACES  CLOSE_BRACES
	;

flattributs:	OPEN_BRACKET SPACES  lattributs SPACES  CLOSE_BRACKET
		{
		  $$=$lattributs;
		}
	;

lattributs:	lattributs SPACES  COMMA SPACES  attribut
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

node:		TAG flattributs SPACES  OPEN_BRACES SPACES  forest SPACES  CLOSE_BRACES
		{
		    $$=tree_create($TAG,
				   false,
				   false,
				   TREE,
				   $flattributs,
				   $forest,
				   NULL);
		}
        |	TAG   OPEN_BRACES SPACES forest SPACES  CLOSE_BRACES
		{
		    $$=tree_create($TAG,
				   false,
				   false,
				   TREE,
				   NULL,
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

	|	TAG   SLASH
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
