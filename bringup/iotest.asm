;
; Writes to MSM4262 RTC
; (doesn't work because too many bits
; are used for chip select, leaving not
; enought for the register addressing)
;

PUTC	EQU	0FA6H	; char in A
GETC	EQU	0FCAH	; char in A
KBHIT	EQU	1006H
MONITR	EQU	018AH
PUTHEX	EQU	0F40H	; char in A
PUTS	EQU	0F58H	; str in H

	.org	8000H
start:
	LXI	SP,0FFFFH

	LXI	H,message
	CALL	PUTS
1:
	CALL	KBHIT
	JZ	1b

	MVI	A,0FFH	; low
	OUT	24H	
	MVI	A,7FH	; high wave out
	OUT	25H
	MVI	A,0C1H	; Timer start
	OUT	20H

;	MVI	A,01H	; PortA output,  PortB input
;	OUT	20H
	MVI	A,55H	; PortA=55
	OUT	21H
	OUT	22H
	OUT	23H

1:
	IN	20H
	CALL	PUTHEX
	MVI	A,':'
	CALL	PUTC

	IN	21H
	CALL	PUTHEX
	MVI	A,':'
	CALL	PUTC

	IN	22H
	CALL	PUTHEX
	MVI	A,':'
	CALL	PUTC

	IN	23H
	CALL	PUTHEX
	MVI	A,':'
	CALL	PUTC

	IN	24H
	CALL	PUTHEX
	MVI	A,':'
	CALL	PUTC

	IN	25H
	CALL	PUTHEX
	MVI	A,'\r'
	CALL	PUTC

	CALL	KBHIT
	JZ	1b

	JMP	MONITR

message:
	.asciz	"Press any key to start\r\n"

	.end
