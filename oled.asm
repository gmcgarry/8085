;
; Demo on OLED display
;   - 0.96 inch OLED (white)
;   - SSD1306 driver chip
;   - 128X64 pixels
;   - I2C interface

STACK		EQU	0FFFFH
OLED_ADDR	EQU	3CH

PUTC	EQU	0FA6H	; char in A
GETC	EQU	0FCAH	; char in A
KBHIT	EQU	1006H
MONITR	EQU	018AH
PUTHEX	EQU	0F40H	; char in A
PUTS	EQU	0F58H	; str in H

	ORG	0x8000
; ------------------------------------------------------------ 
reset:
	LXI	SP,STACK
	JMP	main

ColStart:	DB	0
ColEnd:		DB	0
PageStart:	DB	0
PageEnd:	DB	0

	.include "i2c.inc"
	.include "font8x16.inc"

; ------------------------------------------------------------ 
main:
	CALL	oled_init

	CALL	oled_clear

	MVI	A,00H
	STA	ColStart
	STA	PageStart

	LXI	H,message
	CALL	PUTS
	LXI	H,message
	CALL	putstring
loop:
	LXI	H,on
	CALL	PUTS
	LXI	H,on
	CALL	putstring
	CALL	Delay

	LXI	H,off
	CALL	PUTS
	LXI	H,off
	CALL	putstring
	CALL	Delay

	CALL	KBHIT
	JZ	loop

	JMP	MONITR

on:	.asciz "on \r"
off:	.asciz "off\r"

message:
	.asciz "Blinking...\r\n"

; ------------------------------------------------------------ 

;Delay, return to HL when done.
Delay:
	MVI     A, 0FFH
	MOV     B,A
1:
	DCR     A
2:
	DCR     B
	JNZ     2b
	CPI     00H
	JNZ     1b
	RET

; ------------------------------------------------------------ 
; oled init
oled_init:
	PUSH	PSW
	PUSH	B
	PUSH	H

	CALL	i2c_init

	CALL	i2c_start

	MVI	A,(OLED_ADDR<<1)
	CALL	i2c_write

	LXI	H,init_data
	MVI	B,(init_data_end - init_data)
2:
	MVI	A,80H
	CALL	i2c_write
	MOV	A,M
	CALL	i2c_write
	INX	H
	DCR	B
	JNZ	2b

	CALL	i2c_stop

	POP	H
	POP	B
	POP	PSW
	RET

init_data:
	DB	0x8D	; enable charge-pump regulator
	DB	0x14
	DB	0xAF	; display on
	DB	0x20	; set memory addressing mode to Horizontal Addressing Mode
	DB	0x00
	DB	0x21	; reset column address
	DB	0x00
	DB	0xFF
	DB	0x22	; reset page address
	DB	0x00
	DB	0x07
init_data_end:

; ------------------------------------------------------------ 
oled_clear:
	PUSH	PSW
	PUSH	B

	MVI	C,64
1:
	CALL	i2c_start

	MVI	A,(OLED_ADDR<<1)
	CALL	i2c_write

	MVI	A,40H			; set start line to 0
	CALL	i2c_write

	MVI	B,16
2:
	MVI	A,0
	CALL	i2c_write
	DCR	B
	JNZ	2b

	CALL	i2c_stop

	DCR	C
	JNZ	1b
	
	POP	B
	POP	PSW
	RET

; ------------------------------------------------------------ 
; X=string
;
putstring:
	PUSH	PSW
	PUSH	H
1:
	MOV	A,M
	INX	H
	ANA	A
	JZ	2f
	CALL	putchar
	JMP	1b
2:
	POP	H
	POP	PSW
	RET

; ------------------------------------------------------------ 
; A=char
putchar:
	PUSH	PSW

	CPI	'\r'
	JNZ	PC00
	MVI	A,0
	STA	ColStart
	JMP	PC5
PC00:
	CPI	'\n'
	JNZ	PC0
	LDA	PageStart
	ADI	FONTHEIGHT
	STA	PageStart
	JMP	PC5
PC0:
	PUSH	H
	PUSH	D

	LXI	H,Font		; Point to FontTable

	SUI	20H		; Table matching (Lookup table = ASCII table - Table Offset Value)
	JZ	PC2
PC1:
	LXI	D,(FONTWIDTH*FONTHEIGHT)
PC01:
	DAD	D
	DCR	A
	JNZ	PC01
PC2:
	LDA	ColStart		; check if ColStart > 128-FONTWIDTH+1
	SUI	(128-FONTWIDTH+1)
	JC	PC3

	MVI	A,00H
	STA	ColStart
	LDA	PageStart
	ADI	FONTHEIGHT
	STA	PageStart
PC3:
	LDA	ColStart
	ADI	(FONTWIDTH-1)
	STA	ColEnd

	LDA	PageStart
	ADI	(FONTHEIGHT-1)
	STA	PageEnd

	CALL	SetColumn
	CALL	SetPage

	CALL	i2c_start

	MVI	A,(OLED_ADDR<<1)
	CALL	i2c_write

	MVI	A,40H
	CALL	i2c_write

	MVI	B,(FONTWIDTH*FONTHEIGHT)
PC4:
	MOV	A,M
	CALL	i2c_write
	INX	H
	DCR	B
	JNZ	PC4

	CALL	i2c_stop

	LDA	ColStart
	ADI	FONTWIDTH
	STA	ColStart

	POP	D
	POP	H
PC5:
	POP	PSW
	RET

; ------------------------------------------------------------ 
SetColumn:
	CALL	i2c_start

	MVI	A,(OLED_ADDR<<1)
	CALL	i2c_write

	MVI	A,00H		; command stream
	CALL	i2c_write

	MVI	A,21H		; set column address range
	CALL	i2c_write

	LDA	ColStart
	CALL	i2c_write

	LDA	ColEnd
	CALL	i2c_write

	CALL	i2c_stop

	RET

; ------------------------------------------------------------ 
SetPage:
	CALL	i2c_start

	MVI	A,(OLED_ADDR<<1)
	CALL	i2c_write

	MVI	A,00H		; command stream
	CALL	i2c_write

	MVI	A,22H		; set page address range
	CALL	i2c_write

	LDA	PageStart
	CALL	i2c_write

	LDA	PageEnd
	CALL	i2c_write

	CALL	i2c_stop

	RET
