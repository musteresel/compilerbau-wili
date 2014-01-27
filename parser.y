%{
#include "ast.hpp"
#include <string>
#include <list>
#include <memory>

extern int yylex();
void yyerror(const char * s) { std::cout << "//Error// " << s << std::endl; }

%}

%union {
  ast::expr * expr;
  ast::bool_expr * bool_expr;
  ast::num_expr * num_expr;
  ast::decor_expr * decor_expr;
  ast::ival_expr * ival_expr;
  std::list<std::unique_ptr<ast::expr const>> * expr_seq;
  std::string * string;
  int token;
}

%type <expr_seq> expr_seq

%type <expr> expr
%type <bool_expr> bool_expr bool_literal bool_termseq
%type <num_expr> num_expr num_literal num_termseq
%type <decor_expr> decor_expr decor_literal decor_termseq
%type <ival_expr> ival_expr ival_termseq

%type <token> num_compare num_addsub num_muldiv ival_compare
%type <token> ival_addsub ival_muldiv ival_bound bool_andor

/* Terminal string tokens
 * - T_IDENT: A string containing an identifier.
 * - T_NUMERIC: A string with a floating point value.
 * - T_DECOR: A string with one of the decor type values.
 * - T_TYPE: A string with one type identifier.
*/
%token <string> T_IDENTIFIER T_FLOAT T_DECOR T_TYPE T_TRUE T_FALSE


/* Terminal utility tokens
 * - LPAR == (
 * - RPAR == )
 * - LBRA == {
 * - RBRA == }
 * - IF   == if
 * - ELSE == else
 * - LSEP == ;
*/
%token <token> T_LPAR T_RPAR T_LBRA T_RBRA T_IF T_THEN T_ELSE T_LSEP


/* Terminal assignment token
*/
%right <token> T_ASSIGN

%nonassoc CONDITIONAL

/* Interval comparision operators
 * - EQ == equal
 * - NE == not equal
 * - SI == subinterval
 * - SS == strict subinterval
 * - WI == wrapper interval
 * - SW == strict wrapper interval
 * - LT == (any) less than
 * - LE == (any) less or equal
 * - GT == (any) greater than
 * - GE == (any) greater or equal
 * - ALT == all less than
 * - ALE == all less or equal
 * - AGT == all greater than
 * - AGE == all greater or equal
*/
%left <token> T_IEQ T_INE T_ISI T_ISS T_IWI T_ISW
%left <token> T_ILT T_ILE T_IGT T_IGE T_IALT T_IALE T_IAGT T_IAGE


/* Floating point comparision operators
 * - EQ == equal
 * - NE == not equal
 * - LT == less than
 * - LE == less or equal
 * - GT == greater than
 * - GE == greater or equal
*/
%left <token> T_FEQ T_FNE T_FGT T_FGE T_FLT T_FLE


/* Interval arithmetic operators
 * - A == add
 * - S == subtract
 * - M == multiply
 * - D == divide
*/
%left <token> T_IA T_IS IVAL_ADDSUB
%left <token> T_IM T_ID IVAL_MULDIV


/* Interval construction is non associative
*/
%nonassoc <token> T_ICONSTRUCT


/** Floating point arithmetic operators with rounding setting
 * - A? == add
 * - S? == subtract
 * - M? == multiply
 * - D? == divide
 * - ?N == round to next number
 * - ?D == round to next lower number (down)
 * - ?U == round to next higher number (up)
*/
%left <token> T_FAN T_FAD T_FAU T_FSN T_FSD T_FSU NUM_ADDSUB
%left <token> T_FMN T_FMD T_FMU T_FDN T_FDD T_FDU NUM_MULDIV


/* Interval bound query operators are non associative
*/
%nonassoc <token> T_IUB T_ILB IVAL_BOUND


/* Decoration operators
*/
%nonassoc <token> T_IDE T_IUD T_IGD


%left <token> T_AND T_OR BOOL_ANDOR
%right <token> T_NOT

%left <token> T_BOOL_CALL T_NUM_CALL T_DECOR_CALL T_IVAL_CALL


%start expr
%%



expr : bool_expr
     | num_expr
     | ival_expr
     | decor_expr
;


