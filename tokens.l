%{
#include <iostream>
#include <string>
#include "node.hpp"
#include "parser.hpp"

#define TOKEN_TERMINAL(ret) { \
  if (flex_debug) std::cout << "Found token " #ret << std::endl; \
  yylval.token = ret; \
  return ret; \
  }
#define STRING_TERMINAL(ret) { \
	yylval.string = new std::string(yytext, yyleng); \
  if (flex_debug) std::cout << "Found terminal \"" << yylval.string << "\"" << std::endl; \
  return ret; \
  }
extern "C" int yywrap() { }

int linenum = 1;
char flex_debug = 0;
%}
%%
[ \t]                                  ;
\n                                     ++linenum;

;                                      TOKEN_TERMINAL(T_LSEP);

><                                     TOKEN_TERMINAL(T_ICONSTRUCT);

\+(?i:n(ext)?)                         TOKEN_TERMINAL(T_FAN);
\+(?i:d(own)?)                         TOKEN_TERMINAL(T_FAD);
\+(?i:up?)                             TOKEN_TERMINAL(T_FAU);
-(?i:n(ext)?)                          TOKEN_TERMINAL(T_FSN);
-(?i:d(own)?)                          TOKEN_TERMINAL(T_FSD);
-(?i:up?)                              TOKEN_TERMINAL(T_FSU);
\*(?i:n(ext)?)                         TOKEN_TERMINAL(T_FMN);
\*(?i:d(own)?)                         TOKEN_TERMINAL(T_FMD);
\*(?i:up?)                             TOKEN_TERMINAL(T_FMU);
\/(?i:n(ext)?)                         TOKEN_TERMINAL(T_FDN);
\/(?i:d(own)?)                         TOKEN_TERMINAL(T_FDD);
\/(?i:up?)                             TOKEN_TERMINAL(T_FDU);

==                                     TOKEN_TERMINAL(T_FEQ);
!=                                     TOKEN_TERMINAL(T_FNE);
\<                                      TOKEN_TERMINAL(T_FLT);
\<=                                     TOKEN_TERMINAL(T_FLE);
>                                      TOKEN_TERMINAL(T_FGT);
>=                                     TOKEN_TERMINAL(T_FGE);

#\+                                    TOKEN_TERMINAL(T_IA);
#-                                     TOKEN_TERMINAL(T_IS);
#\*                                    TOKEN_TERMINAL(T_IM);
#\/                                    TOKEN_TERMINAL(T_ID);


#(?i:e(q(ual)?)?)                      TOKEN_TERMINAL(T_IEQ);
#(?i:n(ot)?(e(q(ual)?)?)?)             TOKEN_TERMINAL(T_INE);

#(?i:s(ub)?(i(nterval)?)?)             TOKEN_TERMINAL(T_ISI);
#(?i:s(trict)?s(ub)?(i(nterval)?)?)    TOKEN_TERMINAL(T_ISS);
#(?i:w(rapper)?(i(nterval)?)?)         TOKEN_TERMINAL(T_IWI);
#(?i:s(trict)?w(rapper)?(i(nterval)?)?) TOKEN_TERMINAL(T_ISW);

#(?i:l(ess)?(t(han)?)?)                TOKEN_TERMINAL(T_ILT);
#(?i:l(ess)?(or?)?e(q(ual)?)?)         TOKEN_TERMINAL(T_ILE);
#(?i:g(reater)?(t(han)?)?)             TOKEN_TERMINAL(T_IGT);
#(?i:g(reater)?(or?)?e(q(ual)?)?)      TOKEN_TERMINAL(T_IGE);

#(?i:a(ll)?l(ess)?(t(han)?)?)          TOKEN_TERMINAL(T_IALT);
#(?i:a(ll)?l(ess)?(or?)?e(q(ual)?)?)   TOKEN_TERMINAL(T_IALE);
#(?i:a(ll)?g(reater)?(t(han)?)?)       TOKEN_TERMINAL(T_IAGT);
#(?i:a(ll)?g(reater)?(or?)?e(q(ual)?)?) TOKEN_TERMINAL(T_IAGE);

#(?i:d(ecor(ate)?)?)                   TOKEN_TERMINAL(T_IDE);
#(?i:un?d(ecor(ate)?)?)                TOKEN_TERMINAL(T_IUD);
#(?i:g(et)?d(ecor(ation)?)?)           TOKEN_TERMINAL(T_IGD);

#(?i:u(pper)?b(ound)?)                 TOKEN_TERMINAL(T_IUB);
#(?i:l(ower)?b(ound)?)                 TOKEN_TERMINAL(T_ILB);

=                                      TOKEN_TERMINAL(T_ASSIGN);
if                                     TOKEN_TERMINAL(T_IF);
then                                   TOKEN_TERMINAL(T_THEN);
else                                   TOKEN_TERMINAL(T_ELSE);

and                                    TOKEN_TERMINAL(T_AND);
or                                     TOKEN_TERMINAL(T_OR);
not                                    TOKEN_TERMINAL(T_NOT);

::(Decor|Float|(Decor)?Ival|Bool)      STRING_TERMINAL(T_TYPE);
COM|DAC|DEF|TRV|ILL                    STRING_TERMINAL(T_DECOR);
[+-]?(([0-9]*(\.[0-9]+)?([eE][+-]?[0-9]+)?)|infinite) STRING_TERMINAL(T_FLOAT);
[a-zA-Z_][a-zA-Z0-9_]*                 STRING_TERMINAL(T_IDENTIFIER);

.                                      ;
%%
/*int main(int argc, char** argv)
{
  yylex();
}*/

