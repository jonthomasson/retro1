CA=ca65
LD=ld65

all: ehbasic

ehbasic: ehbasic.o
	$(LD) -C symon.config -Ln ehbasic.lbl -vm -m ehbasic.map -o ehbasic.rom ehbasic.o

ehbasic.o:
	$(CA) -l ehbasic.lst  -o ehbasic.o min_mon.asm

clean:
	rm -f *.o *.rom *.map *.lst
