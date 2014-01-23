%{
#include <iostream>
#include <string>
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define YY_DECL extern "C" int yylex()
int linenum = 1;
%}
%%
[ \t]                                  ;
\n                                     ++linenum;
[+-]?(([0-9]*(\.[0-9]+)?)|infinite)    SAVE_TOKEN; return LITERAL_FLOAT;
COM|DAC|DEF|TRV|ILL                    SAVE_TOKEN; return LITERAL_DECOR;
#(\+|\*|-|\/)                          SAVE_TOKEN; return OPERATOR_INTERVAL;
#([A-Z][a-z]*)+                        SAVE_TOKEN; return COMPARE_INTERVAL;
(\+|\*|-|\/)(Next|N|Down|D|Up|U)       SAVE_TOKEN; return OPERATOR_FLOAT;
==|!=|<|<=|>|>=                        SAVE_TOKEN; return COMPARE_FLOAT;
#undecor                               return DECOR_UN;
#getdecor                              return DECOR_GET;
#decor                                 return DECOR_SET;
#(inf|sup)                             SAVE_TOKEN; return QUERY_INTERVAL;
=                                      return ASSIGNMENT;
if                                     return IF;
else                                   return ELSE;
::                                     return OPERATOR_TYPE;
:                                      return CONSTRUCTOR_INTERVAL;
[a-zA-Z_][a-zA-Z0-9_]*                 SAVE_TOKEN; return IDENTIFIER;
.                                      ;
%%
int main(int argc, char** argv)
{
  yylex();
}

