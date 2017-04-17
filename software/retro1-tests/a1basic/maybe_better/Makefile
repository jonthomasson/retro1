SOURCES = a1basic.s

%.o: %.s
	ca65 -o $@ -l $(@:.o=.lst) $<

all: firmware

firmware: $(SOURCES:.s=.o)
	cl65 -C firmware.cfg -t none -o $@ $^
	
clean:
	rm -f firmware *.o *.lst
