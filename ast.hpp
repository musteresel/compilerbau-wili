#ifndef WILI_AST_HEADER
#define WILI_AST_HEADER 1


#include <iostream>
#include <string>
#include <memory>
#include <list>

#include "climbing-acyclic-visitor.hpp"
using namespace cav;


class wili_context
{
  protected:
    void init_scanner();
    void destroy_scanner();
  public:
    void * scanner;

    wili_context()
    {
      init_scanner();
    }
    ~wili_context()
    {
      destroy_scanner();
    }
};
#include "parser.hpp"

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
  void begin_declaration(void);
  void end_declaration(void);
  bool in_declaration(void);
}


namespace ast
{
  template<typename T, typename... ARGS> T * create(ARGS... args)
  {
    T * node = new T(args...);
    std::cerr << "[AST] " << typeid(T).name() << std::endl;
    return node;
  }
}


template<typename P, typename N> class derive : public P, public is_visitable<N>
{
  public:
    using parent_visitable = P;
    void accept(base_visitor & visitor)
    {
      is_visitable<N>::accept(visitor);
    }
};

namespace ast
{
  class expr : public is_visitable<expr>
  {
    public:
      using parent_visitable = base_visitable;
      virtual ~expr() {};
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "expression?";
      }
  };
  class module : public derive<expr,module>
  {
    public:
      string_ptr name;
      expr_ptr expression;
      module(std::string const * const text, expr * const e)
        : name(text), expression(e)
      {}
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "module <" << *name << ">";
      }
  };
  class group : public derive<expr,group>
  {
    public:
      expr_ptr expression;
      group(expr * const e)
        : expression(e)
      {}
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "group";
      }
  };
  class unary : public derive<expr,unary>
  {
    public:
      expr_ptr expression;
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
      expr_ptr lhs;
      expr_ptr rhs;
      int op;
      binary(int o, expr * const l, expr * const r)
        : op(o), lhs(l), rhs(r)
      {}
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "binary <" << op << ">";
      }
  };
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
      string_ptr value;
      decor(std::string const * const text)
        : value(text) //TODO
      {}
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "decor <" << *value << ">";
      }
  };
  class conditional : public derive<expr,conditional>
  {
    public:
      expr_ptr condition;
      expr_ptr truecase;
      expr_ptr falsecase;
      conditional(expr * const c, expr * const t, expr * const f)
        : condition(c), truecase(t), falsecase(f)
      {}
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "conditional";
      }
  };
  class declaration : public derive<expr,declaration>
  {
    public:
      expr_ptr expression;
      string_ptr name;
      declaration(std::string const * const text, expr * const e)
        : name(text), expression(e)
      {}
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "declaration <" << *name << ">";
      }
  };
  class call : public derive<expr,call>
  {
    public:
      string_ptr name;
      call(std::string const * const text)
        : name(text)
      {}
      virtual void print_description_to(std::ostream & stream) const
      {
        stream << "call <" << *name << ">";
      }
  };
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


#endif

