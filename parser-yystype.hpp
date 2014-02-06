#ifndef PARSER_YYSTYPE_HEADER
#define PARSER_YYSTYPE_HEADER 1
#include <list>
#include <string>


#include "ast.hpp"
using namespace wili;


union YYSTYPE
{
  ast::module * module;
  ast::expr * expr;
  std::list<ast::expr_ptr> * expr_list;
  std::string * string;
  int token;
};


#endif

