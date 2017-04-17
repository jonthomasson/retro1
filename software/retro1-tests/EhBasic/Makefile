SOURCES = min_mon.asm

%.o: %.asm
	ca65 -o $@ -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.asm=.o)
	ld65 -C symon.config -Ln ehbasic.lbl -m ehbasic.map -o $@ $^
	
clean:
	rm -f *.o *.rom *.map *.lst
