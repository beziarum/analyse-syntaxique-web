LEX=flex
YACC=bison -d -v
CC=gcc

LDLIBS=-lfl
CFLAGS=-std=c99 -Wall -Wpedantic

all: web

web:

autoLex: web.yy.c
	gcc $< -lfl -o $@

lex: web.yy.c

web.yy.c: web.l
	flex -o $@ $<

autoStruct: struct.h main.c tree.c attributes.c
	$(CC) -o $@ @<
