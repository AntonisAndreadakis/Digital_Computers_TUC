#include <stdio.h>

void primes(int num);

int R0 = 0;
int R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16,R17,R18,R19,R20,R21,R22,R23,R24,R25,R26,R27,R28,R29,R30,R31;
void main()
{
	int n,count,i,result;

	R1 = 1000;
	n = R1;

	R2 = 0;
	count = R2;

	R5 = 1;
	
	R3 = 1;
	i = R3;

for_loop:

	if(R3 > R1) goto after_for;

	primes(R3);
	result = R4;
	if(R4 != R5) goto after_if;
	R2 = R2 + 1;

after_if:

	R3 = R3 + 1; 
	goto for_loop;

after_for:

	printf("Between 1 and %d found %d primes\n", R1, R2);
}

void primes(int num)
{
	int i, prime;

	R6 = 2;
	i = R6;

	R7 = 1;
	prime = R7;

for_loop2:

	if(R6 >= R3) goto after_for_loop2;
	R8 = R3 % R6;

	if(R8 != R0) goto after_if2;
	R7 = 0;
	goto after_for_loop2;

after_if2:
	R6 = R6 + 1;
	goto for_loop2;

after_for_loop2:

	if(R7 != R0) goto after_if3;
	R4 = 0;
	return;

after_if3:
	R4 = 1;
	return;
}
