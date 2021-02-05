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

void menuPrint();
void createList();
void insertNodeList();
void deleteNodeList();
void printNode();
void printNumOfNodes();
void printSpecialNode();
void printAddressList();
void printMinValue();
void printAll(struct list *head,int i);


int R0=0,R1,R2,R3,R4=0,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16;
int R17,R18,R19,R20,R21=1,R22,R23,R24,R25,R26,R27,R28,R29,R30,R31;

static jmp_buf buf;

int main(void){
	int ch;
	short v;

	void(*foo)(void);
    foo=&menuPrint;
    void(*foo1)(void);
    foo1=&createList;
    void(*foo2)(void);
    foo2=&insertNodeList;
    void(*foo3)(void);
    foo3=&deleteNodeList;
    void(*foo4)(void);
    foo4=&printNode;
    void(*foo5)(void);
    foo5=&printNumOfNodes;
    void(*foo6)(void);
    foo6=&printSpecialNode;
    void(*foo7)(void);
 	foo7=&printAddressList;
 	void(*foo8)(void);
 	foo8=&printMinValue;

    do_label:

		R15=(int)foo;
    	jal(R15);
    	if(R2 != 1) goto else_label_1;
    		printf("\nGive the number of nodes that you want: ");
    		scanf("%d",&ch);
    		R7 = ch;
    		R16=(int)foo1;
    		jal(R16);
    		printf("\n\n----PrintAll funcion----\n\n");
    		printAll((struct list*)R4,1);
    		printf("\n----PrintAll funcion----\n\n");

		goto after_cond;
		else_label_1:
		if(R2 != 2) goto else_label_2;
			printf("Give value: ");
        	scanf("%hd",&v);
        	R6 = (int)v;
        	printf("Give ID: ");
        	scanf("%d",&R5);
        	R17=(int)foo2;
        	jal(R17);
			printf("\n\n----PrintAll funcion----\n\n");
        	printAll((struct list*)R4,1);
        	printf("\n----PrintAll funcion----\n\n");
        	goto after_cond;
    	else_label_2:
    	if(R2 != 3) goto else_label_3;
    		R20=(int)foo5;
    		jal(R20);
    		R18 = (int)foo3;
    		jal(R18);
    		printf("\n\n----PrintAll funcion----\n\n");
    		printAll((struct list*)R4,1);
    		printf("\n----PrintAll funcion----\n\n");
    	goto after_cond;
    	else_label_3:
    	if(R2 != 4) goto else_label_4;
    		R19=(int)foo4;
    		jal(R19);
    		goto after_cond;
    	else_label_4:
    			if(R2 !=5)goto else_label_5;
    			R20=(int)foo5;
    			jal(R20);
    			printf("\nThe number of nodes is: %d\n",R2);
    		goto after_cond;
    		else_label_5:
    	if(R2 != 6) goto else_label_6;
    		R21=(int)foo6;
    		jal(R21);
    		goto after_cond;
    		else_label_6:
    	if(R2 != 7) goto else_label_7;
    		R22=(int)foo7;
    		jal(R22);
    		goto after_cond;
    		else_label_7:
    		if(R2 != 8) goto after_cond;
    		R24=(int)foo8;
    		jal(R24);
    		goto after_cond;
    	after_cond:
		if(R2 == 9) goto after_loop;
    goto do_label;
    after_loop:
    system("pause");
    printf("\n\n\n\n------------------Bye!----------------\n\n");
    return 0;
}


void menuPrint(){
	int R8;
	printf("-----------------Menu-----------------\n\n");
	printf("\nType (1) to create list\n");
	printf("Type (2) to insert a node\n");
	printf("Type (3) to delete the last node\n");
	printf("Type (4) to print special item\n");
	printf("Type (5) to print the number of items\n");
	printf("Type (6) to print the address of special item section\n");
	printf("Type (7) to print the address of list\n");
	printf("Type (8) to print the minimum value of all nodes\n");
	printf("Type (9) to exit\nYour choice: ");
	scanf("%d",&R8);
	printf("\n-----------------Menu-----------------\n\n");
	R2 = R8;
	JR31;
}

void createList(){
	 R22 = 0;
	 while_label_1:
	 	if(R22 >= R7) goto after_loop_1;

			printf("\nInsert node %d of %d\n",R22+1,R7);
	 		struct list *node, *returnValue;
   			struct list *node2;
   			R20 = (int)node;

			node2=(struct list*)R4;

			printf("Give value: ");
    		scanf("%hd",&R6);
    		printf("Give ID: ");
			scanf("%d",&R5);

			R20 = (int)malloc(sizeof(struct list));

   			((struct list*)R20)->value = R6;
  			((struct list*)R20)->id = R5;
   			((struct list*)R20)->next = NULL;


   			if(R4 != (int)NULL) goto after_cond;
   				R4 = R20;
   				R21 = R20;
   				((struct list*)R21)->next = NULL;
	 			R22 = R22 + 1;
				goto while_label_1;

   			after_cond:

   			while_label:
			if(((struct list*)R21)->next == NULL) goto after_loop;
        		R21 = (int)((struct list*)R21)->next;

        	goto while_label;
    		after_loop:

   			((struct list*)R21)->next = (struct list*)R20;

   	 R22 = R22 + 1;
   	 goto while_label_1;
	 after_loop_1:
	 R2 = R4;
	 JR31;

}

