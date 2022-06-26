; 19.2kbps for 3.6864 clock

	.org 0
start:
	rim
	mov	b,a

	rrc
	rrc
	rrc
	rrc
	ANI     0Fh             ; Remove high digit
        CPI     10              ; Convert to ASCII
        SBI     2Fh
        DAA
	MOV	C,A
	.include "putc.inc"

	mov	a,b
	ANI     0Fh             ; Remove high digit
        CPI     10              ; Convert to ASCII
        SBI     2Fh
        DAA
	MOV	C,A
	.include "putc.inc"

	MVI	C,'\r'
	.include "putc.inc"

	MVI	C,'\n'
	.include "putc.inc"

	jmp	start
