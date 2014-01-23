%{
#include "node.hpp"
extern int yylex();
void yyerror(const char * s);
%}

%union {
  Expr * expression;
  Identifier * identifier;
  std::string * string;
  int token;
}


/* Terminal string tokens
 * - T_IDENT: A string containing an identifier.
 * - T_NUMERIC: A string with a floating point value.
 * - T_DECOR: A string with one of the decor type values.
 * - T_TYPE: A string with one type identifier.
*/
%token <string> T_IDENT T_NUMERIC T_DECOR T_TYPE


/* Terminal utility tokens
 * - LPAR == (
 * - RPAR == )
 * - LBRA == {
 * - RBRA == }
*/
%token <token> T_LPAR T_RPAR T_LBRA T_RBRA


/* Terminal assignment token
*/
%right <token> T_ASSIGN


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
%left <token> T_IA T_IS
%left <token> T_IM T_ID


/** Floating point arithmetic operators with rounding setting
 * - A? == add
 * - S? == subtract
 * - M? == multiply
 * - D? == divide
 * - ?N == round to next number
 * - ?D == round to next lower number (down)
 * - ?U == round to next higher number (up)
*/
%left <token> T_FAN T_FAD T_FAU T_FSN T_FSD T_FSU
%left <token> T_FMN T_FMD T_FMU T_FDN T_FDD T_FDU
%%
/* --- Terminal values --- ---------------------------------------------------*/
/* Grammar rule to match an identifier */
b_ident : T_IDENT { $$ = new Identifier($1); }
				;
/* Rule to match a numeric (float) value */
b_numeric : T_NUMERIC { $$ = new Numeric($1); }
					;
/* Rule to match a decor value */
b_decor : T_DECOR { $$ = new Decor($1); }
				;

b_operation : b_expr b_binary_operator b_expr { $$ = new Operation($1,$2,$3); }

b_iconstruct : b_expr T_ICONSTRUCT b_expr { $$ = new Interval($1, $3);    }
						 |        T_ICONSTRUCT b_expr { $$ = new Interval(false, $2); }
             | b_expr T_ICONSTRUCT        { $$ = new Interval($1, false); }
						 ;
b_assign : b_ident '::' b_ident '=' b_expr { $$ = new Assignment($1,$2,$3); }
				 ;
b_if : 'if' '(' b_expr ')' b_expr 'else' b_expr { $$ = new If($3,$5,$7); }
		 ;

b_block : '{' b_expr_list '}' { $$ = $2; }
				;
b_expr_list : b_expr { $$ = new Block($1); }
						| b_expr_list ';' b_expr { $1->expressions.addLast($3); }
            ;

b_expr : b_ident { $$ = $1; }
			 | b_numeric { $$ = $1; }
       | b_iconstruct { $$ = $1; }
       | b_assign { $$ = $1; }
       | b_if { $$ = $1; }
       | b_block { $$ = $1; }
       | '(' b_expr ')' { $$ = $2; }

%%

