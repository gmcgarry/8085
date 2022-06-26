; Play notes on buzzer conntected to 8155 timer.
CLK     EQU     3686400
SYSCLK  EQU     CLK/2
A4      EQU     (SYSCLK / 440 / 256)
CS      EQU     20H
TMRLO   EQU     24H
TMRHI   EQU     25H

	ORG	8000H
BEEP:
        MVI     A,A4
noteon:
        ORI     40H     ; wave
        OUT     TMRHI
        XRA     A
        OUT     TMRLO
        MVI     A,0C0H  ; start timer
        OUT     CS
delay:
        MVI     A,02Fh
        MVI     B,0FFh
1:      DCR     A
2:      DCR     B
        JNZ     2b
        CPI     00h
        JNZ     1b
noteoff:
	MVI	A,40H	; disable timer
	OUT	CS

MONITR	EQU	018AH
	JMP	MONITR

	RET
