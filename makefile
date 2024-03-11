all: sintax
# Compiladores
CPP=g++
FLEX=flex 
BISON=bison

sintax: lex.yy.c sintax.tab.c
	$(CPP) lex.yy.c sintax.tab.c -std=c++17 -o sintax

lex.yy.c: sintax.l
	$(FLEX) sintax.l

sintax.tab.c: sintax.y
	$(BISON) -d sintax.y

clean:
	rm sintax lex.yy.c sintax.tab.c sintax.tab.h
