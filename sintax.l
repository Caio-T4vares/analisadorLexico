%{
/* analisador léxico para o reconhecedor de frases */
#include <iostream>
#include <string>
#include <unordered_map>
using std::cout;
using std::string;
using std::unordered_map;

#include "sintax.tab.h"
#define	CONSULTA 0   /* padrão - buscar em vez de definir */

/* tabela armazena a palavra e sua respectiva classificação */
unordered_map<string,int> tabela;
int estado;

/* funções de inserção e busca na tabela */
int inserir(int tipo, string palavra);
int buscar(string palavra);

%}

%option yylineno
%option noyywrap
delim	[ \t\n]
brancos {delim}+
letra	[A-Za-z]
cardinal [0-9]
numero {cardinal}+
id [A-Z]{letra}*(_[A-Z]{letra}*)?
prop (has([A-Z]{letra}*)*)|([a-z]{letra}*)|(is([A-Z]{letra}*)+Of)
name [A-Z]{letra}*{numero}
relationalSymbol ">="|"<="|">"|"<"
type [a-z]*:[a-z]*

%%
{brancos}	; // nenhuma ação e nenhum retorno
"some" return SOME;
"all" return ALL;
"value" return VALUE;
"min" return MIN;
"max" return MAX;
"exactly" return EXACTLY;
"that" return THAT;
"not" return NOT;
"and" return AND;
"or" return OR;
"only" return ONLY;
"Class:": return Class;
"EquivalentTo:": return EquivalentTo;
"Individuals:": return Individuals;
"SubClassOf:": return SubClassOf;
"DisjointClasses:": return DisjointClasses;
"," return VIRGULA;
"(" return ABREPARENTESES;
")" return FECHAPARENTESES;
"{" return ABRECHAVE;
"}" return FECHACHAVE;
"[" return ABRECOLCHETE;
"]" return FECHACOLCHETE;
{prop} return PROP;
{type} return TYPE;
{relationalSymbol} return RELATIONAL;
{name} return NAME;
{id}	return ID;  
{numero}	return NUMERO; 
.           {
          std::string defaultMsg = "Não reconhecido";
          throw(defaultMsg); 
}

%%

/* insere novos nomes na tabela */
int inserir(int tipo, string palavra)
{
	/* se palavra já está na tabela */
	if (buscar(palavra) != 0) {
		cout << "!!! atenção: " << palavra << " já definido\n";
		return 0;
	}
	
	/* palavra ainda não está na tabela, vamos inserir */
	tabela.insert({palavra, tipo});

	return 1;	/* tudo certo */
}

/* busca por um nome na tabela */
int buscar(string word)
{
	/* iterador aponta para o elemento ou tabela.end() */
	auto pos = tabela.find(word);

	/* se elemento não for encontrado */
	if (pos == tabela.end()) 
		return 0;

	/* elemento encontrado */
	return pos->second;
}