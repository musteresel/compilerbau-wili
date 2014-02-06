#ifndef _WILI_PARSE_UNIT_HEADER_
#define _WILI_PARSE_UNIT_HEADER_ 1
#include <sstream>
#include <istream>
#include <string>


namespace wili
{
  namespace parser
  {
    /** Class to represent a parsing unit.
     *
     * Mostly, this means a file that has been parsed.
     * */
    class unit
    {
      protected:
        void * scanner;
        bool flex_debug;

        bool decl_mode;
        std::istream & input;
        std::ostringstream log;
        bool good;


        void init_scanner(void);
        void destroy_scanner(void);
        void run_parser(void);


      public:
        unit(std::istream &);
        ~unit();
       

        void scanner_input(
            char * const, long unsigned int &, long unsigned int const);
        void log_terminal(
            char const * const, std::string const * const = nullptr);
        void log_error(
            char const * const);
       

        template<typename T, typename... ARGS> T * create(ARGS... args)
        {
          T * node = new T(args...);
          return node;
        }
        std::ostringstream const & get_log(void) const
        {
          return log;
        }
        void * get_scanner(void) const
        {
          return scanner;
        }
        bool in_declaration(void) const
        {
          return decl_mode;
        }
        void begin_declaration(void)
        {
          decl_mode = true;
        }
        void end_declaration(void)
        {
          decl_mode = false;
        }
        explicit operator bool() const
        {
          return good;
        }
    };
  }
}


#endif

