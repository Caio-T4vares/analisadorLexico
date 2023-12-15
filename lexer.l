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
prop ("has"[A-Z]{letra}*)|("is"[A-Z]{letra}*)|([a-z]{letra}*)
name [A-Z]{letra}*{cardinal}+
symbol [\[\]\{\}\(\)><">=""<=",]
type ("xsd:"|"rdfs:"|"owl:")[a-z]*
%%
{brancos}	; // nenhuma ação e nenhum retorno
"some"|"SOME" return SOME;
"all"|"ALL" return ALL;
"value"|"VALUE" return VALUE;
"min"|"MIN" return MIN;
"max"|"MAX" return MAX;
"exactly"|"EXACTLY" return EXACTLY;
"that"|"THAT" return THAT;
"not"|"NOT" return NOT;
"AND"|"and" return AND;
"OR"|"or" return OR;
"Class": return Class;
"EquivalentTo": return EquivalentTo;
"Individuals": return Individuals;
"SubClassOf": return SubClassOf;
"DisjointClasses": return DisjointClasses;
{type} return TYPE;
{symbol} return SYMBOL;
{prop} return PROP;
{name} return NAME;
{id}		return ID;  
{cardinal}	    return CARDINAL; 
.           cout << YYText() << " é um token inválido!\n"; 
%%

// nenhuma função auxiliar é necessária
