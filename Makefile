LEX=flex
YACC=bison -d -v -t --debug
CC=gcc

LDLIBS=-lfl -ly
CFLAGS=-std=c99 -Wall -Wpedantic -D_XOPEN_SOURCE=700

all: autoYacc

autoLex: web.yy.c
	gcc $< -lfl -o $@

lex: web.yy.c

web.yy.c: web.l web.tab.h
	flex -o $@ $<

autoStruct: struct.h main.c ast.c pattern.c chemin.c machine.c
	$(CC) $(CFLAGS) -o $@ $^

autoYacc: web.tab.c web.yy.c struct.h
	$(CC) $(CFLAGS) mainYacc.c import.c machine.c ast.c pattern_matching.c pattern.c web.yy.c web.tab.c $(LDLIBS) -o $@

web.tab.c web.tab.h: web.y
	$(YACC) $<

clean :
	rm autoYacc web.yy.c web.tab.h web.tab.c web.output *.o
