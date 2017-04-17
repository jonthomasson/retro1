SOURCES = osi_bas.s

%.o: %.s
	ca65 -o $@ -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.s=.o)
	ld65 -C osi_bas.cfg -Ln osi_bas.lbl -o $@ $^
	
clean:
	rm -f firmware *.o *.lst
