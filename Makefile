.PHONY: test clean valgrind

CFLAGS :=-O3 -std=c99
CXXFLAGS :=-O3 -std=c++98

all: http-server

test: test-results.txt
	diff test-results.txt test/results.txt

test-unix: test-results-unix.txt
	diff test-results_unix.txt test/results_unix.txt

test-cpp: test-results-cpp.txt
	diff test-results-cpp.txt test/results.txt

valgrind: valgrind-results.txt
	diff valgrind-results.txt test/valgrind.txt

test-results.txt: http-server test/run test/run_unix
	./http-server & test/run > test-results.txt; killall http-server;

test-results-unix.txt: http-server-unix test/run_unix
	./http-server & test/run_unix > test-results_unix.txt; killall http-server;

valgrind-results.txt: http-server
	test/valgrind

http-server: test/main.c httpserver.h
	$(CC) $(CFLAGS) -Wall -Wextra -Werror test/main.c -o http-server

http-server-unix: test/main.c httpserver.h
	$(CC) $(CFLAGS) -Wall -Wextra -Werror -DTEST_UNIX test/main.c -o http-server

http-server-cpp: test/main.cpp httpserver.h
	$(CXX) $(CXXFLAGS) -Wall -Wextra -Werror test/main.cpp -o http-server-cpp

test-results-cpp.txt: http-server-cpp
	./http-server-cpp & test/run > test-results-cpp.txt; killall http-server-cpp;

test/main.cpp: test/main.c
	cp test/main.c test/main.cpp

clean:
	@rm http-server http-server-cpp *.txt *.sock *.dat
