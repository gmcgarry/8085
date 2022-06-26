;Assembly                                 Address    Opcode

;Flash a LED on SOD

START:          LXI     H,02000h        ; 0000       21 00 C0
                SPHL                    ; 0003       F9


FLASH:          MVI     A,0C0h          ; 0004       3E C0
                SIM                     ; 0006       30
                CALL    DELAY           ; 0007       CD 13 00
                MVI     A,40h           ; 000A       3E 40
                SIM                     ; 000C       30
                CALL    DELAY           ; 000D       CD 13 00
                JMP     FLASH           ; 0010       C3 04 00

;Delay, return to HL when done.
DELAY:          MVI     A, 0FFh         ; 0013       3E FF
                MOV     B,A             ; 0015       47
PT1:            DCR     A               ; 0016       3D
PT2:            DCR     B               ; 0017       05
                JNZ     PT2             ; 0018       C2 17 00
                CPI     00h             ; 001B       FE 00
                JNZ     PT1             ; 001D       C2 16 00
                RET                     ; 0020       C9

