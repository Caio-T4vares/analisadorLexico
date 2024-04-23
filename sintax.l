%{
/* analisador léxico para o reconhecedor de frases */
#include <iostream>
#include <string>
using std::cout;
using std::string;

#include "sintax.tab.h"
%}

%option yylineno
%option noyywrap
delim	[ \t\n]
brancos {delim}+
letra	[A-Za-z]
minusculo [a-z]
cardinal [0-9]
inteiro {cardinal}+
pontoFlutuante ({inteiro}.{inteiro})
id [A-Z]{letra}*(_[A-Z]{letra}*)?
prop (has([A-Z]{letra}*)*)|([a-z]{letra}*)|(is([A-Z]{letra}*)+Of)
name [A-Z]{letra}*{inteiro}
relationalSymbol ">="|"<="|">"|"<"
typeInteger "xsd:integer"
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
Class: return Class;
EquivalentTo: return EquivalentTo;
Individuals: return Individuals;
SubClassOf: return SubClassOf;
DisjointClasses: return DisjointClasses;
"," return VIRGULA;
"(" return ABREPARENTESES;
")" return FECHAPARENTESES;
"{" return ABRECHAVE;
"}" return FECHACHAVE;
"[" return ABRECOLCHETE;
"]" return FECHACOLCHETE;
{prop} return PROP;
{typeInteger} return TYPEINTEGER;
{type} return TYPE;
{relationalSymbol} return RELATIONAL;
{name} return NAME;
{id}	return ID;  
{inteiro}	return INTEIRO;
{pontoFlutuante} return PONTOFLUTUANTE;
.           {
          std::string defaultMsg = "Não reconhecido";
          throw(defaultMsg); 
}

%%