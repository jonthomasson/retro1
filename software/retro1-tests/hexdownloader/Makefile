SOURCES = firmware.s65

%.o: %.s65
	ca65 -o $@ -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.s65=.o)
	ld65  -Ln firmware.lbl -m firmware.map -o $@ $^
	
clean:
	rm -f *.o *.rom *.map *.lst
