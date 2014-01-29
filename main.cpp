#include <iostream>
#include "ast.hpp"

extern int yyparse();


int main(int argc, char** argv)
{
	std::cout << "Starting WILI compiler" << std::endl;
  yyparse();
  return 0;
}

