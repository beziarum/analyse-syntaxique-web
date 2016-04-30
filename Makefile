LEX=flex
YACC=bison -d -v -t --debug
CC=gcc

LDLIBS=-lfl -ly
CFLAGS=-std=c99 -Wall -Wpedantic -D_XOPEN_SOURCE=700 -g

all: analyseur

analyseur: web.tab.c web.yy.c machine.c
	$(CC) $(CFLAGS) main.c import.c machine.c ast.c pattern_matching.c pattern.c web.yy.c web.tab.c $(LDLIBS) -o $@

autoLex: web.yy.c
		gcc $< -lfl -o $@

lex: web.yy.c

web.yy.c: web.l web.tab.h
	flex -o $@ $<

web.tab.c web.tab.h: web.y
	$(YACC) $<

ast.c: ast.h

import.c: import.h

machine.c pattern_matching.c: machine.h pattern_matching.h

pattern.c: pattern.h

clean :
	rm -f autoYacc web.yy.c web.tab.h web.tab.c web.output *.o
