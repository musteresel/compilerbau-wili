#include "ast.hpp"
#include "parser.hpp"
#include <forward_list>
#include <unordered_map>
#include <string>

/*
 * T_IDENTIFIER { 
 *   ast::context_register(T_BOOL, $1);
 *   ast::context_disallow($1);
 *   }
 * T_ASSIGN
 * bool_expr {
 *   ast::context_reallow($1);
 *   }
 *
 * fctname -> disallow usage, (register as "in progress" ?)
 * paramname -> register in new context with correct type
 *
 * decl a = 5;
 * decl b = 4;
 * decl fun = {
 * 	decl a = 3;
 * 	a / b
 * 	}
 *
 *
 * */


namespace ast
{
	std::forward_list<std::unordered_map<std::string,int>> contexts;
	void context_init(void)
	{
		contexts.push_front(std::unordered_map<std::string,int>());
	}
	
	
	int context_lookup(std::string const * const ident)
	{
		for (auto map : contexts)
		{
			auto it = map.find(*ident);
			if (it != map.end())
			{
				return it->second;
			}
		}
		return T_IDENTIFIER;
	}
}



/*
 * ID PARM1::Type = ...
 *
 * ID -> lookup -> don't find -> disable lookup, register ID, return T_IDENTIFIER
 * PARM1 -> NO lookup -> T_IDENTIFIER
 * :: -> Token
 * Type -> Token
 * = -> Token -> reenable lookup
 *
 * */



/*
Expr::~Expr()
{}
*/

