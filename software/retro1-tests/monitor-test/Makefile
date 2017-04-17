SOURCES = acia.s65 string.s65 main.s65

%.o: %.s65
	ca65 -o $@ -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.s65=.o)
	ld65 -C firmware.cfg -Ln firmware.lbl -o $@ $^

clean:
	rm -f firmware *.o *.lst
