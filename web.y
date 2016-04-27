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
		struct ast * ast;
		struct attributes * attr;

}

%type	<txt>		TAG ALNUMSUITE TXTWORD
%type <ast>  node forest word lword string
%type <attr> attribut lattributs flattributs
%%

web:		SPACES forest SPACES
		{
		    printf("--------------------------------\n");
		    //display_tree($2);
		    printf("\n");
		}
	;

forest:		forest[f1] SPACES node[f2]
		{
		    if($f1==NULL)
			$$=$f2;
		    else
		    {
				mk_forest(false,$f1,$f2);
			$$=$f1;
		    }
		    //display_tree($f2);
		    printf("\n");
		}
	|	nforest SPACES forest {$$=$3;}
	|	forest SPACES  nforest
	|	string
	|	OPEN_BRACES SPACES forest SPACES  CLOSE_BRACES {$$=$3;}
	|	node
		{
		    //display_tree($node);
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

lattributs:	attribut SPACES  COMMA SPACES  lattributs
		{

		$1->next = $5;
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

node:		TAG flattributs SPACES  OPEN_BRACES SPACES  forest SPACES  CLOSE_BRACES
		{
		    $$=mk_tree($TAG,
			       false,
			       false,
			       false,
			       $flattributs,
			       $forest);
		}
	|	TAG OPEN_BRACES SPACES  forest SPACES  CLOSE_BRACES
		{
		    $$=mk_tree($TAG,
			       false,
			       false,
			       false,
			       NULL,
			       $forest);
		}
	|	TAG SLASH
	        {
		    $$=mk_tree($TAG,
			       false,
			       true,
			       false,
			       NULL,
			       NULL);
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
