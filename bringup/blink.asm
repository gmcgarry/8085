; Flash a LED on SOD; RAMless  program.
; XTAL: 3.6864MHz -> 1.8432MHz T-cycles

	.org 0
start:

	MVI     A,0C0h          ; (7T)
        SIM                     ; (4T)

        MVI     A, 0FFh         ; (7T)
        MOV     B,A             ; (4T)
1:      DCR     A               ; (4T)
2:      DCR     B               ; (4T)
        JNZ     2b              ; (10T)
        CPI     00h             ; (7T)
        JNZ     1b              ; (10T/7T)

	; ((4+10) * 255 -3 + 7+10+4) * 255 -3 = 915699 = ~0.5s

        MVI     A,40h           ; 000A       3E 40
        SIM                     ; 000C       30

        MVI     A, 0FFh         ; 0013       3E FF
        MOV     B,A             ; 0015       47
1:      DCR     A               ; 0016       3D
2:      DCR     B               ; 0017       05
        JNZ     2b              ; 0018       C2 17 00
        CPI     00h             ; 001B       FE 00
        JNZ     1b              ; 001D       C2 16 00

        JMP     start           ; 0010       C3 04 00
