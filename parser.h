#include <FlexLexer.h>
#include "tokens.h"
#include <deque>
#include <string>
#include <unordered_map>

using std::unordered_map;
using std::string;
using std::deque;

class Parser
{
private:
	yyFlexLexer scanner;
	int lookahead;
	unordered_map<string, string> id_table;

	void AddInTodosTokens(string token, string nomeId);
	bool AddInIdTable(string s, string t);

	deque<string> todosTokensList;
    deque<string> cardinalList;
    deque<string> idClassesList;
    deque<string> propsList;
    deque<string> namesList;
    deque<string> typesList;
	int cardinalQuant=0;
	int idQuant=0;
	int propQuant=0;
	int nameQuant=0;
	int typeQuant=0;
    int symbolQuant =0;
    int someQuant=0;
    int allQuant=0;
    int valueQuant=0;
    int minQuant=0;
    int maxQuant=0;
    int exactlyQuant=0;
    int thatQuant=0;
    int notTokenQuant=0;
    int andTokenQuant=0;
    int orTokenQuant=0;
    int IndividualsQuant=0;
    int ClassQuant=0;
    int EquivalentToQuant=0;
    int SubClassOfQuant=0;
    int DisjointClassesQuant=0;
	int onlyQuant=0;
	
public:
	Parser();
	void Start();
};
