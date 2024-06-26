all: dsat.py cis.py dsat.pdf cis.pdf

%.py: %.ksy
	ksc -t python $<

%.dot: %.cis
	ksc -t graphviz $<

%.pdf: %.dot
	dot $< -Tpdf -o $@
