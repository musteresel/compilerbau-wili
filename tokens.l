%{
#include <iostream>
#include <string>
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN_TERMINAL(ret) { \
  yylval.token = ret; \
  return ret; \
  }
#define STRING_TERMINAL(ret) { \
	yylval.string = new std::string(yytext, yyleng); \
  return ret; \
  }
#define YY_DECL extern "C" int yylex()
int linenum = 1;
%}
%%
[ \t]                                  ;
\n                                     ++linenum;

><                                     TOKEN_TERMINAL(T_ICONSTRUCT);

\+(?i:n(e(xt?)?)?)                     TOKEN_TERMINAL(T_FAN);
\+(?i:d(o(wn?)?)?)                     TOKEN_TERMINAL(T_FAD);
\+(?i:up?)                             TOKEN_TERMINAL(T_FAU);
-(?i:n(e(xt?)?)?)                      TOKEN_TERMINAL(T_FSN);
-(?i:d(o(wn?)?)?)                      TOKEN_TERMINAL(T_FSD);
-(?i:up?)                              TOKEN_TERMINAL(T_FSU);
\*(?i:n(e(xt?)?)?)                     TOKEN_TERMINAL(T_FMN);
\*(?i:d(o(wn?)?)?)                     TOKEN_TERMINAL(T_FMD);
\*(?i:up?)                             TOKEN_TERMINAL(T_FMU);
\/(?i:n(e(xt?)?)?)                     TOKEN_TERMINAL(T_FDN);
\/(?i:d(o(wn?)?)?)                     TOKEN_TERMINAL(T_FDD);
\/(?i:up?)                             TOKEN_TERMINAL(T_FDU);

==                                     TOKEN_TERMINAL(T_FEQ);
!=                                     TOKEN_TERMINAL(T_FNE);
<                                      TOKEN_TERMINAL(T_FLT);
<=                                     TOKEN_TERMINAL(T_FLE);
>                                      TOKEN_TERMINAL(T_FGT);
>=                                     TOKEN_TERMINAL(T_FGE);

#\+                                    TOKEN_TERMINAL(T_IA);
#-                                     TOKEN_TERMINAL(T_IS);
#\*                                    TOKEN_TERMINAL(T_IM);
#\/                                    TOKEN_TERMINAL(T_ID);

#(?i:e(q(u(al?)?)?)?)                  TOKEN_TERMINAL(T_IEQ);
#(?i:n(ot?)?(e(q(u(al?)?)?)?)?)           TOKEN_TERMINAL(T_INE);

#(?i:s(ub?)?(i(n(t(e(r(v(al?)?)?)?)?)?)?)?) TOKEN_TERMINAL(T_ISI);
#(?i:s(t(r(i(ct?)?)?)?)?s(ub?)?(i(n(t(e(r(v(al?)?)?)?)?)?)?)?) TOKEN_TERMINAL(T_ISS);
#(?i:w(r(a(p(p(er?)?)?)?)?)?(i(n(t(e(r(v(al?)?)?)?)?)?)?)?) TOKEN_TERMINAL(T_IWI);
#(?i:s(t(r(i(ct?)?)?)?)?w(r(a(p(p(er?)?)?)?)?)?(i(n(t(e(r(v(al?)?)?)?)?)?)?)?) TOKEN_TERMINAL(T_ISW);

#(?i:l(e(ss?)?)?(t(h(an?)?)?)?)           TOKEN_TERMINAL(T_ILT);
#(?i:l(e(s(s(or?)?)?)?)?e(q(u(al?)?)?)?) TOKEN_TERMINAL(T_ILE);
#(?i:g(r(e(a(t(er?)?)?)?)?)?(t(h(an?)?)?)?) TOKEN_TERMINAL(T_IGT);
#(?i:g(r(e(a(t(e(r(or?)?)?)?)?)?)?)?e(q(u(al?)?)?)?) TOKEN_TERMINAL(T_IGE);

#(?i:a(ll?)?l(e(ss?)?)?(t(h(an?)?)?)?)           TOKEN_TERMINAL(T_IALT);
#(?i:a(ll?)?l(e(s(s(or?)?)?)?)?e(q(u(al?)?)?)?) TOKEN_TERMINAL(T_IALE);
#(?i:a(ll?)?g(r(e(a(t(er?)?)?)?)?)?(t(h(an?)?)?)?) TOKEN_TERMINAL(T_IAGT);
#(?i:a(ll?)?g(r(e(a(t(e(r(or?)?)?)?)?)?)?)?e(q(u(al?)?)?)?) TOKEN_TERMINAL(T_IAGE);

#(?i:d(e(c(or?)?)?)?)                  TOKEN_TERMINAL(T_IDE);
#(?i:un?d(e(c(or?)?)?)?)               TOKEN_TERMINAL(T_IUD);
#(?i:g(et?)?d(e(c(or?)?)?)?)           TOKEN_TERMINAL(T_IGD);

#(?i:u(p(p(er?)?)?)?b(o(u(nd?)?)?)?)   TOKEN_TERMINAL(T_IBOUNDU);
#(?i:l(o(w(er?)?)?)?b(o(u(nd?)?)?)?)   TOKEN_TERMINAL(T_IBOUNDL);

=                                      TOKEN_TERMINAL(T_ASSIGN);
if                                     TOKEN_TERMINAL(T_IF);
else                                   TOKEN_TERMINAL(T_ELSE);

::(Decor|Float|(Decor)?Ival|Bool)      STRING_TERMINAL(T_TYPE);
COM|DAC|DEF|TRV|ILL                    STRING_TERMINAL(T_DECOR);
[+-]?(([0-9]*(\.[0-9]+)?([eE][+-]?[0-9]+)?)|infinite) STRING_TERMINAL(T_NUMERIC);
[a-zA-Z_][a-zA-Z0-9_]*                 STRING_TERMINAL(T_IDENTIFIER);


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

