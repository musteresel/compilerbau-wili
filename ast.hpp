#ifndef WILI_AST_HEADER
#define WILI_AST_HEADER 1


#include <iostream>
#include <string>
#include <memory>
#include <list>



namespace ast
{
	int context_lookup(std::string const * const ident);
	void context_init(void);
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

