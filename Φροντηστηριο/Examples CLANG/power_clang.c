#include <stdio.h>

int R0 = 0;
int R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16,R17,R18,R19,R20,R21,R22,R23,R24,R25,R26,R27,R28,R29,R30,R31;

void power(int x, int y);
void main()
{
	int x,y,result;

	R1 = 2;
	R2 = 8;
	x = R1;
	y = R2;
	power(R1, R2);

	result = R4;

	printf("The result is : %d\n", result);
}

void power(int x, int y)
{
	int res;

	R4 = 1;
	res = R4;

while_loop: 
	
	if(R2 <= R0) goto end_loop;
	R4 = R4 * R1;
	R2 = R2 - 1;
	goto while_loop;

end_loop:

	res = R4;
	return;
}
