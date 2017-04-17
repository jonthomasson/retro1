SOURCES = krusader.asm

%.o: %.asm
	ca65 -o $@ --feature force_range  --feature labels_without_colons --feature leading_dot_in_identifiers --feature ubiquitous_idents -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.asm=.o)
	cl65  -t none -o $@ $^

clean:
	rm -f firmware *.o *.lst
