#include <iostream>
#include "ast.hpp"

extern Block * program_block;
extern int yyparse();

int main(int argc, char** argv)
{
	std::cout << "hi" << std::endl;
  yyparse();
  std::cout << "Result: " << program_block << std::endl;
  return 0;
}

