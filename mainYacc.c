#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "web.tab.h"
#include "import.h"
struct env* initial_env;
struct env* e;
extern int yydebug;
int main(int argc, char** argv)
{
    yydebug=0;
    e=initial_env;
    if(argc>=2)
    {
	int fd=open(argv[1],O_RDONLY);
	if(fd == -1)
	{
	    perror("open");
	    return EXIT_FAILURE;
	}
	dup2(fd,STDIN_FILENO);
	close(fd);
    }
    yyparse();
    /*struct ast * mot1 = mk_word("tamere ");
    struct ast * mot2 = mk_word("tamere2");
    struct ast * forest = mk_forest(true,mot1,mot2);
    struct ast * app = mk_app(mk_app(mk_binop(EMIT),mk_word("test.html")),forest);
    process_instruction(app,e);*/
    return 0;
}
