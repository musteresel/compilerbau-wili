
CPPSOURCES := main.cpp ast.cpp parser-unit.cpp


all: wili parser.output
.PHONY: clean


wili make.deps: $(CPPSOURCES) tokens.cpp parser.cpp
	g++ -std=c++11 -MMD -MF make.deps -MT wili -o wili $^

parser.cpp parser.hpp parser.output: parser.y
	bison -d --report=state -o parser.cpp parser.y

tokens.cpp: tokens.l
	flex -o tokens.cpp tokens.l

clean:
	rm wili make.deps parser.cpp parser.hpp parser.output tokens.cpp || true

ifneq ($(MAKECMDGOALS),clean)
-include make.deps
endif

