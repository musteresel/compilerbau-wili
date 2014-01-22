%{
#include <iostream>
#include <string>
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng); std::cout << "Found: " << *yylval.string << std::endl;

union
{
  std::string* string;
  int integer;
}
yylval;

#define YY_DECL extern "C" int yylex()
%}

%%
[ \t\n]                                ;
[+-]?(([0-9]*(\.[0-9]+)?)|infinite)    SAVE_TOKEN;// return LITERAL_FLOAT;
COM|DAC|DEF|TRV|ILL                    SAVE_TOKEN;// return LITERAL_DECOR;
#(\+|\*|-|\/)                          SAVE_TOKEN;// return OPERATOR_INTERVAL;
#([A-Z][a-z]*)+                        SAVE_TOKEN;// return COMPARE_INTERVAL;
(\+|\*|-|\/)(Next|N|Down|D|Up|U)       SAVE_TOKEN;// return OPERATOR_FLOAT;
==|!=|<|<=|>|>=                        SAVE_TOKEN;// return COMPARE_FLOAT;
#undecor                               SAVE_TOKEN;//return DECOR_UN;
#getdecor                              SAVE_TOKEN;//return DECOR_GET;
#decor                                 SAVE_TOKEN;//return DECOR_SET;
:                                      SAVE_TOKEN;//return CONSTRUCTOR_INTERVAL;
#(inf|sup)                             SAVE_TOKEN;// return QUERY_INTERVAL;

%%

int main(int argc, char** argv)
{
  yylex();
}

