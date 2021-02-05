#include <stdio.h>

void main()
{
	int x, y, result;
	x = 2;
	y = 8;
	result = power(x,y);
	printf("The result is: %d\n",result);
}

int power(int x, int y)
{
	int res;

	res = 1;

	while(y > 0)
	{
		res = res * x;
		y--;
	}
	return(res);
}
