.PHONY: all build format edit demo clean

src?=0
dst?=7
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
	./ftest.exe graphs/graph1.txt 0 4 outfile1.txt
	@cat outfile1.txt

	./ftest.exe graphs/graph2.txt 0 12 outfile2.txt
	@cat outfile2.txt

	./ftest.exe graphs/graph3.txt 0 2 outfile3.txt
	@cat outfile3.txt

	./ftest.exe graphs/graph4.txt $(src) $(dst) outfile4.txt
	@cat outfile4.txt

	./ftest.exe graphs/graph5.txt $(src) $(dst) outfile5.txt
	@cat outfile5.txt

	./ftest.exe graphs/graph6.txt $(src) $(dst) outfile6.txt
	@cat outfile6.txt

	./ftest.exe graphs/graph7.txt 3 8 outfile7.txt
	@cat outfile7.txt

	./ftest.exe graphs/graph8.txt $(src) $(dst) outfile8.txt
	@cat outfile8.txt

	./ftest.exe graphs/graph9.txt $(src) $(dst) outfile9.txt
	@cat outfile9.txt

	./ftest.exe graphs/graph10.txt $(src) $(dst) outfile10.txt
	@cat outfile10.txt

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
