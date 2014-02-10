#ifndef _WILI_AST_CALLING_HEADER_
#define _WILI_AST_CALLING_HEADER_ 1
#include <ostream>
#include <string>
#include <memory>


#include "cav-helper.hpp"
#include "ast-expression.hpp"


namespace wili
{
  namespace ast
  {
    class declaration : public cav::derive<expr,declaration>
    {
      public:
        expr::ptr expression;
        std::unique_ptr<std::string const> name;


        declaration(std::string const * const text, expr * const e)
          : name(text), expression(e)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "declaration <" << *name << ">";
        }
    };
    class call : public cav::derive<expr,call>
    {
      public:
        std::unique_ptr<std::string const> name;


        call(std::string const * const text)
          : name(text)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "call <" << *name << ">";
        }
    };
  }
}


#endif

