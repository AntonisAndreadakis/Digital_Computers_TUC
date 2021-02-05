#include <stdio.h>

void main()
{
	int n, count, i, result;

	n = 1000;
	count  = 0;

	for(i = 1; i <= n; i++)
	{
		result = primes(i);
		if(result == 1)
			count++;
	}
	printf("Between 1 and %d found %d primes\n", n, count);
}

int primes(int num)
{
	int i, prime;

	prime = 1;

	for(i = 2; i < num; i++)
	{
		if(num % i == 0)
		{
			prime = 0;
			break;
		}
	}
	if(prime == 0)
	{
		return(0);
	}
	else
	{
		return(1);
	}
}