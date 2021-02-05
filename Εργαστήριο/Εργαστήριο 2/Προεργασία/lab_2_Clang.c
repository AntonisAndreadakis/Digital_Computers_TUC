#include <stdio.h>
#include <stdlib.h>

struct list {
  short  value;
  int id;
  struct list *next;
};

int menuPrint();
struct list * createList();
struct list *insertNodeList(int i,short val, struct list **head);
struct list *deleteNodeList(struct list **head);
void printNode(struct list *head);
void printAll(struct list *head,int i);

int main(void){
	struct list *node = NULL;
	int choice;
    int num;
    int i,j=0,b;
    short v;
    
	struct list * R1;
    R1 = NULL;
    int R0;
    R0 = 0;
    int R2,R3,R4,R5,R6;
    R5 = 0;
    short R7;
    
    do_label:
    	R2 = menuPrint();
    	if(R2 != 1) goto else_label_1;
    		R1 = createList();
		goto after_cond;
		else_label_1:
		if(R2 != 2) goto else_label_2;
			printf("Give value\n");
        	scanf("%d",&R7);
        	v = R7;
        	printf("Give ID\n");
        	scanf("%d",&R4);
        	i = R4;
        	insertNodeList(R4,R7,&R1);
        	printAll(R1,1);
    	goto after_cond;
    	else_label_2:
    	if(R2 != 3) goto else_label_3;
    		deleteNodeList(&R1);
    		printAll(R1,1);
    	goto after_cond;
    	else_label_3:
    	if(R2 != 4) goto after_cond;
    		printNode(R1);
    	after_cond:
		if(R2 == 5) goto after_loop;
    goto do_label;
    after_loop:
    
    system("pause");
    return 0;
}

int menuPrint(){
	int R8;
	int ch;
	printf("\n\n\nCreate List (1)\n");
	printf("Insert a node (2)\n");
	printf("Delete the 1st node (3)\n");
	printf("Print special item (4)\n");
	printf("Exit (5)\n");
	scanf("%d",&R8);
	ch = R8;
	return ch;
}

struct list * createList(){
	 struct list *R1 = NULL;
	 return R1;
}

struct list *insertNodeList(int R4,short R7, struct list **R1){
   struct list *node;
   struct list **node2;
   node2 = R1;
   struct list *R9,**R10;
   R9 = node;
   R10 = node2;
   
   
   R9 = (struct list *)malloc(sizeof(struct list));
   R9->value = R7;
   R9->id = R4;
   R9->next = NULL;

   while_label: 
   if(!(*R10 != NULL)) goto after_loop;
    	R10 = &((**R10).next);
   goto while_label;
   after_loop:
   
   *R10 = R9;
   
	return *R10;
}

struct list * deleteNodeList(struct list **R1) {
  
  if (*R1 == NULL) goto else_label;
    *R1= (*R1)->next;
  goto after_cond;
  else_label:
  	printf("Empty List!\n");
  	return;
  after_cond:
  return *R1;
}

void printNode(struct list *R1){
	
	struct list * R11;
	R11 = R1;
	int R10;
	int s;
	printf("Give id\n");
	scanf("%d",&R10);
	while_label:
	if(!(R11 != NULL)) goto after_loop;
		if(!(R11->id == R10)) goto after_cond;
			printf("Node info:\n\nValue: %d\nID: %d\n",R11->value,R11->id);
		after_cond:
		R11 = R11->next;
	goto while_label;
	after_loop:
	s = R10;
	return;
}

void printAll(struct list *R1,int R12){
	struct list * R13;
	R13 = R1;
	if(!(R13 == NULL)) goto else_label;
		return;
	goto after_cond;
	else_label:
		printf("Node %d:\n",R12);
		printf("Value: %d\nID: %d\n\n\n",R13->value,R13->id);
		printAll(R13->next,R12+1);
	after_cond:
	return;
}
