#include <iostream>
#include "ast.hpp"

extern int yyparse();
extern ast::module * program;

int main(int argc, char** argv)
{
	std::cout << "Starting WILI compiler" << std::endl;
  yyparse();
	std::cout << program << std::endl;
	ast::print_description_tree_visitor v;
	program->accept(v);
  return 0;
}

