#include <iostream>
#include "ast.hpp"
#include "parser-unit.hpp"


int main(int argc, char** argv)
{
	std::cout << "Starting WILI compiler" << std::endl;
	wili::parser::unit u(std::cin);
	std::cout << u.get_log().str() << std::endl;
	if (u)
	{
		std::cout << "Parsing succeeded!" << std::endl;
	}
  return 0;
}

