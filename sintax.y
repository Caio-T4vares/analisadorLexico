%{
/* analisador sintático para reconhecer frases em português */
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token SOME ALL VALUE MIN MAX EXACTLY THAT NOT AND 
  OR ONLY Class EquivalentTo Individuals SubClassOf DisjointClasses 
  ID PROP NAME NUMERO RELATIONAL TYPE VIRGULA ABREPARENTESES FECHAPARENTESES
	ABRECHAVE FECHACHAVE ABRECOLCHETE FECHACOLCHETE

%%

decl: decl classeDecl 
			| classeDecl
			;

classeDecl: Class ID definicao {cout << "A classe é válida!";}
			;

definicao: definicao axioma 
					| axioma
			;

axioma: subClasse |
			 listaIndividuos |
			 equivalencia |
			 disjoint | 
				;
subClasse: SubClassOf subClassCorpo /*Tem que especificar o que é uma subClasse (começa com subClassOf)*/
				;
subClassCorpo: subClassCorpo PROP subclassDescricao divisor |  subClassCorpo ID divisor |
				;
subclassDescricao: palavraChave idOrType | palavraChave ABREPARENTESES ID palavraChave ID FECHAPARENTESES
idOrType: ID | TYPE
				;	
listaIndividuos: Individuals listaIndividuosCorpo
				;
listaIndividuosCorpo : listaIndividuosCorpo NAME divisor |
				;
equivalencia: EquivalentTo equivalenciaCorpo 
				;
equivalenciaCorpo: ID palavraChave equivalenciaDescricao |
					ABRECHAVE conjuntoDeInstancias FECHACHAVE|
					conjuntoDeClasses
				; 

equivalenciaDescricao: ABREPARENTESES PROP palavraChave propriedade FECHAPARENTESES 
											| ABREPARENTESES PROP palavraChave propriedade FECHAPARENTESES 
				;

conjuntoDeInstancias: conjuntoDeInstancias VIRGULA ID|
						ID
;

conjuntoDeClasses: conjuntoDeClasses OR ID|
					ID
;

propriedade: equivalenciaDescricao | ID | TYPE conditional
conditional: ABRECOLCHETE RELATIONAL NUMERO FECHACOLCHETE 
				;
disjoint: DisjointClasses disjointCorpo 
				;
disjointCorpo: disjointCorpo ID divisor |
divisor: VIRGULA |
				;
palavraChave : SOME | ALL | VALUE | MIN | MAX | EXACTLY | THAT | NOT | AND | OR | ONLY
				;
%%

/* definido pelo analisador léxico */
extern FILE * yyin;  

int main(int argc, char ** argv)
{
	/* se foi passado um nome de arquivo */
	if (argc > 1)
	{
		FILE * file;
		file = fopen(argv[1], "r");
		if (!file)
		{
			cout << "Arquivo " << argv[1] << " não encontrado!\n";
			exit(1);
		}
		
		/* entrada ajustada para ler do arquivo */
		yyin = file;
	}

	yyparse();
}

void yyerror(const char * s)
{
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   

	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}
