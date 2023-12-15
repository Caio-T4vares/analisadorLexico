
# Compiladores
CC=g++
LEX=flex++

# Dependências
all: analisadorLexico

analisadorLexico: analisadorLexico.o parser.o lex.yy.o
	$(CC) analisadorLexico.o parser.o lex.yy.o -o analisadorLexico

analisadorLexico.o: analisadorLexico.cpp parser.h
	$(CC) -c -std=c++17 analisadorLexico.cpp

parser.o: parser.cpp parser.h tokens.h
	$(CC) -c -std=c++17 parser.cpp

lex.yy.o: lex.yy.cc tokens.h
	$(CC) -c -std=c++17 lex.yy.cc

lex.yy.cc: lexer.l tokens.h
	$(LEX) lexer.l

clean:
	rm analisadorLexico lex.yy.cc lex.yy.o parser.o analisadorLexico.o
