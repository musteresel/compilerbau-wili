
all: wili parser.output
.PHONY: clean

wili: tokens.cpp main.cpp parser.cpp ast.hpp ast.cpp
	g++ -std=c++11 -o $@ $^

parser.cpp parser.hpp parser.output: parser.y ast.hpp
	bison -d --report=state -o parser.cpp parser.y

tokens.cpp: tokens.l parser.hpp ast.hpp
	flex -o tokens.cpp tokens.l

clean: wili parser.cpp parser.hpp parser.output tokens.cpp
	rm $^

