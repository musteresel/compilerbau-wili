#ifndef _WILI_AST_GROUP_HEADER_
#define _WILI_AST_GROUP_HEADER_ 1
#include <ostream>


#include "cav-helper.hpp"
#include "ast-expression.hpp"


namespace wili
{
  namespace ast
  {
    class group : public derive<expr,group>
    {
      public:
        expr::ptr expression;
        group(expr * const e)
          : expression(e)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "group";
        }
    };
  }
}


#endif

