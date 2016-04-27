%{
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ast.h"
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
    struct tree * t;
    struct attributes * a;
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

forest:		forest[f1] node[f2]
		{
		    if($f1==NULL)
			$$=$f2;
		    else
		    {
				mk_forest(false,$f1,$f2); a virer
			$$=$f1;
		    }
		    display_tree($f2);
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

lattributs:	attribut COMMA lattributs
		{
      $1->next = $3;
		}
	|	attribut

	;

attribut:	TAG EQUAL string
		{
		  $$=mk_attributes(mk_word($1),$string,NULL);
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
		  mk_forest(true,$lw1,$word);
		}
		}
	|	%empty { $$=NULL;}
	;

word:		TXTWORD {printf("nesp\n");$$=mk_word($1);}
		|	TXTWORD SPACES {printf("eps\n");$$=mk_tree("",true,false,true,NULL,mk_word($1));}
		;

node:		TAG flattributs OPEN_BRACES forest CLOSE_BRACES


		/*{ ancienne version avec tree.h

		    $$=mk_tree($TAG,
				   false,
				   false,
				   TREE,
				   $flattributs,
				   $forest,
				   NULL);
		}*/

    {
      $$ = mk_tree($TAG,      // erreur : mk_tree renvoie un ast
				   false,
				   false,
				   false,
				   $flattributs,
				   $forest);  // a changer (ast daughters)
    }

	|	TAG flattributs SLASH
		{
		    $$=mk_tree($TAG,
				   false,
				   true,
				   false,
				   $flattributs,
				   NULL);
		}
	;
