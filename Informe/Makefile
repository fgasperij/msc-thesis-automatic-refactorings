MAIN=tesis

all: clean build

build:
	pdflatex -interaction=nonstopmode $(MAIN).tex
	pdflatex -interaction=nonstopmode $(MAIN).tex
clean:
	rm -f $(MAIN).pdf *.log *.out *.toc
