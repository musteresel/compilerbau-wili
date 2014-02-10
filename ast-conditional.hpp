#ifndef _WILI_AST_CONDITIONAL_HEADER_
#define _WILI_AST_CONDITIONAL_HEADER_ 1
#include <ostream>


#include "cav-helper.hpp"
#include "ast-expression.hpp"


namespace wili
{
  namespace ast
  {
    class conditional : public derive<expr,conditional>
    {
      public:
        expr::ptr condition;
        expr::ptr truecase;
        expr::ptr falsecase;


        conditional(expr * const c, expr * const t, expr * const f)
          : condition(c), truecase(t), falsecase(f)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "conditional";
        }
    };
  }
}


#endif

