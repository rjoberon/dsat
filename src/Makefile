all: dsat.py cis.py dsat.pdf cis.pdf dsat.png cis.png

%.py: %.ksy
	ksc -t python $<

%.dot: %.ksy
	ksc -t graphviz $<

%.pdf: %.dot
	dot $< -Tpdf -o $@

%.png: %.dot
	dot $< -Tpng -o $@
