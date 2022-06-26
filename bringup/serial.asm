; 19.2kbps for 3.6864 clock
; 3.6864MHz / 2 / 19200 = 96 Tcycles

	numbits equ	10      ; One start bit, 8x data, one stop bit (plus an extra)
	inbits  equ	9       ; 8x data, one stop bit
	STACK	equ	0xFFFF

	org 0x8000
start:
	LXI     SP,STACK
	JMP	main

main:
	lxi	h,message
	call	puts
1:
	call	getc
	;rim

	push	psw
        rrc
        rrc
        rrc
        rrc
        ANI     0Fh             ; Remove high digit
        CPI     10              ; Convert to ASCII
        SBI     2Fh
        DAA
        MOV     C,A
	call	putc

	pop	psw
	ANI     0Fh             ; Remove high digit
        CPI     10              ; Convert to ASCII
        SBI     2Fh
        DAA
        MOV     C,A
	call	putc

	mvi	C,'\r'
	call	putc
	mvi	C,'\n'
	call	putc

	jmp	1b

message:
	.asciz	"This is text over the serial pin\r\n"


; C = value to transmit
; Changes A
; Preserves BC
putc:
        di		; 4T
	push	psw	; 12T
        push    b	; 12T
        xra     a       ; 4T (Clear carry)
        mvi     b,numbits	; 7T

1:
        mvi     a,80h   ; 7T
        rar             ; 4T
        sim		; 4T

	nop		; 4T
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	xri	0	; 7T

        stc             ; 4T
        mov     a,c     ; 4T
        rar             ; 4T
        mov     c,a     ; 4T
        dcr     b       ; 4T
        jnz     1b      ; 10T
	; (7+4+4+(51)+4+4+4+4+4+10) = 15+(51)+30 = 96

        pop     b	; 10T
        pop     psw	; 10T
        ei		; 4T
        ret		; 10T

; Input character
; Character in C
; Changes BC
getc:
        di		; 4T
	push	psw	; 12T
        mvi     b,inbits	; 7T
1:
        rim     	; 4T
        ora     a	; 4T
        jm      1b	; 7/10T	- Wait for start bit
	; skip to end of start bit - 96-7-4 = 85
	nop		; 4T
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
3:
	nop		; - Go to middle of the next bit
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	xri	0

        rim		; 4T	- Read in next bit
        ral             ; 4T	- Bit in carry
        dcr     b	; 4T 
        jz      5f      ; 7/10T	- First stop bit, quit
        mov     a,c     ; 4T	- Rotate partial char in to C
        rar		; 4T
        mov     c,a	; 4T
        nop             ; 4T	- getc and putc loop times are the same
        jmp     3b	; 10T
	; 51+4+4+4+7+4+4+4+4+10 = 45+51 = 96
5:
        pop     psw	; 10T
        ei		; 4T
        ret		; 10T

; Output string
; pointer in H:L
puts:
	mov	a,m
	ana	a
	rz
	inx	h
	call	putc
	jmp	puts

	end
