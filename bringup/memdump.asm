; Repeated print string to SOD.  RAMless program.
; 19.2kbps for 3.6864 clock

	.org 0000H
start:
	lxi	h,0x00

top:

	mov	a,h
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

	mov	a,h
	ANI     0Fh             ; Remove high digit
        CPI     10              ; Convert to ASCII
        SBI     2Fh
        DAA
	MOV	C,A
	.include "putc.inc"

	mov	a,l
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

	mov	a,l
	ANI     0Fh             ; Remove high digit
        CPI     10              ; Convert to ASCII
        SBI     2Fh
        DAA
	MOV	C,A
	.include "putc.inc"

	mvi	C,':'
	.include "putc.inc"

	mvi	C,' '
	.include "putc.inc"

	mov	a,m
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

	mov	a,m
	ANI     0Fh             ; Remove high digit
        CPI     10              ; Convert to ASCII
        SBI     2Fh
        DAA
	MOV	C,A
	.include "putc.inc"

	mvi	a,55H
	mov	m,a
	nop
	cmp	m
	jnz	2f

	mvi	a,0AAH
	mov	m,a
	nop
	cmp	m
	jnz	2f

	MVI	C,' '
	.include "putc.inc"

	MVI	C,'M'
	.include "putc.inc"

2:
	MVI	C,'\r'
	.include "putc.inc"

	MVI	C,'\n'
	.include "putc.inc"

	inx	h

	jmp	top
