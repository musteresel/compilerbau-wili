#ifndef _WILI_AST_EXPRESSION_HEADER_
#define _WILI_AST_EXPRESSION_HEADER_ 1
#include <ostream>
#include <memory>


#include "climbing-acyclic-visitor.hpp"


namespace wili
{
  namespace ast
  {
    class expr : public cav::is_visitable<expr>
    {
      public:
        using ptr = std::shared_ptr<expr>;


        using parent_visitable = cav::base_visitable;
        virtual ~expr() {};
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "expression?";
        }
    };
  }
}


#endif

