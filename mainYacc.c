
extern int yydebug;
int main(void)
{
    yydebug=1;
    yyparse();
    return 0;
}
