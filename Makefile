.PHONY: all build format edit demo clean

src?=0
dst?=3
graph?=graph3.txt

all: build

build:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ftest.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

format:
	ocp-indent --inplace src/*

edit:
	code . -n

demo: build
	./ftest.exe graphs/graph1.txt $(src) $(dst) outfile1.txt

	./ftest.exe graphs/graph2.txt $(src) $(dst) outfile2.txt

	./ftest.exe graphs/graph3.txt $(src) $(dst) outfile3.txt

	./ftest.exe graphs/graph4.txt $(src) $(dst) outfile4.txt

	./ftest.exe graphs/graph5.txt $(src) $(dst) outfile5.txt

	./ftest.exe graphs/graph6.txt $(src) $(dst) outfile6.txt

	./ftest.exe graphs/graph7.txt $(src) $(dst) outfile7.txt

	./ftest.exe graphs/graph8.txt $(src) $(dst) outfile8.txt

	./ftest.exe graphs/graph9.txt $(src) $(dst) outfile9.txt

	./ftest.exe graphs/graph10.txt 0 7 outfile10.txt

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
