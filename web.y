%{
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "struct.h"    
int yylex(void);
void yyerror(char  *);


extern struct env* e;

%}
%token			OPEN_BRACES  // {
%token			CLOSE_BRACES // }
%token			OPEN_BRACKET // [
%token			CLOSE_BRACKET// ]
%token			SLASH        // /
%token			COMMA        // ,
%token			DQUOTE       // "
%token			EQUAL        // =
%token			SEMICOLON    // ;
%token			EOL          // \n
%token			SPACES
%token			NAME
%token			TAG
%token			ALNUMSUITE
%token			TXTWORD
%token			TXTEWORD

%token			LET

%union
{
    tree t;
    attributes a;
    char* txt;
}


%type	<txt>		TAG ALNUMSUITE TXTWORD NAME name
%type	<t>		node forest word lword string
%type	<a>		attribut lattributs flattributs
%%

web:		blet forest
		{
		    printf("--------------------------------\n");
		    display_tree($forest);
		    printf("\n");
		}
	;

forest:		forest[f1] node[f2]
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

name:		NAME
	|	TAG
	;
let:		LET SPACES name SPACES EQUAL node SEMICOLON
		{
		    e=process_binding_instruction($name,$node,e);
		}
	;

blet:		let EOL blet
	|	%empty
	;
