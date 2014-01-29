#include "ast.hpp"
#include "parser.hpp"
#include <string>


namespace ast
{
	bool _in_decl = true;
	void begin_declaration()
	{
		_in_decl = true;
	}
	void end_declaration()
	{
		_in_decl = false;
	}
	bool in_declaration()
	{
		return _in_decl;
	}
}
