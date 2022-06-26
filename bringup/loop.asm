; output via ROM monitor

PUTC	EQU	0FA6H
GETC	EQU	0FCAH

	.org 8000h
start:
	lxi	SP,0FFFFH
	lxi	h,message
1:
	mov	a,m	; 4T
	ora	a	; 4T
	jz	start	; 7T/10T
	inx	h	; 4T
	call	PUTC
	jmp	1b	; 10T

message:
	.asciz	"Saying hello from the 8085 serial pin.\r\n"
