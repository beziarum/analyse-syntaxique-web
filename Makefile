LEX=flex
YACC=bison -d -v
CC=gcc

LDLIBS=-lfl -ly
CFLAGS=-std=c99 -Wall -Wpedantic

all: web

web:

autoLex: web.yy.c
	gcc $< -lfl -o $@

lex: web.yy.c

web.yy.c: web.l
	flex -o $@ $<

autoStruct: struct.h main.c tree.c attributes.c
	$(CC) $(CFLAGS) -o $@ $^

autoYacc: web.tab.c
	$(CC) $(CFLAGS) mainYacc.c tree.c web.yy.c web.tab.c $(LDLIBS) -o $@

web.tab.c: web.y
	$(YACC) $<
