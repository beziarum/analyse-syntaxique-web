

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
    /*struct ast * mot1 = mk_word("tamere ");
    struct ast * mot2 = mk_word("tamere2");
    struct ast * forest = mk_forest(true,mot1,mot2);
    struct ast * app = mk_app(mk_app(mk_binop(EMIT),mk_word("test.html")),forest);
    process_instruction(app,e);*/
    return 0;
}
