

#include "web.tab.h"
#include "import.h"
struct env* initial_env;
struct env* e;
extern int yydebug;
int main(void)
{
    yydebug=1;
    e=initial_env;
    yyparse();
    return 0;
}
