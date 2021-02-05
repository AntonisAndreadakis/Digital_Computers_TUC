#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>

#ifndef JAL
    #define jal(X) if(!setjmp(buf)) goto *X;
#endif
#ifndef JR31
    #define JR31 (longjmp(buf,1))
#endif

struct list {
  short  value;
  int id;
  struct list *next;
};

int menuPrint();
struct list *createList();
struct list *insertNodeList();
struct list *deleteNodeList();
void printNode();
void printAll(struct list *head,int i);

int R0=0,R1,R2,R3,R4=0,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16;
int R17,R18,R19,R20,R21=1,R22,R23,R24,R25,R26,R27,R28,R29,R30,R31;

static jmp_buf buf;
int main(void){
	
	short v;
	
	int(*foo)(void);
    foo=&menuPrint;
    struct list* (*foo1)(void);
    foo1=&createList;
    struct list* (*foo2)(void);
    foo2=&insertNodeList;
    struct list* (*foo3)(void);
    foo3=&deleteNodeList;
    void(*foo4)(void);
    foo4=&printNode;
    
    do_label:
    	
		R15=(int)foo;
    	jal(R15);
    	if(R2 != 1) goto else_label_1;
    		R16=(int)foo1;
    		jal(R16);
    	
		goto after_cond;
		else_label_1:
		if(R2 != 2) goto else_label_2;
			printf("Give value\n->");
        	scanf("%hd",&v);
        	R6 = (int)v;
        	printf("Give ID\n->");
        	scanf("%d",&R5);
        	R17=(int)foo2;
        	jal(R17); 
        	printAll((struct list*)R4,1);
        	goto after_cond;
    	else_label_2:
    	if(R2 != 3) goto else_label_3;
    		R18 = (int)foo3;
    		jal(R18);
    		printAll((struct list*)R4,1);
    	goto after_cond;
    	else_label_3:
    	if(R2 != 4) goto after_cond;
    		R19=(int)foo4;
    		jal(R19);
    	after_cond:
		if(R2 == 5) goto after_loop;
    goto do_label;
    after_loop:
    
   
    return (EXIT_SUCCESS);
}

int menuPrint(){
	int R8;
	printf("\n\nType (1) to create list\n");
	printf("Type (2) to insert a node\n");
	printf("Type (3) to delete the 1st node\n");
	printf("Type (4) to print special item\n");
	printf("Type (5) to exit (5)\nYour choice: ");
	scanf("%d",&R8);
	R2 = R8;
	JR31;
}

struct list * createList(){
	 struct list *node;
	 
	 node = NULL;
	 R4 = (int)(NULL);
	 R2 = R4;
	 JR31;
	 
}

 struct list *insertNodeList(){ 
   struct list *node, *returnValue;
   struct list *node2;
   
   node2=(struct list*)R4;  
   
   node = (struct list *)malloc(sizeof(struct list));
   
   R27 = (int)NULL;
   node->value = R6;
   node->id = R5;
   node->next = NULL;
   
   if(R4 != (int)NULL) goto after_cond;
     returnValue = node;
     R4 = (int)node;
	 R2 = R4;     
     JR31; 
   after_cond:
   
   while_label:
	if(node2->next == NULL) goto after_loop; 
        node2 = node2->next;
        goto while_label;
    after_loop:
   
   node2->next = node;
   R2 = R4;
   JR31;
 }
struct list * deleteNodeList() {
  struct list *node;
  node = (struct list*)R4;
  if (node == NULL) goto else_label;
    node= (node)->next;
  goto after_cond;
  else_label:
  	printf("Empty List!\n");
  	JR31;
  after_cond:
  R4 = (int)node;
  R2 = R4;
  JR31;
}

void printNode(){
	
	struct list *node;
	node = (struct list*)R4;
	int R10,R30=0;
	printf("Give node\n->");
	scanf("%d",&R10);
	R31 = 0;
	while_label:
	if((R30 >= R10) || node->next == NULL) goto after_loop;
		if(!(R30 == (R10-1)) && (node != NULL)) goto after_cond;
			printf("\nNode info:\nValue: %d\nID: %d\n\n",node->value,node->id);
			R31 = 1;
		after_cond:
		R30++;
		node = node->next;
	goto while_label;
	after_loop:
	if(R31 == 1) goto after_if;
		printf("This node does not exist!\n");
	after_if:
	JR31;
}
void printAll(struct list *head,int i){
	if(head == NULL){
		return;
	}
	else {
		printf("Node %d:\n",i);
		printf("Value: %d\nID: %d\n\n",head->value,head->id);
		printAll(head->next,i+1);
	}
	return;
}
