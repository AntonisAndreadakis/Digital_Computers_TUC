#include <stdio.h>
#include <stdlib.h> 


int main() { 


 int A[10],i; 
 
 for (i = 0; i < 10; i++){
    A[i] = i;
 }   
  
  printf("\nA: %d",A);
  printf("\nA: %x",A);
  
  printf("\n\nA+1: %d",A+1);
  printf("\nA+1: %x",A+1);
  
  
  printf("\n\n(((int)A)+1): %d",((int)A)+1);
  printf("\n(((int)A)+1): %x",((int)A+1));
   
  printf("\n\n&A[1]: %d",&A[1]);
  printf("\n&A[1]: %x",&A[1]);
  
  printf("\n\nsizeof(A): %d",sizeof(A));
  printf("\nsizeof(A[1]): %d",sizeof(A[0]));
  
  return 0;
}
