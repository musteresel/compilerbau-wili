%{
#include "node.hpp"
Block * toplevel_block;
extern int yylex();
void yyerror(const char * s);
%}

%union {
  Expr * expression;
  Block * block;
  If * ifexpression;
	Assignment * assignment;
  Identifier * identifier;
  Operator * operator;
  std::string * string;
  int token;
}

%token <string> LITERAL_FLOAT LITERAL_DECOR IDENTIFIER
%token <string> QUERY_INTERVAL OPERATOR_INTERVAL COMPARE_INTERVAL
%token <string> OPERATOR_FLOAT COMPARE_FLOAT

%type <identifier> identifier
%type <expression> numeric expr block 

%%

program : expr

expr : block
		 | ifexpression
		 | assignment
     | identifier
     | operator
		 | numeric

block : '{' expressions '}'

expressions : expressions ';' expr
						| expr

ifexpression : IF '(' expr ')' expr ELSE expr

assigment : identifier OPERATOR_TYPE identifier ASSIGNMENT expr

identifier : IDENTIFIER

operator : expr 




b_ident : T_IDENT { $$ = new Identifier($1); }
b_numeric : T_NUMERIC { $$ = new Numeric($1); }


