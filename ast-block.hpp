#ifndef _WILI_AST_BLOCK_HEADER_
#define _WILI_AST_BLOCK_HEADER_ 1
#include <ostream>


#include "cav-helper.hpp"
#include "ast-expression.hpp"


namespace wili
{
  namespace ast
  {
    class block : public derive<expr,block>
    {
      public:
        ptr<std::list<expr_ptr>> expressions;
        block(std::list<expr_ptr> * const e)
          : expressions(e)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "block";
        }
    };
  }
}


#endif

