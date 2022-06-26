PUTC	EQU	0FA6H	; char in A
GETC	EQU	0FCAH	; char in A
KBHIT	EQU	1006H
MONITR	EQU	018AH
PUTHEX	EQU	0F40H	; char in A
PUTS	EQU	0F58H	; str in H

RAMSTRT	EQU	8000H
RAMEND	EQU	0FFFFH

	.org	RAMSTRT
start:
	LXI	SP,RAMEND

	LXI	H,message
	CALL	PUTS
1:
	CALL	KBHIT
	JZ	1b

	LXI	H,message2
	CALL	PUTS

	CALL	GETC
	CALL	PUTC

	JMP	MONITR

message:
	.asciz	"Press any key\r\n"
message2:
	.asciz	"Enter key\r\n"

	.end
