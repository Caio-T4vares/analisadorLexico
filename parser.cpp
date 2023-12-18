#include "parser.h"
#include <iostream>
using std::cout;

Parser::Parser()
{
    // insere as palavras-reservadas na tabela de id's
	id_table["some"] = tag::SOME;
	id_table["all"] = tag::ALL;
	id_table["value"] = tag::VALUE;
	id_table["min"] = tag::MIN;
	id_table["max"] = tag::MAX;
	id_table["exactly"] = tag::EXACTLY;
	id_table["that"] = tag::THAT;
	id_table["not"] = tag::NOT;
	id_table["and"] = tag::AND;
	id_table["or"] = tag::OR;
	id_table["class"] = tag::Class;
	id_table["equivalentto"] = tag::EquivalentTo;
	id_table["individuals"] = tag::Individuals;
	id_table["subclassof"] = tag::SubClassOf;
	id_table["disjointclasses"] = tag::DisjointClasses;

}

void Parser::AddInIdTable(string s, tag t){
                auto pos = id_table.find(s);

                // se o lexema não está na tabela
                if (pos == id_table.end())
                {
                    id_table[s] = t;
                }
                
}

void Parser::Start()
{
    // enquanto não atingir o fim da entrada
    while ((lookahead = scanner.yylex()) != 0)
    {
        // trata o token recebido do analisador léxico
        string s = scanner.YYText();
        switch(lookahead)
        {
            case ID: 
                cout << "ID:";
                cout << scanner.YYText() << std::endl;
                AddInIdTable(s, tag::ID);
                break;
            case 
                PROP: cout << "PROP:";
                cout << scanner.YYText() << std::endl;
                AddInIdTable(s, tag::PROP);
                break;
            case NAME:
                cout << "NAME:";
                cout << scanner.YYText() << std::endl;
                AddInIdTable(s, tag::NAME);
                break;
            case CARDINAL:
                cout << "cardinal:";
                cout << scanner.YYText() << std::endl;
                AddInIdTable(s, tag::CARDINAL);
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
                AddInIdTable(s, tag::SYMBOL);
                break;
            case TYPE:
                cout << "TYPE:";
                cout << scanner.YYText() << std::endl;
                AddInIdTable(s, tag::TYPE);
                break;
        }
    }

    for (auto it = id_table.begin(); it != id_table.end(); ++it) {
        // Imprime a chave e o valor
        std::cout << it->first << ": " << it->second << std::endl;
  }
}
