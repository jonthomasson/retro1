SOURCES = basic.asm ACIA1.asm reset.asm main.asm

%.o: %.asm
	ca65  --feature force_range  --feature labels_without_colons --feature leading_dot_in_identifiers --feature ubiquitous_idents  -o $@ -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.asm=.o)
	ld65 -C firmware.cfg -Ln firmware.lbl -o $@ $^

clean:
	rm -f firmware *.o *.lst

