#include "parser-unit.hpp"
#include <sstream>
#include <iostream>


namespace wili
{
  namespace parser
  {
    unit::unit(std::istream & in)
      : input(in), good(true)
    {
      init_scanner();
      run_parser();
    }


    unit::~unit()
    {
      destroy_scanner();
    }


    void unit::log_terminal(
        char const * const name, std::string const * const value)
    {
      log << "Found terminal \"" << name << "\"";
      if (value != nullptr)
      {
        log << " with value \"" << *value << "\"";
      }
      log << std::endl;
    }


    void unit::log_error(
        char const * const msg)
    {
      good = false;
      log << "ERROR: " << msg << std::endl;
    }
  }
}

