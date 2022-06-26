XTAL: 3.6864MHz -> 1.8432MHz clock
19200bps -> 96 Tcycles

XTAL: 6.144MHz -> 3.067MHz clock -> 50*24+10+10+10 T states
19200bps -> 160 Tcycles
2400 baud -> 1280 Tcycles


MON85:

uses 96 bytes @2000H, in the 8155 RAM.

Seems to work okay, but doesn't work well with the bit banging serial
port.  Transferring too quickly will break, and the LOAD function checks
for timeouts by looking for keypresses (which doesn't work with bit-banged I/O).

Otherwise, it's a good monitor.  Might be worth changing the LOAD code,
or adding a real 8251 serial port.  There might be a simpler monitor that
doesn't include a debugger.

To load;

- ensure .screenrc contains 'defslowpaste 1'
- build with start address at 8000H


M5M6242B:

i think that the port mapping isn't going to work.  The port address
appears on both ADDRLO and ADDRHI when the address is put on the bus.  Since
the MSM6242 using 4-bits for register addressing, there is only 4-bit available
for chip select.

8155:

I/O base address: 20H

0: C/S		: control: TCMD1 TCMD2 IEB IEA MODE1 MODE2 PBdir PAdir
		: status:  NA/A  IFT   IEB FEB IFB   IEA   FEA   IFA
1: PORT A	:
2: PORT B	:
3: PORT C	:
4: TMR LO	: <8-bit low>
5: TMR HI	: TMOD1 TMOD2 <6-bit high>

TCMD1/TCMD2: 00=N/A, 01=STOP, 10=STOP after timeout, 11=load & start
MODE1/MODE2: 00=C inputs, 01=C outputs, 10=PortA control/PortB outputs, 11=PortA/PortB control
TMOD1 TMOD2: 00=low on second half of timer, 01=continuous square wave, 10=one-shot pulse, 11=continuous pulse

Pxdir: direction: 0=input, 1=output
IEx : interrupt enable (PortA/PortB)
FEx : full/empty status (PortA/PortB)
IFx : interrupt flag (Timer/PortA/PortB)

defaults:
	C/S: 80h = inputs, not interrupts, timer stopped
	PORT A: FFh
	PORT B: FFh
	PORT C: FFh
	TMR LO: 00h
	TMR HI: 40h

output on port A
	out 20 81
	out 21 55

start continuous timer:
	out 24 ff
	out 25 7F
	out 20 C0
