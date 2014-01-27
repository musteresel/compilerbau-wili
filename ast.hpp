#ifndef WILI_AST_HEADER
#define WILI_AST_HEADER 1


#include <iostream>
#include <string>
#include <memory>
#include <list>

namespace ast
{
  template<typename T, typename... ARGS> T * create(ARGS... args)
  {
    T * node = new T(args...);
    std::cerr << "[AST] " << typeid(T).name() << std::endl;
    return node;
  }
}



namespace ast
{
  int context_lookup(std::string const * const ident);
  void context_init(void);
}


namespace ast
{
  class expr
  {
    public:
      virtual ~expr() {};
  };

  class bool_expr : public expr
  {
  };
  class num_expr : public expr
  {
  };
  class decor_expr : public expr
  {
  };
  class ival_expr : public expr
  {
  };

  class bool_literal : public bool_expr
  {
    protected:
      bool const value;
    public:
      bool_literal(bool const v)
        : value(v)
      {}

  };

  class num_literal : public num_expr
  {
    protected:
      double const value;
    public:
      num_literal(std::string const * const text)
        : value(std::stod(*text))
      {}
  };

  class decor_literal : public decor_expr
  {
    protected:
      std::unique_ptr<std::string const> name;
    public:
      decor_literal(std::string const * const text)
        : name(text)
      {}
  };


  template<typename T> class conditional
  {
    protected:
      std::unique_ptr<bool_expr const> condition;
      std::unique_ptr<T const> truecase;
      std::unique_ptr<T const> falsecase;
    public:
      conditional(
          bool_expr const * const c,
          T const * const t,
          T const * const f
          )
        : condition(c), truecase(t), falsecase(f)
      {
      }
  };

  class bool_conditional : public conditional<bool_expr>
                         , public bool_expr
  {
    public:
      using conditional<bool_expr>::conditional;
  };
  class num_conditional : public conditional<num_expr>
                        , public num_expr
  {
    public:
      using conditional<num_expr>::conditional;
  };
  class decor_conditional : public conditional<decor_expr>
                          , public decor_expr
  {
    public:
      using conditional<decor_expr>::conditional;
  };
  class ival_conditional : public conditional<ival_expr>
                         , public ival_expr
  {
    public:
      using conditional<ival_expr>::conditional;
  };


  template<typename T> class termseq
  {
    protected:
      std::unique_ptr<std::list<std::unique_ptr<ast::expr const>>> expressions;
      std::unique_ptr<T const> last_expression;
    public:
      termseq(
          std::list<std::unique_ptr<ast::expr const>> * const l,
          T const * const e
          )
        : expressions(l), last_expression(e)
      {
      }
  };
  class bool_termseq : public termseq<bool_expr>
                     , public bool_expr
  {
    public:
      using termseq<bool_expr>::termseq;
  };
  class num_termseq : public termseq<num_expr>
                     , public num_expr
  {
    public:
      using termseq<num_expr>::termseq;
  };
  class decor_termseq : public termseq<decor_expr>
                     , public decor_expr
  {
    public:
      using termseq<decor_expr>::termseq;
  };
  class ival_termseq : public termseq<ival_expr>
                     , public ival_expr
  {
    public:
      using termseq<ival_expr>::termseq;
  };


  template<typename T> class binary
  {
    protected:
      int op;
      std::unique_ptr<T const> lhs;
      std::unique_ptr<T const> rhs;
    public:
      binary(
          int o,
          T const * const l,
          T const * const r
          )
        : op(o), lhs(l), rhs(r)
      {
      }
  };
  template<typename T> class compare : public binary<T>
                                     , public bool_expr
  {
    public:
      using binary<T>::binary;
  };
  class bool_binary : public binary<bool_expr>
                    , public bool_expr
  {
    public:
      using binary<bool_expr>::binary;
  };
  class num_binary : public binary<num_expr>
                   , public num_expr
  {
    public:
      using binary<num_expr>::binary;
  };
  class ival_binary : public binary<ival_expr>
                    , public ival_expr
  {
    public:
      using binary<ival_expr>::binary;
  };
  class num_compare : public compare<num_expr>
  {
    public:
      using compare<num_expr>::compare;
  };
  class ival_compare : public compare<ival_expr>
  {
    public:
      using compare<ival_expr>::compare;
  };


}



/*
class Expr
{
  public:
    virtual ~Expr();
};



class Identifier
{
  public:
    std::unique_ptr<std::string const> name;

    Identifier(std::string const * const text)
      : name(text)
    {
      std::cout << "[CREATE] Identifier \"" << *name << "\"" << std::endl;
    }
};

class Numeric : public Expr
{
  public:
    double value;

    Numeric(std::string const * const text)
    {
      value = std::stod(*text);
      std::cout << "[CREATE] Numeric " << value << std::endl;
    }
};

class Decor : public Expr
{
  public:
    std::unique_ptr<std::string const> value;

    Decor(std::string const * const text)
      : value(text)
    {
      std::cout << "[CREATE] Decor \"" << *value << "\"" << std::endl;
    }
};

class TypeIdentifier
{
  public:
    std::unique_ptr<std::string const> name;

    TypeIdentifier(std::string const * const text)
      : name(text)
    {
      std::cout << "[CREATE] TypeIdentifier " << *name << std::endl;
    }
};


class UnaryOperation : public Expr
{
  public:
    int op;
    std::unique_ptr<Expr const> expression;

    UnaryOperation(int o, Expr const * const e)
      : op(o), expression(e)
    {
      std::cout << "[CREATE] Unary operation #" << op << std::endl;
    }
};

class BinaryOperation : public Expr
{
  public:
    int op;
    std::unique_ptr<Expr const> lhs;
    std::unique_ptr<Expr const> rhs;

    BinaryOperation(
        int o,
        Expr const * const l,
        Expr const * const r)
      : op(o), lhs(l), rhs(r)
    {
      std::cout << "[CREATE] Binary operation #" << op << std::endl;
    }
};

class Conditional : public Expr
{
  public:
    std::unique_ptr<Expr const> condition;
    std::unique_ptr<Expr const> truecase;
    std::unique_ptr<Expr const> falsecase;

    Conditional(
        Expr const * const c,
        Expr const * const t,
        Expr const * const f)
      : condition(c), truecase(t), falsecase(f)
    {
      std::cout << "[CREATE] Conditional" << std::endl;
    }
};

class Declaration : public Expr
{
  public:
    std::unique_ptr<Identifier const> id;
    std::unique_ptr<TypeIdentifier const> typeidentifier;
    std::unique_ptr<Expr const> value;

    Declaration(
        TypeIdentifier const * const t,
        Identifier const * const i,
        Expr const * const v)
      : id(i), typeidentifier(t), value(v)
    {
      std::cout << "[CREATE] Declaration of " << *(id->name) << std::endl;
    }
};

class Call : public Expr
{
  public:
    std::unique_ptr<Identifier const> name;

    Call(Identifier const * const n)
      : name(n)
    {
      std::cout << "[CREATE] Call for " << *(name->name) << std::endl;
    }
};


class Block : public Expr
{
  public:
    std::list<std::unique_ptr<Expr const>> expressions;

    Block()
    {
      std::cout << "[CREATE] Block" << std::endl;
    }

    void add_expression(Expr const * const e)
    {
      expressions.emplace_back(e);
      std::cout << "--Block: Size = " << expressions.size() << std::endl;
    }
};
*/

#endif

