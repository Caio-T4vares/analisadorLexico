%{
// Reconhecedor de uma linguagem simplificada
#include <iostream>
#include "tokens.h"
using std::cout;
%}

%option noyywrap
delim	[ \t\n]
brancos {delim}+
letra	[A-Za-z]
cardinal	[0-9]
id [A-Z]{letra}*(_[A-Z]{letra}*)?
prop ("has"([A-Z]{letra}*)*)|("is"([A-Z]{letra}*)*Of)|(^is[a-z]{letra}*)
name [A-Z]{letra}*{cardinal}+
symbol [\[\]\{\}\(\)><">=""<=",]
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
"Class": return Class;
"EquivalentTo": return EquivalentTo;
"Individuals": return Individuals;
"SubClassOf": return SubClassOf;
"DisjointClasses": return DisjointClasses;
{type} return TYPE;
{symbol} return SYMBOL;
{name} return NAME;
{id}		return ID;  
{prop} return PROP;
{cardinal}	    return CARDINAL; 
.           cout << YYText() << " é um token inválido!\n"; 
%%

// nenhuma função auxiliar é necessária