void insertNodeList(){
   struct list *node, *returnValue;
   struct list *node2;

   R20 = (int)node;
   R21 = (int)node2;

   node2=(struct list*)R4;
   R21 = (int)node2;

   R20 = (int)malloc(sizeof(struct list));

   ((struct list*)R20)->value = R6;
   ((struct list*)R20)->id = R5;
   ((struct list*)R20)->next = NULL;


   if(R4 != (int)NULL) goto after_cond;
     returnValue = (struct list*)R20;
     R4 = R20;
	 R2 = R4;
     JR31;
   after_cond:

   while_label:
	if(((struct list*)R21)->next == NULL) goto after_loop;
        R21 = (int)((struct list*)R21)->next;
        goto while_label;
    after_loop:

   ((struct list*)R21)->next = (struct list*)R20;
   R2 = R4;
   JR31;
 }

void deleteNodeList(){
	R21 = R4;
	R22 = R28; // Register 28 has the num of nodes from the return value of "printNumOfNodes" function
	
	if(R4 != (int)NULL) goto after_condit;
		printf("\n----Empty List!----\n");
		R2 = R4;
		JR31;
	after_condit:
	
	if(R22 != 1) goto after_cond;
		R4 = (int)NULL;
		printf("\n----Empty List!----\n");
		R2 = R4;
		JR31;
	after_cond:
    
    
	if(!(R22 >= 2)) goto after_if;
		while_label:
		if(((struct list *)R21)->next->next == NULL)goto after_loop;
    		R21 = (int)((struct list*)R21)->next;
		goto while_label;
		after_loop:
    
		free(((struct list*)R21)->next);
    	((struct list*)R21)->next = NULL;
	after_if:
        
    R2 = R4;   
	JR31;
	
}
	
void printNode(){

	struct list *node;
	node = (struct list*)R4;
	R24 = (int)node;
	printf("Give ID: ");
	scanf("%d",&R23);
	R22 = 0;
	while_label:
	if(((struct list*)R24) == NULL) goto after_loop;
		if(R23 != ((struct list*)R24)->id) goto after_cond;
			printf("\nNode info:\nValue: %d\nID: %d\n\n",((struct list*)R24)->value,((struct list*)R24)->id);
			R22 = 1;
		after_cond:
		R24 = (int)((struct list*)R24)->next;
	goto while_label;
	after_loop:
	if(R22 == 1) goto after_if;
		printf("This node does not exist!\n");
	after_if:
	JR31;
}



void printNumOfNodes(){
	R22 = R4;
	R28=0;

	while_label:
		if((struct list *)R22 == NULL)goto after_loop;
			R28=R28+1;
			R22=(int)((struct list*)R22)->next;
		goto while_label;
	after_loop:
	R2=R28; //num of nodes
	JR31;
}

void printSpecialNode(){
	struct list* node;
	char ch;
    node = (struct list*)R4;
    R22  = (int)node;
	R27 = (short)R24;
	printf("Value or ID?[v-i]: ");
	scanf("\n%c",&ch);
	R26 = (int)ch;

		if((char)R26 != 'i')goto else_label;
			printf("Give id: ");
			scanf("%d",&R25);
			while_label_1:
                if((struct list*)R22 == NULL) goto after_loop_1;
                    if(((struct list*)R22)->id != R25) goto after_cond_1;
                		printf("\nNode info: \n");
                		printf("ID: %d\n",((struct list*)R22)->id);
						printf("Value: %d\n",((struct list*)R22)->value);
                    	printf("ID address: %x\n",&((struct list*)R22)->id);
						printf("Value address: %x\n",&((struct list*)R22)->value);
					after_cond_1:
					R22 = (int)((struct list*)R22)->next;
			goto while_label_1;
        	after_loop_1:
			goto after_cond;
			else_label:
			if ((char)R26 != 'v') goto after_cond;
				printf("Give value: ");
				scanf("%d",&R27);
				while_label_2:
                if(((struct list*)R22) == NULL) goto after_loop_2;
					if(((struct list*)R22)->value != R27) goto after_cond_2;
						printf("\nNode info: \n");
						printf("Value: %d\n",((struct list*)R22)->value);
                		printf("ID: %d\n",((struct list*)R22)->id);
                		printf("Value address: %x\n",&((struct list*)R22)->value);
						printf("ID address: %x\n",&((struct list*)R22)->id);
			after_cond_2:
			R22 = (int)((struct list*)R22)->next;

		goto while_label_2;
        after_loop_2:
        after_cond:
        R4 = R22;
        R2 = R4;
        JR31;
}

void printAddressList() {                          
	struct list* node;
	node=(struct list*)R4;
	printf("Address of list: %x\n",R4);
	 R2 = R4;
         JR31;
}
void printMinValue(){
	struct list *temp;
        R23 = R4;
        R28=1000;
        while_label_1:
        if(!(((struct list*)R23) != NULL)) goto after_loop_1;
			if(!(((struct list*)R23)->value < R28)) goto after_if;
				R28 = (int)((struct list*)R23)->value;
				R27 = (int)((struct list*)R23)->id;
			after_if:
			R23 = (int)((struct list*)R23)->next;
		goto while_label_1;
		after_loop_1:

		R23 = (int)(struct list*)R4;

		while_label_2:
		if(((struct list*)R23) == NULL) goto after_loop_2;
			if(R27 !=  ((struct list*)R23)->id) goto after_cond;
				printf("\n\nMinimum Value: %d\n",R28);
				printf("Node %d Info:\n",R27);
				printf("Value: %d \nID: %d\n", ((struct list*)R23)->value, ((struct list*)R23)->id);
			after_cond:
	 	R23 = (int)((struct list*)R23)->next;
		goto while_label_2;
		after_loop_2:
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

