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

compile: lex.yy.c y.tab.c
	$(CC) $(CFLAGS) lex.yy.c y.tab.c

run: compile
	./a.out
