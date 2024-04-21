%{
#include <iostream>
#include <set>
#include <list>
#include <unordered_map>
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

bool erroSemantico = false;
bool erro = false;
std::list<string> propsDeclaradas;
void setProp(string prop){
	propsDeclaradas.push_back(prop);
}
void isPropDeclared(string nomeClasse){
	yyerror("Pode chamar aqui?");
};

%}
%union{
	char texto[40];
	int inteiro;
	float pontoFlutuante;
}

%token<texto> SOME ALL VALUE MIN MAX EXACTLY THAT NOT AND 
  OR ONLY Class EquivalentTo Individuals SubClassOf DisjointClasses 
  ID PROP NAME RELATIONAL TYPEINTEGER TYPE VIRGULA ABREPARENTESES FECHAPARENTESES
	ABRECHAVE FECHACHAVE ABRECOLCHETE FECHACOLCHETE
%token <inteiro> INTEIRO
%token <pontoFlutuante> PONTOFLUTUANTE
%%

programa: programa classeDecl 
			| classeDecl
			;

classeDecl: Class ID {cout << yytext << " --> ";} classBody {cout  << std::endl; contadorClasses++; } 
			;
classBody: subclasse opcional{cout  << "Primitiva"; contadorPrimitivas++;}
					 | equivalencia subclasse opcional{cout << "Definida"; contadorDefinidas++;}
					 | enumerado subclasse opcional{cout << "Definida enumerada"; contadorEnumeradas++; contadorDefinidas++;}
					 | equivalenciaTipos opcional
					 | coberta subclasse opcional{cout << "Coberta, Definida"; contadorCobertas++; contadorDefinidas++;}
					 | subclasse equivalenciaTipos opcional{erroSemantico = true;yyerror("Erro semântico! Ordem errada de operadores.");}
					 ;
equivalenciaTipos: enumerado{cout   << "Definida enumerada"; enumerada.insert(classeEmAnalise); contadorEnumeradas++; contadorDefinidas++;}
					 | coberta{cout << "Definida coberta"; contadorCobertas++; contadorDefinidas++;}
					 | equivalencia{cout  << "Definida"; contadorDefinidas++;}
opcional:  disjuncao individuos
					| individuos disjuncao {erroSemantico = true;yyerror("Erro semântico! Ordem errada de operadores.");}
					| individuos 
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
					| PROP minMaxExactly INTEIRO optionalType divisor 
					| PROP minMaxExactly optionalType divisor {erroSemantico = true; yyerror("Erro semântico! É esperado um inteiro depois do Min/max/Exactly"); }
					| PROP VALUE NAME divisor
					| ABREPARENTESES equivalenciaExpression FECHAPARENTESES andOrNothing divisor
					| ID descricao divisor
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
					| PROP SOME TYPEINTEGER ABRECOLCHETE RELATIONAL INTEIRO FECHACOLCHETE 
					| PROP SOME TYPEINTEGER ABRECOLCHETE RELATIONAL FECHACOLCHETE {erroSemantico = true; yyerror("Erro semântico! É esperado um inteiro depois do operador"); }
					| PROP SOME TYPEINTEGER ABRECOLCHETE INTEIRO FECHACOLCHETE { erroSemantico = true; yyerror("Erro semântico! É esperado um operador antes do inteiro");}
					| PROP SOME TYPE
					| PROP SOME descricaoExpression {cout << "Com aninhamento, "; contadorAninhadas++;}
					| PROP VALUE NAME
					| PROP minMaxExactly INTEIRO optionalType
					| PROP minMaxExactly optionalType{erroSemantico = true; yyerror("Erro semântico! É esperado um inteiro depois do min/max/exactly"); }
					| PROP minMaxExactly INTEIRO ID
					| PROP minMaxExactly ID{erroSemantico = true; yyerror("Erro semântico! É esperado um inteiro depois do min/max/exactly"); }
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
	if(!erro){
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


}

void yyerror(const char * s)
{
	erro = true;
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   
	if(erroSemantico){
		cout << s << " - linha " << yylineno << "\n";
	}else{

		cout << s << std::endl;
	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
	}
}