

#include "web.tab.h"
#include "import.h"
struct env* initial_env;
struct env* e;
int main(void)
{
    e=initial_env;
    yyparse();
    return 0;
}
