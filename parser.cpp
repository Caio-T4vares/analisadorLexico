#include "parser.h"
#include <iostream>
using std::cout;
using std::endl;

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
	id_table["Class"] = tag::Class;
	id_table["EquivalentTo"] = tag::EquivalentTo;
	id_table["individuals"] = tag::Individuals;
	id_table["SubClassOf"] = tag::SubClassOf;
	id_table["DisjointClasses"] = tag::DisjointClasses;

}

bool Parser::AddInIdTable(string s, tag t){
                auto pos = id_table.find(s);

                // se o lexema não está na tabela
                if (pos == id_table.end())
                {
                    id_table[s] = t;
                    return true;
                }
                return false;
                
}
void Parser::AddInTodosTokens(string token, string nomeId){
        todosTokensList.push_back("<"+ token + ", " + nomeId + ">");
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
                AddInTodosTokens("ID", s);
                idQuant += 1;
                if(AddInIdTable(s, tag::ID))idClassesList.push_back(s);
                break;
            case PROP:
                AddInTodosTokens("PROP", s);
                propQuant += 1;
                if(AddInIdTable(s, tag::PROP))propsList.push_back(s);
                break;
            case NAME:
                AddInTodosTokens("NAME", s);
                nameQuant += 1;
                if(AddInIdTable(s, tag::NAME))namesList.push_back(s);
                break;
            case CARDINAL:
                AddInTodosTokens("CARDINAL", s);
                cardinalQuant += 1;
                if(AddInIdTable(s, tag::CARDINAL))cardinalList.push_back(s);
                break;
            case SOME: 
                AddInTodosTokens("SOME", "some");
                someQuant += 1;
                break;
            case ALL:
                AddInTodosTokens("ALL", "all");
                allQuant += 1;
                break;
            case VALUE:
                AddInTodosTokens("VALUE", "value");
                valueQuant += 1;
                break;
            case MIN:
                AddInTodosTokens("MIN", "min");
                minQuant += 1;
                break;
            case MAX:
                AddInTodosTokens("MAX", "max");
                maxQuant += 1;
                break; 
            case EXACTLY:
                AddInTodosTokens("EXACTLY", "exactly");
                exactlyQuant += 1;
                break;
            case THAT:
                AddInTodosTokens("THAT", "that");
                thatQuant += 1;
                break;
            case NOT:
                AddInTodosTokens("NOT", "not");
                notTokenQuant += 1;
                break;
            case AND:
                AddInTodosTokens("AND", "and");
                andTokenQuant += 1;
                break;
            case OR:
                AddInTodosTokens("OR", "or");
                orTokenQuant += 1;
                break;
            case Class:
                AddInTodosTokens("CLASS", "class:");
                ClassQuant += 1;
                break;
            case EquivalentTo:
                AddInTodosTokens("EQUIVALENTTO", "EquivalentTo:");
                EquivalentToQuant += 1;
                break;
            case Individuals:
                AddInTodosTokens("INDIVIDUALS", "individuals:");
                IndividualsQuant += 1;
                break;
            case SubClassOf:
                AddInTodosTokens("SUBCLASSOF", "SubClassOf:");
                SubClassOfQuant += 1;
                break;
            case DisjointClasses:
                AddInTodosTokens("DISJOINTCLASSES", "DisjointClasses");
                DisjointClassesQuant += 1;
                break;
            case SYMBOL:
                AddInTodosTokens("SYMBOL", s);
                symbolQuant += 1;
                AddInIdTable(s, tag::SYMBOL);
                break;
            case TYPE:
                AddInTodosTokens("TYPE", s);
                typeQuant += 1;
                if(AddInIdTable(s, tag::TYPE))typesList.push_back(s);
                break;
        }
    }

    cout << "          Resumo dos tokens do arquivo" << endl;
    cout << "******************************************************" << endl;
    cout << "         Quantidade total de tokens: " << todosTokensList.size() << endl; 
    cout << endl;
    cout << "Quantidades sem repetição: " << endl;
    cout << "      Cardinais: " << cardinalList.size() << "  |  Id's: " << idClassesList.size() << "  |  Props: " << propsList.size() << endl;
    cout << "      Names: " << namesList.size() << "  |  Types: " << typesList.size() << endl << endl;
    cout << "Quantidade com repetição: " << endl;
    cout << "      Cardinais: " << cardinalQuant << "  |  Id's: " << idQuant << "  |  Props: " << propQuant << endl;
    cout << "      Names: " << nameQuant << "  |  Types: " << typeQuant << "  |  Symbol: " << symbolQuant << endl;
    cout<< "      Some: " << someQuant << "  |  All: " << allQuant << "  |  Value: " << valueQuant << endl;
    cout << "      Min: " << minQuant << "  |  Max: " << maxQuant << "  |  Exactly: " << exactlyQuant << endl;
    cout << "      That: " << thatQuant << "  |  Not: " << notTokenQuant << "  |  And: " << andTokenQuant << endl;
    cout << "      Or: " << orTokenQuant << "  |  Individuals: " << IndividualsQuant << "  |  Class: " << ClassQuant << endl;
    cout << "      EquivalentTo: " << EquivalentToQuant << "  |  SubClassOf: " << SubClassOfQuant << "  |  DisjointClasses: " << DisjointClassesQuant << endl;
    cout << "******************************************************" << endl;
    cout << "Nomes sem repetições:" << endl;

    cout << "   Cardinais: " << endl << "     ";
    for (int x = 0; x < cardinalList.size(); x++){
     cout << cardinalList[x] + ", ";
     if((x+1) % 10 == 0){
         cout << endl << "     ";
     }
   }
   cout << endl << endl;

   cout << "   Id's: " << endl << "     ";
    for (int x = 0; x < idClassesList.size(); x++){
     cout << idClassesList[x] + ", ";
     if((x+1) % 5 == 0){
         cout << endl << "     ";
     }
   }
   cout << endl << endl;

   cout << "   Props: " << endl << "     ";
    for (int x = 0; x < propsList.size(); x++){
     cout << propsList[x] + ", ";
     if((x+1) % 5 == 0){
         cout << endl << "     ";
     }
   }
   cout << endl << endl;

   cout << "   Names: " << endl << "     ";
    for (int x = 0; x < namesList.size(); x++){
     cout << namesList[x] + ", ";
     if((x+1) % 5 == 0){
         cout << endl << "     ";
     }
   }
   cout << endl << endl;

   cout << "   Types: " << endl << "     ";
    for (int x = 0; x < typesList.size(); x++){
     cout << typesList[x] + ", ";
     if((x+1) % 5 == 0){
         cout << endl << "     ";
     }
   }
   cout << endl << endl;

//   for (int x = 0; x < todosTokensList.size(); x++){
//     cout << todosTokensList[x] + " ";
//     if((x+1) % 5 == 0){
//         cout << endl;
//         cout << endl;
//     }
//   }
}
