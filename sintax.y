%{
#include <iostream>
#include <set>
#include <list>
#include <unordered_map>
#include <string>

using std::cout;
using std::set;
using std::string;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
extern char *yytext;

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
std::list<string> props;

string classeEmAnalise;
string tiposClasse;
string textoTemporario;
string propEmAnalise;
std::unordered_map<string,string> propsPerClass;

void isPropDeclared(string nomeProp){
	bool isDeclared = false;
	for(string prop: props){
		if(nomeProp == prop)
			isDeclared = true;
	}

	if(!isDeclared){
		erroSemantico = true;
		yyerror("Erro semântico, as propriedades presentes no axioma de fechamento devem ser previamente declaradas!");
	}
}
void limpar(){
	props.clear();
	propsPerClass.clear();
	tiposClasse = "";
	classeEmAnalise = "";
	propEmAnalise = "";
	textoTemporario = "";
	classeEmAnalise = "";
	erroSemantico = false;
}
void printar(){
	if(!erroSemantico){
		cout << "\n" << textoTemporario << tiposClasse << std::endl;
		if(propsPerClass.size() > 0){
			cout << "\t" << "Propriedades da classe e seus tipos:" << "\n";
		}
		for (const auto& pair : propsPerClass) {
        std::cout << "\t\t" << pair.first << " --> " << pair.second << std::endl;
    }
		limpar();
	}
}
void ErroSemanticoMinMaxExactly(){
	erroSemantico = true; 
	yyerror("Erro semântico! É esperado um inteiro depois do Min/max/Exactly");
};

%}

%token SOME ALL VALUE MIN MAX EXACTLY THAT NOT AND 
  OR ONLY Class EquivalentTo Individuals SubClassOf DisjointClasses 
  NAME RELATIONAL TYPEINTEGER TYPE VIRGULA ABREPARENTESES FECHAPARENTESES
	ABRECHAVE FECHACHAVE ABRECOLCHETE FECHACOLCHETE
%token PROP ID
%token INTEIRO
%token PONTOFLUTUANTE
%%

programa: programa classeDecl {printar();}
			| classeDecl {printar();}	
			;

classeDecl: Class ID {classeEmAnalise = yytext;textoTemporario = string(yytext) + " --> ";} 
					classBody {contadorClasses++;}
			;
classBody: subclasse opcional{tiposClasse += "Primitiva"; contadorPrimitivas++;}
					 | equivalencia subclasse opcional{tiposClasse += "Definida"; contadorDefinidas++;}
					 | enumerado subclasse opcional{tiposClasse += "Definida enumerada"; contadorEnumeradas++; contadorDefinidas++;}
					 | equivalenciaTipos opcional
					 | coberta subclasse opcional{tiposClasse += "Coberta, Definida"; contadorCobertas++; contadorDefinidas++;}
					 | subclasse equivalenciaTipos opcional{erroSemantico = true;yyerror("Erro semântico! SubclassOf antes de EquivalentTo. ");}
					 |opcional {erroSemantico = true;yyerror("Erro semântico! Opcionais não devem aparecer primeiro. ");}
					 ;
equivalenciaTipos: enumerado{tiposClasse += "Definida enumerada"; enumerada.insert(classeEmAnalise); contadorEnumeradas++; contadorDefinidas++;}
					 | coberta{tiposClasse += "Definida coberta"; contadorCobertas++; contadorDefinidas++;}
					 | equivalencia{tiposClasse  += "Definida"; contadorDefinidas++;}
