%{
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ast.h"
#define YYDEBUG 1
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
%token			BINARYOP

%token			LET

%union
{
    struct tree * t;
    struct attributes * a;
    char* txt;
		struct ast * ast;
		struct attributes * attr;

}

%type	<txt>		TAG ALNUMSUITE TXTWORD NAME
%type <ast>  node forest word lword string name app BINARYOP tree
%type <attr> attribut lattributs flattributs
%debug

%%

web:		blet forest
		{
		    printf("--------------------------------\n");
		    //display_tree($2);
		    printf("\n");
		}
	;



forest:		forest[f1] tree[f2]
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
	|	nforest forest {$$=$2;}
	|	forest nforest
	|	tree

tree:		string
	|	OPEN_BRACES forest  CLOSE_BRACES {$$=$2;}
	|	app {$$=NULL;}
	|	node
		{
		    //display_tree($node);
		    printf("\n");
		    $$=$node;
		}
	;

nforest:	nforest nforest
	|	OPEN_BRACES   CLOSE_BRACES
	;

flattributs:	OPEN_BRACKET lattributs  CLOSE_BRACKET
		{
		  $$=$lattributs;
		}
	;

lattributs:	attribut  lattributs
		{

		$1->next = $2;
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
	|	space { $$=NULL;}
	;

word:
			TXTWORD SPACES {printf("eps\n");$$=mk_tree("",true,false,true,NULL,mk_word($1));}
		|	TXTWORD {printf("nesp\n");$$=mk_word($1);}
		;

node:		TAG flattributs OPEN_BRACES forest CLOSE_BRACES
		{
		    $$=mk_tree($TAG,
			       false,
			       false,
			       false,
			       $flattributs,
			       $forest);
		}
	|	TAG OPEN_BRACES forest  CLOSE_BRACES
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
name:		NAME {$$=mk_word($1);}
	|	TAG {$$=mk_word($1);}

let:		LET SPACES name space EQUAL space tree space SEMICOLON EOL
		{
		    //e=process_binding_instruction($name,$node,e);
		}
	;

blet:		let blet
		app space blet {process_instruction($app);}
	|	%empty
	;

app:		BINARYOP SPACES string[f1] SPACES tree[f2] { $$=mk_app(mk_app($BINARYOP,$f1),$f2);}
	;
space: 		SPACES
	|	%empty
		;
