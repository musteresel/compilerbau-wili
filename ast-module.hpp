#ifndef _WILI_AST_MODULE_HEADER_
#define _WILI_AST_MODULE_HEADER_ 1
#include <ostream>
#include <string>
#include <memory>


#include "ast-expression.hpp"
#include "cav-helper.hpp"


namespace wili
{
  namespace ast
  {
    class module : public derive<expr,module>
    {
      public:
        std::unique_ptr<std::string> name;
        expr::ptr expression;


        module(std::string const * const text, expr * const e)
          : name(text), expression(e)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "module <" << *name << ">";
        }
    };
  }
}


#endif

