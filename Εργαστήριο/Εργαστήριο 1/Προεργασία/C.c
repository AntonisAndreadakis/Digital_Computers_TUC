#include <stdio.h>
#include <stdlib.h>  
struct A {
 	char X;
 	int C;
 	char Y;
};
struct B{
 	char X;
 	char Y;
 	int C;
};
int main() { 
printf("\n%d",sizeof(struct A));
printf("\n%d",sizeof(struct B));
return 0;
}
