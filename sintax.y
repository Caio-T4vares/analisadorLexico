%{
#include <iostream>
#include <set>
using std::cout;
using std::set;
using std::string;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
extern char *yytext;

string classeEmAnalise;
set<string> enumerada;
int contadorClasses = 0;
int contadorPrimitivas = 0;
int contadorDefinidas = 0;
int contadorCobertas = 0;
int contadorAninhadas = 0;
int contadorEnumeradas = 0;
int contadorFechamentos = 0;


%}

%token SOME ALL VALUE MIN MAX EXACTLY THAT NOT AND 
  OR ONLY Class EquivalentTo Individuals SubClassOf DisjointClasses 
  ID PROP NAME NUMERO RELATIONAL TYPE VIRGULA ABREPARENTESES FECHAPARENTESES
	ABRECHAVE FECHACHAVE ABRECOLCHETE FECHACOLCHETE

%%

programa: programa classeDecl 
			| classeDecl
			;

classeDecl: Class ID {cout << yytext << " --> ";} classBody {cout  << std::endl; contadorClasses++; } 
			;
classBody: subclasse opcional{cout  << "Primitiva"; contadorPrimitivas++;}
					 | enumerado opcional{cout   << "Enumerada"; enumerada.insert(classeEmAnalise); contadorEnumeradas++;}
					 | equivalencia opcional{cout  << "Definida"; contadorDefinidas++;}
					 | coberta opcional{cout  << "Coberta" ; contadorCobertas++;}
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
					|PROP ONLY onlyExpression{cout <<  "Com fechamento, "; contadorFechamentos++;}
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
					| PROP SOME descricaoExpression {cout << "Com aninhamento, "; contadorAninhadas++;}
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

	// printando os resultados (Os contadores)
	cout << std::endl << std::endl;
	cout << "Contagem dos tipos de classes : " << std::endl;
	cout << "Primitivas : " << contadorPrimitivas << std::endl;
	cout << "Definidas : " << contadorDefinidas << std::endl;
	cout << "Com aninhamento : " << contadorAninhadas << std::endl;
	cout << "Com fechamentos : " << contadorFechamentos << std::endl;
	cout << "Enumeradas : " << contadorEnumeradas << std::endl;
	cout << "Cobertas : " << contadorCobertas << std::endl;
	cout << "Total de classes diferentes : " << contadorClasses << std::endl;


}

void yyerror(const char * s)
{
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   

	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}
