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
%token 			LPLUS	      	 // +
%token 			LMINUS	       // -
%token 			LMULT 	       // *
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
%token			LEMIT
%token			POINT
%token			FLECHE
%token			DOLLAR
%union
{
    char* txt;
		struct ast * ast;
		struct attributes * attr;
		struct dir * dir;
		struct path * path;
}

%type	<txt>		TAG ALNUMSUITE TXTWORD NAME name
%type <ast>  node forest word lword string BINARYOP tree var lname emit LEMIT
%type <ast>	 cond expr
%type <attr> attribut lattributs flattributs
%type <dir> debpath
%type <path> path reference

%debug

%%


//-----------grammaire des forets, des arbres et des noeuds---------------

web:		blet forest
		{
		    printf("Grammaire acceptante\n");
		}
	|		blet
		{
		    printf("Grammaire acceptante\n");
		}
	;



forest:		forest[f1] forest[f2]
		{
		    if($f1==NULL)
			$$=$f2;
		    else
		    {
		       $$=mk_forest(false,$f1,$f2);
		    }
		}

	|		nforest forest {$$=$2;}
	|		forest nforest
	|		tree
	;

tree:		string
	|		open_braces forest  CLOSE_BRACES {$$=$2;}
	|		emit {$$=NULL; process_instruction($1,e);}
	|		node
			{
		    	$$=$node;
			}
	|		var
	|		cond
	|		expr
	|		reference {$$ = NULL;}
	;

nforest:	nforest nforest
	|	open_braces   CLOSE_BRACES
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
				       true,
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
		| LET name EQUAL tree[t1] IN node[n2]
			{
			    $$=mk_app(mk_fun($name,$n2),$t1);
			}
		| node[n2] WHERE name EQUAL tree[t1]
			{
			    $$=mk_app(mk_fun($name,$n2),$t1);
			}
		;

//-------------------grammaire des attribut.--------------------




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


//-----------------grammaire des string------------------------


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
			TXTWORD SPACES 	{$$=mk_tree("",true,true,true,NULL,mk_word($1));}
		|	TXTWORD 				{$$=mk_word($1);}
		;

//-----------------------------name------------------------------------


name:			NAME
		|		TAG
	;

lname:		lname[ln] name {$$=mk_forest(false,$ln,mk_word($name));}
	|			name {$$=mk_word($name);}
	;

//--------------Gestion des variables-----------------------------

let:			LET name EQUAL tree SEMICOLON
		{
		    e=process_binding_instruction($name,$tree,e);
		}
	;

blet:		blet let
	|		blet funct SEMICOLON
	|		blet emit SEMICOLON {process_instruction($2,e);}
	|		%empty
	;

var:		name COMMA {$$ = mk_var($name);}
	;


emit:		LEMIT string[f1] tree[f2] { $$=mk_app(mk_app($LEMIT,$2),$3);}
	;

//---------------------- Fonction---------------------------


funct:		LET name lname EQUAL tree
	|			LET name EQUAL LFUN lname ARROW tree
	|			LET name lname EQUAL LFUN lname ARROW tree
	|			expr
	;

//--------------------------Divers---------------------------------

open_braces:	OPEN_BRACES
	|				E_OPEN_BRACES
	;


slash:		SLASH
	|			E_SLASH
	;

space: 		SPACES
	|			%empty
	;

expr:		tree BINARYOP tree
	;

//------------------expression conditionnelle-------------------

cond: 	IF tree THEN tree ELSE tree
			{$$=mk_cond($2, $4, $6);}
	;



//--------------grammaire de la gestion des fichier multiple.------------



path:			SLASH name {$$=NULL;}
	|			path SLASH name {$$=NULL;}
	;

debpath: 	DOLLAR name path	{$$=NULL;}
	|			DOLLAR point name path {$$=NULL;}
	|			DOLLAR name {$$=NULL;}
	;

reference: 	debpath ARROW name {$$=NULL;}
	;

point:		 POINT
	|			point POINT
	;
