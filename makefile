LEX = flex
LFLAGS =
YACC = yacc
YFLAGS = -yvd
CC = gcc
CFLAGS = -O2

LFILE = update.l
YFILE = update.y

OUTBIN = a.out
ifeq ($(OS),Windows_NT)
	OUTBIN = a.exe
endif

default: run

clean:
	rm -f lex.yy.c y.* $(OUTBIN) query.txt

lex.yy.c: $(LFILE)
	$(LEX) $(LFLAGS) $(LFILE)

y.tab.c: $(YFILE)
	$(YACC) $(YFLAGS) $(YFILE)

createbin: lex.yy.c y.tab.c y.tab.h
	$(CC) $(CFLAGS) lex.yy.c y.tab.c

build: clean createbin

test: createbin
	./$(OUTBIN) TEST

run: createbin
	./$(OUTBIN)
