#include "parser.h"
#include "tokens.h"
#include <iostream>
using std::cout;

void Parser::Start()
{
    // enquanto não atingir o fim da entrada
    while ((lookahead = scanner.yylex()) != 0)
    {
        // trata o token recebido do analisador léxico
        switch(lookahead)
        {
            case ID: 
                cout << "ID:";
                cout << scanner.YYText() << std::endl;
                break;
            case 
                PROP: cout << "PROP:";
                cout << scanner.YYText() << std::endl;
                break;
            case NAME:
                cout << "NAME:";
                cout << scanner.YYText() << std::endl;
                break;
            case CARDINAL:
                cout << "cardinal:";
                cout << scanner.YYText() << std::endl;
                break;
            case SOME: 
                cout << "SOME:";
                cout << scanner.YYText() << std::endl;
                break;
            case ALL:
                cout << "ALL:";
                cout << scanner.YYText() << std::endl;
                break;
            case VALUE:
                cout << "VALUE:";
                cout << scanner.YYText() << std::endl;
                break;
            case MIN:
                cout << "MIN:";
                cout << scanner.YYText() << std::endl;
                break;
            case MAX:
                cout << "MAX:";
                cout << scanner.YYText() << std::endl;
                break; 
            case EXACTLY:
                cout << "EXACTLY:";
                cout << scanner.YYText() << std::endl;
                break;
            case THAT:
                cout << "THAT:";
                cout << scanner.YYText() << std::endl;
                break;
            case NOT:
                cout << "NOT:";
                cout << scanner.YYText() << std::endl;
                break;
            case AND:
                cout << "AND:";
                cout << scanner.YYText() << std::endl;
                break;
            case OR:
                cout << "OR:";
                cout << scanner.YYText() << std::endl;
                break;
            case Class:
                cout << "Class:";
                cout << scanner.YYText() << std::endl;
                break;
            case EquivalentTo:
                cout << "EquivalentTo:";
                cout << scanner.YYText() << std::endl;
                break;
            case Individuals:
                cout << "Individuals:";
                cout << scanner.YYText() << std::endl;
                break;
            case SubClassOf:
                cout << "SubClassOf:";
                cout << scanner.YYText() << std::endl;
                break;
            case DisjointClasses:
                cout << "DisjointClasses:";
                cout << scanner.YYText() << std::endl;
                break;
            case SYMBOL:
                cout << "SYMBOL:";
                cout << scanner.YYText() << std::endl;
                break;
            case TYPE:
                cout << "TYPE:";
                cout << scanner.YYText() << std::endl;
                break;
        }
    }
}
