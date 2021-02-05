#include <stdio.h> 
#include <stdlib.h>  

int var1 = 42;
int var2 = -1;  


int main() { 
 int A[10], i;  
 int * p; /* p is a scalar variable that points to an int */  
 for (i = 0; i < 10; i++){   
 	A[i] = i;  
 }  
 for(i = 0; i < 10; i++)
  {   
  	printf("Element A[%d] = %d is stored in address : %x\n", i, A[i], &A[i]);  
  }  
 p = & var1;
 printf("Var addresses(hex): %x %x %x # p = %x, *p = %d\n", &var1, &var2, &p, p, *p); 
 printf("Var values 1: %d %d hex: %x %x\n", var1, var2, var1, var2);
 *p = 0xffff; 
 printf("Var values 2: %d %d hex: %x %x\n", var1, var2, var1, var2);
 *(p+1) = 1500; 
 printf("Var values 3: %d %d hex: %x %x\n", var1, var2, var1, var2);
 return 0;
} 
