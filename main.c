#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "web.tab.h"
#include "import.h"


extern struct env* initial_env;
struct env* e;
extern int yydebug;


int main(int argc, char** argv)
{
    yydebug=1;
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
    return 0;
}
