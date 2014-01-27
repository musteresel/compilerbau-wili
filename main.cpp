#include <iostream>
#include "ast.hpp"

extern int yyparse();


int main(int argc, char** argv)
{
	std::cout << "hi" << std::endl;
	ast::context_init();
  yyparse();
  return 0;
}

