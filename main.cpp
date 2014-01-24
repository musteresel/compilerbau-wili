#include <iostream>
#include "node.hpp"

extern Block * program_block;
extern int yyparse();

Expr::~Expr()
{}


int main(int argc, char** argv)
{
  yyparse();
  std::cout << "Result: " << program_block << std::endl;
  return 0;
}

