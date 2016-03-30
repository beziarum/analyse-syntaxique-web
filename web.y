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
%token			TAG
%token			ALNUMSUITE
%union
{
    tree t;
    attributes a;
    char* txt;
}

%type	<txt>		TAG word lword string ALNUMSUITE
%type	<t>		node forest
%type	<a>		attribut lattributs flattributs
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
	|	OPEN_BRACES forest CLOSE_BRACES {$$=$2;}
	|	node
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

lword:		lword word
		{
		if($1==NULL)
		  $$=$2;
		else
		{
		  int size1=strlen($1);
		  int size2=strlen($2);
		  $1=realloc($1,size1+size2+1);
		  strcpy($1+size2,$2);
		  free($word);
		  $$=$1;
		}
		}
	|	%empty {
		char* c=malloc(sizeof(*c));
		*c='\n';
		$$=c ;
		}
	;

word:		TAG
	|	ALNUMSUITE
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
