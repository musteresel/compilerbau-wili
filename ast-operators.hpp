#ifndef _WILI_AST_OPERATORS_HEADER_
#define _WILI_AST_OPERATORS_HEADER_ 1
#include <ostream>


#include "cav-helper.hpp"
#include "ast-expression.hpp"


namespace wili
{
  namespace ast
  {
    class unary : public derive<expr,unary>
    {
      public:
        expr::ptr expression;
        int op;


        unary(int o, expr * const e)
          : op(o), expression(e)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "unary <" << op << ">";
        }
    };


    class binary : public derive<expr,binary>
    {
      public:
        expr::ptr lhs;
        expr::ptr rhs;
        int op;


        binary(int o, expr * const l, expr * const r)
          : op(o), lhs(l), rhs(r)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "binary <" << op << ">";
        }
    };
  }
}


#endif

