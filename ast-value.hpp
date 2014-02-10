#ifndef _WILI_AST_VALUE_HEADER_
#define _WILI_AST_VALUE_HEADER_ 1
#include <ostream>
#include <string>
#include <memory>


#include "cav-helper.hpp"
#include "ast-expression.hpp"


namespace wili
{
  namespace ast
  {
    class boolean : public derive<expr,boolean>
    {
      public:
        bool value;


        boolean(bool v)
          : value(v)
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "boolean <" << value << ">";
        }
    };


    class numeric : public derive<expr,numeric>
    {
      public:
        double value;


        numeric(std::string * const text)
          : value(std::stod(*text))
        {
          delete text;
        }
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "numeric <" << value << ">";
        }
    };


    class decor : public derive<expr,decor>
    {
      public:
        std::unique_ptr<std::string> value;
        decor(std::string const * const text)
          : value(text) //TODO
        {}
        virtual void print_description_to(std::ostream & stream) const
        {
          stream << "decor <" << *value << ">";
        }
    };

  }
}


#endif

