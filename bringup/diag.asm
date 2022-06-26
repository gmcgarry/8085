; Repeated print string to SOD.  RAMless program.
; 19.2kbps for 3.6864 clock

	.org	00H
        JMP	RESET
	.org	08H
RST1:   JMP	RST1VEC         ; Invoke interrupt
	.org	0CH
RST15:  JMP	RST15VEC        ; Invoke interrupt
	.org	10H
RST2:   JMP	RST2VEC         ; Invoke interrupt
	.org	14H
RST25:  JMP	RST25VEC        ; Invoke interrupt
	.org	18H
RST3:   JMP	RST3VEC         ; Invoke interrupt
	.org	1CH
RST35:  JMP	RST35VEC        ; Invoke interrupt
	.org	20H
RST4:   JMP	RST4VEC         ; Invoke interrupt
	.org	24H
TRAP:   JMP	TRAPVEC         ; Invoke interrupt
	.org	28H
RST5:   JMP	RST5VEC         ; Invoke interrupt
	.org	2CH
RST55:  JMP	RST55VEC        ; Invoke interrupt
	.org	30H
RST6:   JMP	RST6VEC         ; Invoke interrupt
	.org	34H
RST65:  JMP	RST65VEC        ; Invoke interrupt
	.org	38H
RST7:   JMP	RST7VEC         ; Invoke interrupt
	.org	3CH
RST75:  JMP	RST75VEC        ; Invoke interrupt


resets:
	.asciz	"Entry via RESET\r\n"
RESET:
	lxi	h,resets
	jmp	PRINT

rst1s:
	.asciz	"Entry via RST 1\r\n"
RST1VEC:
	lxi	h,rst1s
	jmp	PRINT

rst15s:
	.asciz	"Entry via RST 1.5\r\n"
RST15VEC:
	lxi	h,rst15s
	jmp	PRINT

rst2s:
	.asciz	"Entry via RST 2\r\n"
RST2VEC:
	lxi	h,rst2s
	jmp	PRINT

rst25s:
	.asciz	"Entry via RST 2.5\r\n"
RST25VEC:
	lxi	h,rst25s
	jmp	PRINT

rst3s:
	.asciz	"Entry via RST 3\r\n"
RST3VEC:
	lxi	h,rst3s
	jmp	PRINT

rst35s:
	.asciz	"Entry via RST 3.5\r\n"
RST35VEC:
	lxi	h,rst35s
	jmp	PRINT

rst4s:
	.asciz	"Entry via RST 4\r\n"
RST4VEC:
	lxi	h,rst4s
	jmp	PRINT

traps:
	.asciz	"Entry via non-mastable TRAP\r\n"
TRAPVEC:
	lxi	h,traps
	jmp	PRINT

rst5s:
	.asciz	"Entry via RST 5\r\n"
RST5VEC:
	lxi	h,rst5s
	jmp	PRINT

rst55s:
	.asciz	"Entry via RST 5.5\r\n"
RST55VEC:
	lxi	h,rst55s
	jmp	PRINT

rst6s:
	.asciz	"Entry via RST 6\r\n"
RST6VEC:
	lxi	h,rst6s
	jmp	PRINT

rst65s:
	.asciz	"Entry via RST 6.5\r\n"
RST65VEC:
	lxi	h,rst65s
	jmp	PRINT

rst7s:
	.asciz	"Entry via RST 7\r\n"
RST7VEC:
	lxi	h,rst7s
	jmp	PRINT

rst75s:
	.asciz	"Entry via RST 7.5\r\n"
RST75VEC:
	lxi	h,rst75s
	jmp	PRINT

message:
	.asciz	"Hello from 8085 SOD...\r\n"
LOOP:

DELAY:
        MVI     A, 0FFh        ; 0013       3E FF
        MOV     B,A            ; 0015       47
1:      DCR     A              ; 0016       3D
2:      DCR     B              ; 0017       05
        JNZ     2b             ; 0018       C2 17 00
        CPI     00h            ; 001B       FE 00
        JNZ     1b             ; 001D       C2 16 00

	lxi	h,message
PRINT:
1:
	mov	a,m	; 4T
	ora	a	; 4T
	jz	LOOP	; 7T/10T
	inx	h	; 4T

	di		; 4T
	mov	c,a	; 4T
        xra     a       ; 4T (Clear carry)
        mvi     b,10	; 7T (One start bit, 8x data, one stop bit)
2:
        mvi     a,80h   ; 7T
        rar             ; 4T
        sim		; 4T

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
	xri	0

        stc             ; 4T
        mov     a,c     ; 4T
        rar             ; 4T
        mov     c,a     ; 4T
        dcr     b       ; 4T
        jnz     2b      ; 10T
	; (7+4+4+(51)+4+4+4+4+4+10) = 15+(51)+30 = 96
        ei		; 4T

	jmp	1b	; 10T
