LEX = flex
LFLAGS =
YACC = yacc
YFLAGS = -yvd
CC = gcc
CFLAGS =

LFILE = update.l
YFILE = update.y

default: run

clean:
	rm -f lex.yy.c y.* a.out

lex.yy.c: $(LFILE)
	$(LEX) $(LFLAGS) $(LFILE)

y.tab.c: $(YFILE)
	$(YACC) $(YFLAGS) $(YFILE)

a.out: lex.yy.c y.tab.c y.tab.h
	$(CC) $(CFLAGS) lex.yy.c y.tab.c

build: clean a.out

run: a.out
	./a.out
