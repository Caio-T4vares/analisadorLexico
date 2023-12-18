#include <FlexLexer.h>
#include "tokens.h"

#include <unordered_map>
#include <string>
using std::unordered_map;
using std::string;

class Parser
{
private:
	yyFlexLexer scanner;
	int lookahead;
	unordered_map<string, tag> id_table;

	void AddInIdTable(string s, tag t);
	
public:
	Parser();
	void Start();
};
