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
int printNumOfNodes(struct list *head);
void printAddressNode(struct list *head);
void printAddressList(struct list * head);
void printSpecialNode(struct list* head);
void printSizeList(int help,struct list* head);
void printSizeNode();
void printFunctionAddress();
void printAll(struct list *head,int i);

int main(void){

	struct list *node = NULL;
	int choice;
    int num;
    int i,j=0,b;
    short v;
    
    int(*foo)(void);
    foo=&menuPrint;
    
    struct list* (*foo1)(void);
    foo1=&createList;
    
    struct list* (*foo2)(int,short,struct list**);
    foo2=&insertNodeList;
    
    struct list* (*foo3)(struct list**);
    foo3=&deleteNodeList;
    
    void(*foo4)(struct list*);
    foo4=&printNode;
    
    int(*foo5)(struct list*);
    foo5=&printNumOfNodes;
    
    void(*foo6)(struct list*);
    foo6=&printAddressNode;
    
    void(*foo7)(struct list*);
    foo7=&printAddressList;
    
    void(*foo8)(struct list*);
    foo8=&printSpecialNode;
    
    void(*foo9)(int,struct list*);
    foo9=&printSizeList;
    
    void(*foo10)();
    foo10=&printSizeNode;
    
    void(*foo11)();
    foo11=&printFunctionAddress;
    
    void(*foo12)(struct list*,int);
    foo12=&printAll;
    
    do{
    	choice = foo();
    	if(choice == 1){
    		node = foo1();
    	}
    	else if(choice == 2){
    		printf("Give value\n->");
        	scanf("%d",&v);
        	printf("Give ID\n->");
        	scanf("%d",&i);
        	foo2(i,v,&node);
    	 	foo12(node,1);
    	}
		else if(choice == 3){
			foo3(&node);
			foo12(node,1);
		}
		else if(choice == 4){
			foo4(node);
		}
		else if(choice == 5){
			b = foo5(node);
			printf("The number of nodes is %d\n",b);
		}
		else if(choice == 6){
			foo6(node);
		}
		else if(choice == 7){
			foo7(node);
		}
		else if(choice == 8){
			foo8(node);
		}
		else if(choice == 9){
			b = foo5(node);
			foo9(b,node);
		}
		else if(choice == 10){
			foo10();
		}
		else if(choice == 11){
			foo11();
		}
		}while(choice != 12);

    system("pause");
	return 0;
}

int menuPrint(){
	int ch;
	
	printf("\n\n\nType (1) to create list\n");
	printf("Type (2) to insert a node\n");
	printf("Type (3) to delete the 1st node\n");
	printf("Type (4) to print special item\n");
	printf("Type (5) to print the number of items\n");
	printf("Type (6) to print special address of item\n");
	printf("Type (7) to print the address of list\n");
	printf("Type (8) to print the address of special item section\n");
	printf("Type (9) to print the size of list\n");
	printf("Type (10) to print the size of item\n");
	printf("Type (11) to print the addresses of functions\n");
	printf("Type (12) to exit\nYour choice: ");

	scanf("%d",&ch);

	return ch;
}

struct list *createList(){													//1
	 struct list *node = NULL;
	 return node;
}

struct list *insertNodeList(int i,short val, struct list **head){			//2

   struct list *node;
   struct list **node2 = head;
   node = (struct list *)malloc(sizeof(struct list));
   node->value = val;
   node->id = i;
   node->next = NULL;

   while (*node2 != NULL){

		node2 = &((**node2).next);
   }

   *node2 = node;
	return *head;
}

struct list * deleteNodeList(struct list **head) {					//3

  if (*head != NULL){
    *head = (*head)->next;
  }
  else{
  	printf("Empty List!\n");
  	return;
  }
  return *head;
}

void printNode(struct list *head){									//4

	struct list* node = head;
	int s;
	printf("Give node\n->");
	scanf("%d",&s);
	int i=0,flag = 0;
	while(i<s && node->next != NULL){
		if((i == (s-1)) && (node != NULL)){
			printf("Node info:\n\nValue: %d\nID: %d\n",node->value,node->id);
			flag = 1;
		}
		i++;
		node = node->next;
	}
	if(flag == 0){
		printf("This node does not exist\n");
	}
	return;
}

int printNumOfNodes(struct list *head){								//5
	struct list* node = head;
	int i=0;
	while(node != NULL){
		i++;
		node = node->next;
	}
	return i;
}

void printAddressNode(struct list *head){							//6

	struct list* node = head;
	int s;
	printf("Give node\n");
	scanf("%d",&s);
	int i=0;
	while(i<s){
		if((i == (s-1)) && (node != NULL)){
			printf("Node info:\nValue: %d\nID: %d\n",node->value,node->id);
			printf("Addresses:\nValue: %x\nID: %x\n",&node->value,&node->id);
			i++;
		}
		node = node->next;
	}
	return;
}

void printAddressList(struct list * head){                           //7
	struct list* node = head;
	printf("Address of list: %x\n",head);
}

void printSpecialNode(struct list* head){							//8
	struct list* node = head;
	int s1;
	char ch;
	short s2;

	printf("Value or ID?(v-i)\n");
	scanf("\n%c",&ch);
	if(ch == 'i'){
		printf("Give id\n");
		scanf("%d",&s1);
		while(node != NULL){
			if(node->id == s1){
				printf("ID address: %x\n",&node->id);
			}
			node = node->next;
		}
	}
	else if (ch == 'v'){
		printf("Give value\n");
		scanf("%d",&s2);
		while(node != NULL){
			if(node->value == s2){
				printf("Value address: %x\n",&node->value);
			}
			node = node->next;
		}
	}
	return;
}

void printSizeList(int help,struct list* head){        	//9
struct list* node=head;
struct list *temp=head;
struct list *temp2;
int first,last,sizel;
	if(help == 0 || help == 1){
		printf("Size of list: %d bytes\n",2*sizeof(struct list));
	}
	else{
		first = (int)(node);
		last = (int)(node->next);
		printf("Size of list: %d\n",help*(last-first));

	}
}

void printSizeNode(){														//10
	printf("Size of node: %d\n",sizeof(struct list));
}

void printFunctionAddress(){
	printf("Function addresses:\n\n______________\n\n");
	printf("CreateList: %x\n",createList);
	printf("InsertNodeList: %x\n",insertNodeList);
	printf("DeleteNodeList: %x\n",deleteNodeList);
	printf("PrintNode: %x\n",printNode);
	printf("PrintNumOfNodes: %x\n",printNumOfNodes);
	printf("PrintAddressNode: %x\n",printAddressNode);
	printf("PrintAddressList: %x\n",printAddressList);
	printf("PrintSpecialNode: %x\n",printSpecialNode);
	printf("PrintSizeList: %x\n",printSizeList);
	printf("PrintSizeNode: %x\n",printSizeNode);
	printf("PrintFunctionAddress: %x\n",printFunctionAddress);
	printf("PrintAll: %x\n______________",printAll);
	return;
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
