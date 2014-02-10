#ifndef WILI_AST_HEADER
#define WILI_AST_HEADER 1
#include "ast-module.hpp"
#include "ast-expression.hpp"
#include "ast-calling.hpp"
#include "ast-operators.hpp"
#include "ast-value.hpp"
#include "ast-conditional.hpp"
#include "ast-group.hpp"
#include "ast-block.hpp"



#include <iostream>
#include <string>
#include <memory>
#include <list>

#include "climbing-acyclic-visitor.hpp"
#include "cav-helper.hpp"
using namespace cav;

#include "parser.hpp"

namespace wili
{
namespace ast
{
  class expr;
  template<typename T> using ptr = std::unique_ptr<T>;
  using expr_ptr = ptr<expr>;
  using string_ptr = ptr<std::string const>;
  using expr_list_ptr = ptr<std::list<expr_ptr>>;
}


namespace ast
{
  /*
     enum type
     {
     UNKNOWN,
     BOOLEAN,
     NUMERIC,
     DECOR,
     INTERVAL
     };*/

  class type
  {
  };
  class simple : public type
  {
    public:
      enum class id : char
    {
      UNKNOWN,
      BOOLEAN,
      NUMERIC,
      DECOR,
      IVAL,
      DIVAL
    }_id;
  };
  class calling : public type
  {
    protected:
      type arg;
      type ret;
    public:
  };
}

namespace ast
{
  class description_printer : public can_visit<expr>,
                              public can_visit<declaration>,
                              public can_visit<block>,
                              public can_visit<conditional>,
                              public can_visit<binary>,
                              public can_visit<unary>,
                              public can_visit<module>,
                              public can_visit<group>
  {
    protected:
      int indent;
      std::ostream & stream;
      void print(expr & e)
      {
        for (int i = 0; i < indent; i++)
        {
          stream << "|   ";
        }
        stream << "|-- ";
        e.print_description_to(stream);
        stream << std::endl;
      }
    public:
      description_printer(std::ostream & s)
        : stream(s), indent(0)
      {
      }
      void unknown_visitable(base_visitable * b)
      {
        stream << "unknown" << std::endl;
      }
      void visit(expr & e)
      {
        print(e);
      }
      void visit(declaration & e)
      {
        print(e);
        indent++;
        e.expression->accept(*this);
        indent--;
      }
      void visit(block & e)
      {
        print(e);
        indent++;
        auto list = e.expressions.get();
        for(auto i = list->cbegin(); i != list->cend(); i++)
        {
          i->get()->accept(*this);
        }
        indent--;
      }
      void visit(conditional & e)
      {
        print(e);
        indent++;
        e.condition->accept(*this);
        e.truecase->accept(*this);
        e.falsecase->accept(*this);
        indent--;
      }
      void visit(binary & e)
      {
        print(e);
        indent++;
        e.lhs->accept(*this);
        e.rhs->accept(*this);
        indent--;
      }
      void visit(unary & e)
      {
        print(e);
        indent++;
        e.expression->accept(*this);
        indent--;
      }
      void visit(module & e)
      {
        print(e);
        indent++;
        e.expression->accept(*this);
        indent--;
      }
      void visit(group & e)
      {
        print(e);
        indent++;
        e.expression->accept(*this);
        indent--;
      }
  };
}
}

#endif

