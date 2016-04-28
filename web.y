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
%type <ast>  node forest word lword string name
%type <attr> attribut lattributs flattributs
%debug

%%

<<<<<<< HEAD
web:		blet space forest space
=======
web:		 forest
>>>>>>> dev
		{
		    printf("--------------------------------\n");
		    //display_tree($2);
		    printf("\n");
		}
	;



forest:		forest[f1] forest[f2]
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
<<<<<<< HEAD
	|	nforest space forest {$$=$3;}
	|	forest nforest
=======
	|	nforest forest {$$=$2;}
	|	forest  nforest
>>>>>>> dev
	|	string
	|	OPEN_BRACES forest  CLOSE_BRACES {$$=$2;}
	|	node
		{
		    //display_tree($node);
		    printf("\n");
		    $$=$node;
		}
	;

<<<<<<< HEAD
nforest:	nforest space  nforest
	|	OPEN_BRACES space  CLOSE_BRACES
	|	space
=======
nforest:	nforest  nforest
	|	OPEN_BRACES CLOSE_BRACES
>>>>>>> dev
	;

flattributs:	OPEN_BRACKET  lattributs  CLOSE_BRACKET
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
	|space	 { $$=NULL;}
	;

word:
			TXTWORD SPACES {printf("eps\n");$$=mk_tree("",true,false,true,NULL,mk_word($1));}
		|	TXTWORD {printf("nesp\n");$$=mk_word($1);}
		;

<<<<<<< HEAD
node:		TAG flattributs space  OPEN_BRACES forest  CLOSE_BRACES
=======
node:		TAG flattributs  OPEN_BRACES  forest  CLOSE_BRACES
>>>>>>> dev
		{
		    $$=mk_tree($TAG,
			       false,
			       false,
			       false,
			       $flattributs,
			       $forest);
		}
	|	TAG OPEN_BRACES  forest  CLOSE_BRACES
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

<<<<<<< HEAD
name:		NAME {$$=mk_word($1);}
	|	TAG {$$=mk_word($1);}
	;
let:		LET SPACES name space EQUAL space node space SEMICOLON
		{
		    //e=process_binding_instruction($name,$node,e);
		}
	;

blet:		let space blet
	|	%empty
	;

space: 		SPACES
	|	%empty
	|	EOL
			;

=======
space: SPACES
		|%empty
		;
>>>>>>> dev
