%{
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
extern char *yytext;
bool ehFechamento = false;
bool ehAninhada = false;
%}

%token SOME ALL VALUE MIN MAX EXACTLY THAT NOT AND 
  OR ONLY Class EquivalentTo Individuals SubClassOf DisjointClasses 
  ID PROP NAME NUMERO RELATIONAL TYPE VIRGULA ABREPARENTESES FECHAPARENTESES
	ABRECHAVE FECHACHAVE ABRECOLCHETE FECHACOLCHETE

%%

programa: programa classeDecl 
			| classeDecl
			;

classeDecl: Class ID {cout << "Classe: " << yytext << " --> ";} classBody {cout << std::endl << std::endl;} 
			;
classBody: subclasse opcional{cout  << "Primitiva";}
					 | enumerado opcional{cout   << "Enumerada";}
					 | equivalencia opcional{cout  << "Definida";}
					 | coberta opcional{cout  << "Coberta" ;}
					 ;
opcional: individuos disjuncao 
					| individuos 
					| disjuncao individuos 
					| disjuncao
					|
			;

/*SubClassOf*/
subclasse: SubClassOf subclasseBody
			;
subclasseBody: subclasseBody subClasseProperty 
					| subClasseProperty
			;
subClasseProperty: PROP SOME ID divisor
					| PROP SOME TYPE divisor
					| PROP minMaxExactly NUMERO optionalType divisor
					| PROP VALUE NAME divisor
					| ABREPARENTESES equivalenciaExpression FECHAPARENTESES andOrNothing divisor
					| ID descricao divisor /*TO USANDO O DESCRICAO QUE EU CRIEI MAIS ABAIXO*/
					| ID divisor
					|PROP ONLY onlyExpression{cout <<  "Fechamento e ";}
			;

					

/*EquivalentTo*/
equivalencia: EquivalentTo ID conjuntoDescricoes
			;

enumerado: EquivalentTo ABRECHAVE conjuntoDeInstancias FECHACHAVE 
			;

coberta: EquivalentTo conjuntoDeClasses
		;

conjuntoDescricoes: conjuntoDescricoes descricao 
					| descricao
			;
descricao: AND descricaoExpression
			;
descricaoExpression: ABREPARENTESES equivalenciaExpression FECHAPARENTESES
			;
equivalenciaExpression:	PROP SOME ID
					| PROP SOME TYPE ABRECOLCHETE RELATIONAL NUMERO FECHACOLCHETE
					| PROP SOME TYPE
					| PROP SOME descricaoExpression {cout << "Aninhada e ";}
					| PROP VALUE NAME
					| PROP minMaxExactly NUMERO optionalType
					| PROP minMaxExactly NUMERO ID
					| PROP ONLY onlyExpression
			;
conjuntoDeInstancias: conjuntoDeInstancias VIRGULA NAME|
						NAME
			;

conjuntoDeClasses: conjuntoDeClasses OR ID|
					ID
			;
/*Individuals*/
individuos: Individuals listaIndividios
			;
listaIndividios: NAME VIRGULA listaIndividios 
					| NAME
			;
/*DisjointClasses*/
disjuncao: DisjointClasses listaClasses
			;
listaClasses: listaClasses ID divisor 
					| ID divisor
			;
onlyExpression: ABREPARENTESES onlyExpressionClasses FECHAPARENTESES 
					| ID
			;
onlyExpressionClasses: ID OR onlyExpressionClasses 
					| ID
			;
optionalType: TYPE | 
			;
minMaxExactly: MIN | MAX | EXACTLY 
			;
divisor: VIRGULA |
			;
andOrNothing: AND | 
			;
/*Após o value sempre vem instâncias*/
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
