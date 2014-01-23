

enum OperatorType
{
	F_ADD_N, F_ADD_U, F_ADD_D,
	F_SUB_N, F_SUB_U, F_SUB_D,
	F_MUL_N, F_MUL_U, F_MUL_D,
	F_DIV_N, F_DIV_U, F_DIV_D,

	F_EQ, F_NE, F_LE, F_LT, F_GE, F_GT

	I_ADD, I_SUB, I_MUL, I_DIV,

	I_E, I_NE,
	I_S, I_SS, I_SU, I_SSU,
	I_L, I_LE, I_G, I_GE,
	I_AL, I_ALE, I_AG, I_AGE,

	I_CONSTRUCT,
	I_DECOR,

	I_UNDECOR, I_GETDECOR
};



class Expr
{
	public:
		virtual ~Expr();
};

class Block : public Expr
{
	public:
		std::list<Expr> const expressions;
};

class If : public Expr
{
	public:
		Expr const * const condition;
		Expr const * const ifblock;
		Expr const * const elseblock;
};

class Assignment : public Expr
{
	public:
		Identifier const * const type;
		Identifier const * const name;
		Expr const * const value;
};

class Identifier : public Expr
{
	public:
		std::unique_ptr<std::string> const name;
};

class Operator : public Expr
{
	public:
		Expr const * const left;
		Expr const * const right;
		OperatorType operator;
};


