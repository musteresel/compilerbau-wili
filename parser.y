%{
#include "node.hpp"
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

%type <token> unary_operator binary_operator
%type <expression> expression subexpression operation
%type <block> program block expression_list
%type <identifier> identifier
%type <typeidentifier> type
%type <numeric> numeric
%type <decor> decor
%type <uop> unary_operation
%type <bop> binary_operation
%type <call> call
%type <declaration> declaration
%type <conditional> conditional



/* Terminal string tokens
 * - T_IDENT: A string containing an identifier.
 * - T_NUMERIC: A string with a floating point value.
 * - T_DECOR: A string with one of the decor type values.
 * - T_TYPE: A string with one type identifier.
*/
%token <string> T_IDENTIFIER T_FLOAT T_DECOR T_TYPE


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
%left <token> T_FAN T_FAD T_FAU T_FSN T_FSD T_FSU
%left <token> T_FMN T_FMD T_FMU T_FDN T_FDD T_FDU


/* Interval bound query operators are non associative
*/
%nonassoc <token> T_IUB T_ILB


/* Decoration operators
*/
%nonassoc <token> T_IDE T_IUD T_IGD

%start program
%%
program : expression_list
        { program_block = $1; }
        ;



/*
level00 : T_LBRA level01 T_RBRA 
          { $$ = $2; }
        ;
level01 : level02 
          { $$ = new Block(); $$->add_expression($1); }
        | level01 T_LSEP level02 
          { $1->add_expression($1); }
        ;
level02 : identifier T_TYPED type T_ASSIGN level03
          { $$ = new Declaration($3,$1,$5); }
        | level03
        ;
level03 : T_IF level03 T_THEN level03 T_ELSE level03
          { $$ = new Conditional($2,$4,$6); }
        | level04
        ;
level04 : level04 binary_bool level05
          { $$ = new BinaryOperator($2,$1,$3); }
        | level05
        ;
level05 : unary_bool level06
          { $$ = new UnaryOperator($1,$2); }
        | level06
        ;
level06 : level06 compare level07
          { $$ = new BinaryOperator($2,$1,$3); }
        | level07
        ;
level07 : level07 T_IA level08





lvl0 : block | expression_list | lvl1;
lvl1 : assignment | lvl2;



/* Assignments */
lvl0 : identifier type T_ASSIGN lvl1
     { $$ = new Declaration($2,$1,$4); }
     | lvl1
     ;

/* Compare operations */
lvl1 : lvl1 lvl1_binary lvl2
     { $$ = new BinaryOperation($2,$1,$3); }
     | lvl2
     ;
lvl1_binary : T_IEQ | T_INE | T_ISI | T_ISS | T_IWI | T_ISW 
            | T_ILT | T_ILE | T_IGT | T_IGE 
            | T_IALT | T_IALE | T_IAGT | T_IAGE
            | T_FEQ | T_FNE | T_FGT | T_FGE | T_FLT | T_FLE
            ;

/* Binary interval arithmetic */
lvl2 : lvl2 lvl2_binary lvl3
     { $$ = new BinaryOperation($2,$1,$3); }
     | lvl3
     ;
lvl2_binary : T_IA | T_IS | T_IM | T_ID
            ;

/* Unary interval arithmetic */
lvl3 : T_IS lvl3
     { $$ = new UnaryOperation($1,$2); }
     ;

/* 
lvl3 : lvl3 T_ICONSTRUCT lvl4
     { $$ = new BinaryOperation($2,$1,$3); }
     | lvl4







/* --- Terminal values --- ---------------------------------------------------*/
/* Grammar rule to match an identifier
*/
identifier : T_IDENTIFIER
           { $$ = new Identifier($1); }
           ;


/* Rule to match a numeric (float) value
*/
numeric : T_FLOAT
        { $$ = new Numeric($1); }
        ;


/* Rule to match a decor value
*/
decor : T_DECOR
      { $$ = new Decor($1); }
      ;

/* Rule to match a type identifier
*/
type : T_TYPE
     { $$ = new TypeIdentifier($1); }
     ;


/* --- Operators --- ---------------------------------------------------------*/
unary_operator : T_IUB | T_ILB | T_IUD | T_IGD | T_ICONSTRUCT
               ;


binary_operator : T_FAN | T_FAD | T_FAU
                | T_FSN | T_FSD | T_FSU
                | T_FMN | T_FMD | T_FMU
                | T_FDN | T_FDD | T_FDU
                | T_ICONSTRUCT
                | T_FEQ | T_FNE | T_FLT | T_FLE | T_FGT | T_FGE
                | T_IA | T_IS | T_IM | T_ID
                | T_IEQ | T_INE
                | T_ISI | T_ISS | T_IWI | T_ISW
                | T_ILT | T_ILE | T_IGT | T_IGE
                | T_IALT | T_IALE | T_IAGT | T_IAGE
                ;


/* --- Operations --- --------------------------------------------------------*/
unary_operation : unary_operator expression
                { $$ = new UnaryOperation($1,$2); }
                ;


binary_operation : expression binary_operator expression
                 { $$ = new BinaryOperation($2,$1,$3); }
                 ;


operation : unary_operation
          { $$ = $1; }
          | binary_operation
          { $$ = $1; }
          ;


/* --- Conditionals --- ------------------------------------------------------*/
conditional : T_IF expression T_THEN expression T_ELSE expression
            { $$ = new Conditional($2,$4,$6); }
            ;


/* --- Declarations --- ------------------------------------------------------*/
declaration : identifier type T_ASSIGN expression
            { $$ = new Declaration($2,$1,$4); }
            ;


/* --- Calls --- -------------------------------------------------------------*/
call : identifier
     { $$ = new Call($1); }
     ;


/* --- Blocks --- ------------------------------------------------------------*/
block : T_LBRA expression_list T_RBRA
      { $$ = $2; }
      ;


expression_list : expression
                { $$ = new Block(); $$->add_expression($1); }
                | expression_list T_LSEP expression
                { $1->add_expression($3); }
                ;

/* --- Expressions --- -------------------------------------------------------*/
expression : numeric { $$ = $1; }
           | decor {$$ = $1; }
           | operation {$$ = $1; }
           | conditional { $$ = $1; }
           | declaration { $$ = $1; }
           | call { $$ = $1; }
           | block { $$ = $1; }
           | subexpression
           ;


subexpression : T_LPAR expression T_RPAR
              { $$ = $2; }
              ;

expr : 
  expr T_IA expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IS expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_ID expr { $$ = new BinaryOperation($2,$1,$3); }

| expr T_FAN expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_FAD expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_FAU expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_FSN expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_FSD expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_FSU expr { $$ = new BinaryOperation($2,$1,$3); }

| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }
| expr T_IM expr { $$ = new BinaryOperation($2,$1,$3); }



















%%

