%{
#include "ast.hpp"
extern int yylex();
void yyerror(const char * s) { std::cout << "//Error// " << s << std::endl; }

Block * program_block;
%}

%union {
  Expr * expression;
  Identifier * identifier;
  TypeIdentifier * typeidentifier;
  Block * block;
  UnaryOperation * uop;
  BinaryOperation * bop;
  Call * call;
  Conditional * conditional;
  Declaration * declaration;
  Numeric * numeric;
  Decor * decor;
  std::string * string;
  int token;
}


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

%start expr
%%



expr : bool_expr
		 | num_expr
     | ival_expr
     | decor_expr
;


bool_expr : num_expr num_compare num_expr
					| ival_expr ival_compare ival_expr
          | bool_expr bool_andor bool_expr %prec BOOL_ANDOR
          | T_NOT bool_expr
          | T_IF bool_expr T_THEN bool_expr T_ELSE bool_expr %prec CONDITIONAL
          | T_LPAR bool_expr T_RPAR
          | T_LBRA bool_termseq T_RBRA
          | bool_literal
;


num_expr : num_expr num_addsub num_expr %prec NUM_ADDSUB
				 | num_expr num_muldiv num_expr %prec NUM_MULDIV
         | ival_bound ival_expr %prec IVAL_BOUND
         | T_IF bool_expr T_THEN num_expr T_ELSE num_expr %prec CONDITIONAL
         | T_LPAR num_expr T_RPAR
         | T_LBRA num_termseq T_RBRA
         | num_literal
;


decor_expr : T_IGD ival_expr
					 | T_IF bool_expr T_THEN decor_expr T_ELSE decor_expr
           | T_LPAR decor_expr T_RPAR
           | T_LBRA decor_termseq T_RBRA
					 | decor_literal
;


ival_expr : ival_expr ival_addsub ival_expr %prec IVAL_ADDSUB
					| ival_expr ival_muldiv ival_expr %prec IVAL_MULDIV
          | num_expr T_ICONSTRUCT num_expr
          | T_ICONSTRUCT num_expr
          | decor_expr T_IDE ival_expr
          | T_IUD ival_expr
          | T_IF bool_expr T_THEN ival_expr T_ELSE ival_expr %prec CONDITIONAL
          | T_LPAR ival_expr T_RPAR
          | T_LBRA ival_termseq T_RBRA
;


bool_termseq : expr_seq bool_expr
;


num_termseq : expr_seq num_expr
;


decor_termseq : expr_seq decor_expr
;


ival_termseq : expr_seq ival_expr
;


expr_seq : /* empty */
				 | expr_seq expr T_LSEP
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


bool_literal : T_TRUE | T_FALSE
;


num_literal : T_FLOAT
;


decor_literal : T_DECOR
;


%%
/* empty */


