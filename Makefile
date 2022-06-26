all:

clean:
	$(RM) *.hex *.bin *.lst

.SUFFIXES:	.hex .asm .bin .s19

.asm.hex:
	pasm-8080 -d1000 -F hex -o $@ $< > $@.lst

.asm.s19:
	pasm-8080 -d1000 -F srec2 -o $@ $< > $@.lst

.asm.bin:
	pasm-8080 -F bin -o $@ $<
