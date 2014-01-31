%{
#include "ast.hpp"
#include <string>
#include <list>
#include <memory>

extern int yylex();
void yyerror(const char * s) { std::cout << "//Error// " << s << std::endl; }

ast::module * program;

%}

%union {
  ast::module * module;
  ast::expr * expr;
  std::list<ast::expr_ptr> * expr_list;
  std::string * string;
  int token;
}




%nonassoc <token> P_UNUSED T_TYPE

%type <module> module
%type <expr> expr
%type <expr_list> expr_list
%type <token> op_andor op_eqne op_compare op_ival_addsub op_ival_muldiv
%type <token> op_num_addsub op_num_muldiv op_bounds op_num_unary


%token <string> T_FLOAT T_DECOR
%token T_TRUE T_FALSE
%right <token> P_ASSIGNMENT T_DECLARE T_ASSIGN T_MODULE
%token <string> P_DECLARE T_IDENTIFIER
%token <token> P_BLOCK T_LBRA T_RBRA T_BSEP
%token <token> P_CONDITIONAL T_IF T_THEN T_ELSE T_FI
%left <token> P_BINARY_BOOL T_AND T_OR
%right <token> P_UNARY_BOOL T_NOT
%left <token> P_EQUALITY T_IEQ T_INE T_FEQ T_FNE
%nonassoc <token> P_COMPARE T_FLT T_FLE T_FGT T_FGE T_ILT T_ILE T_IGT T_IGE T_IALT T_IALE T_IAGT T_IAGE T_ISI T_ISS T_IWI T_ISW
%left <token> P_IVAL_ADDSUB T_IA T_IS
%left <token> P_IVAL_MULDIV T_IM T_ID
%nonassoc P_IVAL_UNARY
%nonassoc <token> P_DECORATE T_IDE
%nonassoc <token> P_DECOR_GET T_IGD
%nonassoc <token> P_BOUNDS T_IUB T_ILB
%nonassoc <token> P_DECOR_REMOVE T_IUD
%nonassoc <token> P_IVAL_CONSTRUCT T_ICONSTRUCT
%nonassoc <token> P_IVAL_CONSTRUCT_UNARY T_ICONSTRUCT_UNARY
%left <token> P_NUM_ADDSUB T_FAN T_FAD T_FAU T_FSN T_FSD T_FSU
%left <token> P_NUM_MULDIV T_FMN T_FMD T_FMU T_FDN T_FDD T_FDU
%token <string> P_CALL T_CALL
%nonassoc P_NUM_UNARY
%nonassoc P_GROUP T_LPAR T_RPAR

%start module

%%
module :
T_MODULE {ast::begin_declaration();}
T_IDENTIFIER T_ASSIGN {ast::end_declaration();} expr
{$$ = ast::create<ast::module>($3,$6); program = $$;}
;

expr :
/* Declaration of a function or variable */
T_DECLARE {ast::begin_declaration();} 
T_IDENTIFIER T_ASSIGN {ast::end_declaration();} expr
{$$ = ast::create<ast::declaration>($3,$6);}

|
/* Block with an expression list */
T_LBRA expr_list T_RBRA
{$$ = ast::create<ast::block>($2);}

|
/* Conditional evaluation */
T_IF expr T_THEN expr T_ELSE expr T_FI
{$$ = ast::create<ast::conditional>($2,$4,$6);}

|
/* Boolean binary operation */
expr op_andor expr %prec P_BINARY_BOOL
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Boolean negation operation */
T_NOT expr
{$$ = ast::create<ast::unary>($1,$2);}

|
/* (Un)Equality operations */
expr op_eqne expr %prec P_EQUALITY
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Compare operations */
expr op_compare expr %prec P_COMPARE
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Interval addition and subtraction */
expr op_ival_addsub expr %prec P_IVAL_ADDSUB
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Interval multiplication and division */
expr op_ival_muldiv expr %prec P_IVAL_MULDIV
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Interval decoration operation */
expr T_IDE expr
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Extract / get decoration from a given interval */
T_IGD expr
{$$ = ast::create<ast::unary>($1,$2);}

|
/* Get upper or lower bound of interval */
op_bounds expr %prec P_BOUNDS
{$$ = ast::create<ast::unary>($1,$2);}

|
/* Remove decoration from interval */
T_IUD expr
{$$ = ast::create<ast::unary>($1,$2);}

|
/* Unary negation of an interval */
T_IS expr %prec P_IVAL_UNARY
{$$ = ast::create<ast::unary>($1,$2);}

|
/* Construction of an interval */
expr T_ICONSTRUCT expr
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Unary construction of an interval */
T_ICONSTRUCT expr %prec P_IVAL_CONSTRUCT_UNARY
{$$ = ast::create<ast::unary>($1,$2);}

|
/* Addition and subtraction of numbers */
expr op_num_addsub expr %prec P_NUM_ADDSUB
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Multiplication and division of numbers */
expr op_num_muldiv expr %prec P_NUM_MULDIV
{$$ = ast::create<ast::binary>($2,$1,$3);}

|
/* Call of a previously declared function / variable */
T_CALL
{$$ = ast::create<ast::call>($1);}

|
/* Unary operation (negation) of numbers */
op_num_unary expr %prec P_NUM_UNARY
{$$ = ast::create<ast::unary>($1,$2);}

|
/* Grouping of an expression */
T_LPAR expr T_RPAR
{$$ = ast::create<ast::group>($2);}

|
/* Float (number) literal */
T_FLOAT
{$$ = ast::create<ast::numeric>($1);}

|
/* Decoration literal */
T_DECOR
{$$ = ast::create<ast::decor>($1);}

|
/* Boolean true literal */
T_TRUE
{$$ = ast::create<ast::boolean>(true);}

|
/* Boolean false literal */
T_FALSE
{$$ = ast::create<ast::boolean>(false);}
;



expr_list :
/* Single expression can be considered as list */
expr
{$$ = new std::list<ast::expr_ptr>();
 $$->push_back(ast::expr_ptr($1));
}

|
/* Another expression in the list */
expr_list T_BSEP expr
{$$ = $1;
 $$->push_back(ast::expr_ptr($3));
}
;




op_andor : T_AND | T_OR;
op_eqne : T_FEQ | T_FNE | T_IEQ | T_INE;
op_compare : T_FLT | T_FLE | T_FGT | T_FGE 
           | T_ILT | T_ILE | T_IGT | T_IGE | T_IALT | T_IALE | T_IAGT | T_IAGE
           | T_ISI | T_ISS | T_IWI | T_ISW;
op_ival_addsub : T_IA | T_IS;
op_ival_muldiv : T_IM | T_ID;
op_bounds : T_IUB | T_ILB;
op_num_addsub : T_FAN | T_FAD | T_FAU | T_FSN | T_FSD | T_FSU;
op_num_muldiv : T_FMN | T_FMD | T_FMU | T_FDN | T_FDD | T_FDU;
op_num_unary : T_FSN | T_FSD | T_FSU;




%%
/* empty */

