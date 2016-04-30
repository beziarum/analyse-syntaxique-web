%{
#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ast.h"
#include "import.h"
#define YYDEBUG 1
int yylex(void);
void yyerror(char  *);
extern struct env* e;
%}
%token			OPEN_BRACES    // {
%token			E_OPEN_BRACES  // { + espace avant
%token			CLOSE_BRACES   // }
%token			OPEN_BRACKET   // [
%token			E_OPEN_BRACKET // [ + espace avant
%token			CLOSE_BRACKET  // ]
%token			SLASH          // /
%token			E_SLASH        // / + espace avant
%token			COMMA          // ,
%token			E_COMMA			// , + espace devant
%token			DQUOTE         // "
%token			EQUAL          // =
%token			SEMICOLON      // ;
%token			EOL            // \n
%token			ARROW
%token			SPACES
%token			NAME
%token			TAG
%token			ALNUMSUITE
%token			TXTWORD
%token			TXTEWORD
%token			BINARYOP
%token			IN
%token			WHERE
%token			LFUN
%token			LET
%token 			IF
%token 			ELSE
%token 			THEN

%union
{
    struct tree * t;
    struct attributes * a;
    char* txt;
		struct ast * ast;
		struct attributes * attr;

}

%type	<txt>		TAG ALNUMSUITE TXTWORD NAME name
%type <ast>  node forest word lword string app BINARYOP tree var lname
%type <ast>	 expression expression-cond
%type <attr> attribut lattributs flattributs
%debug

%%

web:		blet forest
		{
		    printf("--------------------------------\n");
		    //display_tree($2);
		    printf("\n");
		}
		| expression-cond blet forest
	;



forest:		forest[f1] forest[f2]
		{
		    if($f1==NULL)
			$$=$f2;
		    else
		    {
		       $$=mk_forest(false,$f1,$f2);
		    }
		    //display_tree($f2);
		    printf("\n");
		}
	|	nforest forest {$$=$2;}
	|	forest nforest
	|	tree
		;
tree:		string
	|	open_braces forest  CLOSE_BRACES {$$=$2;}
	|	app {$$=NULL;}
	|	node
		{
		    $$=$node;
		}
	|	var

	;

nforest:	nforest nforest
	|	open_braces   CLOSE_BRACES
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
		 $$= mk_forest(false,$lw1,$word);
		}
		}
	|	space { $$=NULL;}
	;

word:
			TXTWORD SPACES 	{$$=mk_tree("",true,false,true,NULL,mk_word($1));}
		|	TXTWORD 				{$$=mk_word($1);}
		;

node:		TAG flattributs open_braces forest CLOSE_BRACES
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
	|	TAG flattributs slash
		{
		    $$=mk_tree($TAG,
			       false,
			       true,
			       false,
			       $flattributs,
			       NULL);
		}
	| LET name EQUAL tree IN node[n2]
		{
		    struct ast* fun=mk_fun($name,($tree));
		    $$=mk_app(fun,$n2);
		}
	| node WHERE name EQUAL tree
	;
name:		NAME
	|	TAG

let:		LET name EQUAL tree SEMICOLON
		{
		    e=process_binding_instruction($name,$tree,e);
		    fprintf(stderr,"proc %s\n",$name);
		}
	;

blet:		let blet
	|	app blet {process_instruction($1,e);}
        //		{process_instruction(mk_app(mk_app(mk_binop(EMIT),mk_word("test")),mk_tree("prout",true,true,false,NULL,NULL)));}
	|	%empty
	;

app:		BINARYOP string[f1] tree[f2] { $$=mk_app(mk_app($BINARYOP,$2),$3);}
	;


var:		name COMMA {$$ = mk_var($name);}
	;

funct:		LET name lname EQUAL tree
	|	LET name EQUAL LFUN lname ARROW tree
	|	LET name lname EQUAL LFUN lname ARROW tree
	;

lname:		lname[ln] name {$$=mk_forest(false,$ln,mk_word($name));}
	|	name {$$=mk_word($name);}
	;

open_braces:	OPEN_BRACES
	|	E_OPEN_BRACES
	;

open_bracket:	OPEN_BRACKET
	|	E_OPEN_BRACKET
	;

slash:		SLASH
	|	E_SLASH
	;

space: 		SPACES
	|	%empty
		;

expression-cond : IF expression THEN expression ELSE expression
		{$$=mk_cond($2, $4, $6);}
  | IF expression THEN expression  {$$=mk_cond($2, $4, NULL);}

expression : funct
	| let
	| TAG
	| expression-cond
