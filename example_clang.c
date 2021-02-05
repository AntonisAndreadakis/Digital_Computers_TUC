#include <stdio.h>
char A[100];
int palindromic(char *);
int R0 = 0;
int t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, a0, v0;

int main()
{
	printf("Please enter a string!!\n");
	scanf("%s",&A[0]);
	
	a0 = (int)&A[0];

	t0 = palindromic(a0);

	if(t0 != 0) goto else_label;
	printf("No palindromic phrase\n");
	goto after_if;
else_label:
	printf("Palindromic\n");
	
after_if:
	
	return(0);
}

int palindromic(char *A)
{
	t1 = 0;	//t1 = i
	t2 = 0;	//t2 = j
	t3 = 1;	//t3 = ret_val

while_loop:
	
	if(t1 >= 100) goto end_while;
	
	if(A[t1] != 0) goto end_if;
	goto end_while;

end_if:
	t1++;
	goto while_loop;	
	
end_while:

	t2 = t1 - 1;
	t1 = 0;
	
while_loop_2:
	
	if(t2 <= t1) goto end_while_loop_2;
	
	t4 = A[t1];
	t5 = A[t2];
	t6 = t5 - 32;
	t7 = t4 - 32;

	if(t4 == t5) goto else_body;
	if(t4 == t6) goto else_body;
	if(t5 == t7) goto else_body;

	t3 = 0;
	goto end_while_loop_2;
	
else_body:
	t1 = t1 + 1;
	t2 = t2 - 1;
	goto while_loop_2;
		
end_while_loop_2:

	v0 = t3;
	return(v0);
}
