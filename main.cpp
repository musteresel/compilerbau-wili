#include <iostream>
#include "ast.hpp"


extern ast::module * program;

int main(int argc, char** argv)
{
	std::cout << "Starting WILI compiler" << std::endl;
	wili_context ctx;
  yyparse(ctx);
	std::cout << program << std::endl;
	ast::description_printer p(std::cout);
	program->accept(p);
  return 0;
}