opcional:  disjuncao individuos
					|disjuncao equivalenciaTipos individuos {erroSemantico = true;yyerror("Erro semântico! EquivalentTo não deve aparecer depois das opcionais ");}
					|disjuncao equivalenciaTipos {erroSemantico = true;yyerror("Erro semântico! EquivalentTo não deve aparecer depois das opcionais ");}
					|disjuncao individuos equivalenciaTipos {erroSemantico = true;yyerror("Erro semântico! EquivalentTo não deve aparecer depois das opcionais ");}
					|individuos equivalenciaTipos {erroSemantico = true;yyerror("Erro semântico! EquivalentTo não deve aparecer depois das opcionais ");}
					|disjuncao subclasse individuos {erroSemantico = true;yyerror("Erro semântico! subClasseOf não deve aparecer depois das opcionais ");}
					|disjuncao subclasse {erroSemantico = true;yyerror("Erro semântico! subClasseOf não deve aparecer depois das opcionais ");}
					|disjuncao individuos subclasse {erroSemantico = true;yyerror("Erro semântico! subClasseOf não deve aparecer depois das opcionais ");}
					|individuos subclasse {erroSemantico = true;yyerror("Erro semântico! subClasseOf não deve aparecer depois das opcionais ");}
					|individuos disjuncao {erroSemantico = true;yyerror("Erro semântico! Individuals antes de DisjointClasses. ");}
					|individuos 
					|disjuncao
					|
			;

/*SubClassOf*/
subclasse: SubClassOf subclasseBody
			;
subclasseBody: subclasseBody {propEmAnalise = yytext;} subClasseProperty 
					| subClasseProperty
			;
subClasseProperty: PROP SOME identificador divisor {propsPerClass[propEmAnalise] = string("Object Property");}
					| PROP SOME TYPE divisor {propsPerClass[propEmAnalise] = string("Data Property");}
					| PROP minMaxExactly INTEIRO optionalType divisor 
					| PROP minMaxExactly optionalType divisor {ErroSemanticoMinMaxExactly(); }
					| PROP VALUE NAME divisor
					| ABREPARENTESES equivalenciaExpression FECHAPARENTESES andOrNothing divisor
					| ID descricao divisor
					| ID divisor
					| PROP ONLY onlyExpression divisor{tiposClasse +=  string("Com fechamento, "); contadorFechamentos++;}
					| ABREPARENTESES PROP minMaxExactly INTEIRO TYPE FECHAPARENTESES divisor
					| ABREPARENTESES PROP minMaxExactly TYPE FECHAPARENTESES divisor{ ErroSemanticoMinMaxExactly();}
			;


identificador: ID {props.push_back(yytext);}
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
descricaoExpression: ABREPARENTESES PROP{propEmAnalise = yytext;} equivalenciaExpression FECHAPARENTESES
			;
equivalenciaExpression:	SOME identificador {;propsPerClass[propEmAnalise] = string("Object Property");}
					| SOME TYPEINTEGER ABRECOLCHETE RELATIONAL INTEIRO FECHACOLCHETE {propsPerClass[propEmAnalise] = string("Data Property");}
					| SOME TYPEINTEGER ABRECOLCHETE FECHACOLCHETE {erroSemantico = true; yyerror("Erro semântico! É esperado um operador relacional com um inteiro dentro dos colchetes");}
					| SOME TYPEINTEGER ABRECOLCHETE RELATIONAL FECHACOLCHETE {erroSemantico = true; yyerror("Erro semântico! É esperado um inteiro depois do operador");}
					| SOME TYPEINTEGER ABRECOLCHETE INTEIRO FECHACOLCHETE { erroSemantico = true; yyerror("Erro semântico! É esperado um operador antes do inteiro");}
					| SOME TYPE {propsPerClass[propEmAnalise] = string("Data Property");}
					| SOME aninhamento {textoTemporario += string("Com aninhamento, "); contadorAninhadas++;}
					| VALUE NAME
					| minMaxExactly INTEIRO optionalType
					| minMaxExactly optionalType{ErroSemanticoMinMaxExactly(); }
					| minMaxExactly INTEIRO ID
					| minMaxExactly ID{ErroSemanticoMinMaxExactly(); }
					| ONLY onlyExpression
			;
aninhamento: descricaoExpression;
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
					| idOnly
			;
onlyExpressionClasses: idOnly OR onlyExpressionClasses 
					| idOnly
			;
idOnly: ID{isPropDeclared(yytext);}
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
		//cout << textoTemporario;
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
		cout << s << " na linha: " << yylineno <<"\n";
	}else{
		/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro Sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
	}
}