bool_expr :
            num_expr num_compare num_expr
{ $$ = ast::create<ast::num_compare>($2,$1,$3); }
          | ival_expr ival_compare ival_expr
{ $$ = ast::create<ast::ival_compare>($2,$1,$3); }
          | bool_expr bool_andor bool_expr %prec BOOL_ANDOR
{ $$ = ast::create<ast::bool_binary>($2,$1,$3); }
          | T_NOT bool_expr
          | T_IF bool_expr T_THEN bool_expr T_ELSE bool_expr %prec CONDITIONAL
{ $$ = ast::create<ast::bool_conditional>($2, $4, $6); }
          | T_LPAR bool_expr T_RPAR
{ $$ = $2; }
          | T_LBRA bool_termseq T_RBRA
{ $$ = $2; }
          | bool_literal
          | T_IDENTIFIER T_ASSIGN bool_expr
{ std::cout << "bool ident " << $1 << " assigned!" << std::endl; }
;


num_expr :
          num_expr num_addsub num_expr %prec NUM_ADDSUB
{ $$ = ast::create<ast::num_binary>($2,$1,$3); }
         | num_expr num_muldiv num_expr %prec NUM_MULDIV
{ $$ = ast::create<ast::num_binary>($2,$1,$3); }
         | ival_bound ival_expr %prec IVAL_BOUND
         | T_IF bool_expr T_THEN num_expr T_ELSE num_expr %prec CONDITIONAL
{ $$ = ast::create<ast::num_conditional>($2,$4,$6); }
         | T_LPAR num_expr T_RPAR
{ $$ = $2; }
         | T_LBRA num_termseq T_RBRA
{ $$ = $2; }
         | num_literal
          | T_IDENTIFIER  T_ASSIGN num_expr
{ std::cout << "num ident " << $1 << " assigned!" << std::endl; }
;


decor_expr : T_IGD ival_expr
           | T_IF bool_expr T_THEN decor_expr T_ELSE decor_expr
{ $$ = ast::create<ast::decor_conditional>($2,$4,$6); }
           | T_LPAR decor_expr T_RPAR
{ $$ = $2; }
           | T_LBRA decor_termseq T_RBRA
{ $$ = $2; }
           | decor_literal
;


ival_expr :
            ival_expr ival_addsub ival_expr %prec IVAL_ADDSUB
{ $$ = ast::create<ast::ival_binary>($2,$1,$3); }
          | ival_expr ival_muldiv ival_expr %prec IVAL_MULDIV
{ $$ = ast::create<ast::ival_binary>($2,$1,$3); }
          | num_expr T_ICONSTRUCT num_expr
          | T_ICONSTRUCT num_expr
          | decor_expr T_IDE ival_expr
          | T_IUD ival_expr
          | T_IF bool_expr T_THEN ival_expr T_ELSE ival_expr %prec CONDITIONAL
{ $$ = ast::create<ast::ival_conditional>($2,$4,$6); }
          | T_LPAR ival_expr T_RPAR
{ $$ = $2; }
          | T_LBRA ival_termseq T_RBRA
{ $$ = $2; }
;


bool_termseq :
             expr_seq bool_expr
{ $$ = ast::create<ast::bool_termseq>($1,$2); }
;


num_termseq :
            expr_seq num_expr
{ $$ = ast::create<ast::num_termseq>($1,$2); }
;


decor_termseq :
              expr_seq decor_expr
{ $$ = ast::create<ast::decor_termseq>($1,$2); }
;


ival_termseq :
             expr_seq ival_expr
{ $$ = ast::create<ast::ival_termseq>($1,$2); }
;


expr_seq :
         /* empty */
{ $$ = new std::list<std::unique_ptr<ast::expr const>>(); }
         | expr_seq expr T_LSEP
{ $$ = $1; $$->push_back(std::unique_ptr<ast::expr const>($2)); }
;


num_compare : T_FEQ | T_FNE | T_FLT | T_FLE | T_FGT | T_FGE
;


num_addsub : T_FAN | T_FAD | T_FAU
           | T_FSN | T_FSD | T_FSU
;


num_muldiv : T_FMN | T_FMD | T_FMU
           | T_FDN | T_FDD | T_FDU
;


ival_compare : T_IEQ | T_INE | T_ISI | T_ISS | T_IWI | T_ISW 
             | T_ILT | T_ILE | T_IGT | T_IGE 
             | T_IALT | T_IALE | T_IAGT | T_IAGE
;


ival_addsub : T_IA | T_IS
;


ival_muldiv : T_IM | T_ID
;


ival_bound : T_IUB | T_ILB
;


bool_andor : T_AND | T_OR
;


bool_literal :
             T_TRUE
{ $$ = ast::create<ast::bool_literal>(true); }
             | T_FALSE
{ $$ = ast::create<ast::bool_literal>(false); }
;


num_literal :
            T_FLOAT
{ $$ = ast::create<ast::num_literal>($1); }
;


decor_literal :
              T_DECOR
{ $$ = ast::create<ast::decor_literal>($1); }
;



%%
/* empty */


