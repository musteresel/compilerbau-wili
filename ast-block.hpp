#ifndef _WILI_AST_BLOCK_HEADER_
#define _WILI_AST_BLOCK_HEADER_ 1
#include <ostream>
#include <memory>
#include <list>


#include "cav-helper.hpp"
#include "ast-expression.hpp"


namespace wili
{
  namespace ast
  {
    class block : public cav::derive<expr,block>
    {
      public:
        std::unique_ptr<std::list<expr::ptr>> expressions;
        block(std::list<expr::ptr> * const e)
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

