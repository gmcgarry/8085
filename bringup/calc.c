/* calculate number of T-cycles for bit-banging over SOD/SID

#include <stdio.h>

int
main()
{
	static const int rates[] = { 300, 1200, 2400, 9600, 19200, 38400 };
	static const int clocks[] = { 3686400/2, 3686400, 4000000, 6144000, 3686400*2, 8000000 };

#define NCLOCKS	(sizeof(clocks)/sizeof(clocks[0]))
#define NRATES	(sizeof(rates)/sizeof(rates[0]))
#define EXTRA	17

	printf("\t");
	for (int j = 0; j < NRATES; j++)
		printf("\t%d", rates[j]);
	printf("\n");

	for (int i = 0; i < NCLOCKS; i++) {
		int CLK = clocks[i];
		printf("%d\t:", CLK);
		for (int j = 0; j < NRATES; j++) {
			int RATE = rates[j];
			float BITTIME = (((float)CLK / (float)RATE / 2.0f) - 79.0f - EXTRA) / 24.0f;
			printf("\t%.2f", BITTIME);
		}
		printf("\n");
	}

	return 0;
}
