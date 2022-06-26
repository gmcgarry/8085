; Repeated print string to SOD.  RAMless program.
; 19.2kbps for 3.6864 clock

;	.org 0
;	.org 2080h
	.org 8000h
start:
	lxi	h,message
1:
	mov	a,m	; 4T
	ora	a	; 4T
	jz	start	; 7T/10T
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

message:
	.asciz	"Saying hello from the 8085 serial pin.\r\n"
