; 19.2kbps for 3.6864 clock
; 96 Tcycles per bit

; C = value to transmit
; Changes A,BC
        di		; 4T
        xra     a       ; 4T (Clear carry)
        mvi     b,11	; 7T (start, 8x data, stop, stop)
1:
        mvi     a,80h   ; 7T
        rar             ; 4T
        sim		; 4T

	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	nop		; 4T
	xri	0	; 7T

        stc             ; 4T
        mov     a,c     ; 4T
        rar             ; 4T
        mov     c,a     ; 4T
        dcr     b       ; 4T
        jnz     1b      ; 10T
	; (7+4+4+(51)+4+4+4+4+4+10) = 15+(51)+30 = 96
        ei		; 4T
