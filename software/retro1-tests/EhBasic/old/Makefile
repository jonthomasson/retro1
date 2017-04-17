SOURCES = min_mon.asm

%.o: %.asm
	ca65 -o $@ -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.asm=.o)
	ld65   -Ln ehbasic.lbl -o $@ $^
	
clean:
	rm -f firmware *.o *.lst
