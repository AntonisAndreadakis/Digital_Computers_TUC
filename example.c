#include <stdio.h>

char A[100];

int palindromic(char *);

void main()
{
	int return_value;

	printf("Please enter a string!!\n");
	scanf("%s",&A[0]);
		
	return_value = palindromic(A);
		
	if(return_value == 0)
		printf("No palindromic phrase\n");
	else
		printf("Palindromic phrase\n");
}

int palindromic(char *A)
{
	int i = 0;
	int j = 0;
	int ret_val = 1;
	
	for(i = 0; i < 100; i++)
	{
		if(A[i] == '\0')
			break;
	}
	

	j = i-1;
	i = 0;
	
	while(j > i)
	{
		if(A[i] != A[j] && A[i] != A[j] - 32 && A[j] != A[i] - 32)
		{
			ret_val = 0;
			break;
		}
		else
		{
			i ++;
			j --;
		}
	}
	
	return(ret_val);
}
