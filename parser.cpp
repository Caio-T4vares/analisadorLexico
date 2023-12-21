#include "parser.h"
#include <iostream>
using std::cout;
using std::endl;

Parser::Parser()
{
//      SOME=1, ALL, VALUE, MIN, MAX, EXACTLY, THAT, NOT, AND,
//   OR, Class, EquivalentTo, Individuals, SubClassOf, DisjointClasses,
//   ID, PROP, NAME,CARDINAL,SYMBOL, TYPE
//   }; 
    // insere as palavras-reservadas na tabela de id's
	id_table["some"] = "SOME";
	id_table["all"] = "ALL";
	id_table["value"] = "VALUE";
	id_table["min"] = "MIN";
	id_table["max"] = "MAX";
	id_table["exactly"] = "EXACTLY";
	id_table["that"] = "THAT";
	id_table["not"] = "NOT";
	id_table["and"] = "AND";
	id_table["or"] = "OR";
    id_table["only"] = "ONLY";
	id_table["Class:"] = "Class";
	id_table["EquivalentTo"] = "EquivalentTo";
	id_table["individuals"] = "Individuals";
	id_table["SubClassOf"] = "SubClassOf";
	id_table["DisjointClasses"] = "DisjointClasses";

}

bool Parser::AddInIdTable(string s, string t){
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
    int numLinha = 0;
    while ((lookahead = scanner.yylex()) != 0)
    {
        // trata o token recebido do analisador léxico
        string s = scanner.YYText();
        switch(lookahead)
        {
            case ID: 
                AddInTodosTokens("ID", s);
                idQuant += 1;
                if(AddInIdTable(s, "ID"))idClassesList.push_back(s);
                break;
            case PROP:
                AddInTodosTokens("PROP", s);
                propQuant += 1;
                if(AddInIdTable(s, "PROP"))propsList.push_back(s);
                break;
            case NAME:
                AddInTodosTokens("NAME", s);
                nameQuant += 1;
                if(AddInIdTable(s, "NAME"))namesList.push_back(s);
                break;
            case CARDINAL:
                AddInTodosTokens("CARDINAL", s);
                cardinalQuant += 1;
                if(AddInIdTable(s, "CARDINAL"))cardinalList.push_back(s);
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
                AddInIdTable(s, "SYMBOL");
                break;
            case TYPE:
                AddInTodosTokens("TYPE", s);
                typeQuant += 1;
                if(AddInIdTable(s, "TYPE"))typesList.push_back(s);
                break;
            case ONLY:
                AddInTodosTokens("ONLY", s);
                typeQuant += 1;
                if(AddInIdTable(s, "ONLY"))typesList.push_back(s);
        }
    }
    cout << "************************************************************************************************************" << endl;
    cout << "---------------------------------Resumo dos tokens do arquivo-----------------------------------------------" << endl;
    cout << "************************************************************************************************************" << endl;
    cout << "                                 Quantidade total de tokens: " << todosTokensList.size() << endl; 
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
    cout << "************************************************************************************************************" << endl;
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
   cout << "************************************************************************************************************" << endl;
    cout <<"-----------------------------------------------HASH TABLE---------------------------------------------------" << endl;
    cout << "************************************************************************************************************" << endl;

    int xd = 1;
    for (auto it = id_table.begin(); it != id_table.end(); ++it) {
        std::cout << " *" << it->first << ": " << it->second << "*        ";
        if(xd % 3 == 0){
            cout << endl << endl;
        }
        xd++;
  }
//   for (int x = 0; x < todosTokensList.size(); x++){
//     cout << todosTokensList[x] + " ";
//     if((x+1) % 5 == 0){
//         cout << endl;
//         cout << endl;
//     }
//   }
}
