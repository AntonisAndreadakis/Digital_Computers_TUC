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
void printSizeList(int help);
void printSizeNode();
void printAll(struct list *head,int i);

int main(void){
    
	struct list *node = NULL;
	int choice;
    int num;
    int i,j=0,b;
    short v;
    
    do{
    	choice = menuPrint();
    	if(choice == 1){
    		node = createList();
    	}
    	else if(choice == 2){
    		printf("Give value\n");
        	scanf("%d",&v);
        	printf("Give ID\n");
        	scanf("%d",&i);
        	insertNodeList(i,v,&node);
    	 	printAll(node,1);
    	}
		else if(choice == 3){
			deleteNodeList(&node);
			printAll(node,1);
		}
		else if(choice == 4){
			printNode(node);
		}
		else if(choice == 5){
			b = printNumOfNodes(node);
			printf("The number of nodes is %d\n",b);
		}
		else if(choice == 6){
			printAddressNode(node);
		}
		else if(choice == 7){
			printAddressList(node);
		}
		else if(choice == 8){
			printSpecialNode(node);
		}
		else if(choice == 9){
			b = printNumOfNodes(node);
			printSizeList(b);
		}
		else if(choice == 10){
			printSizeNode();
		}
		}while(choice != 11);   
    

    system("PAUSE");
	return 0;
}

int menuPrint(){
	int ch;
	printf("\n\n\n\nCreate List (1)\n");
	printf("Insert a node (2)\n");
	printf("Delete the 1st node (3)\n");
	printf("Print special item (4)\n");
	printf("Print the number of items (5)\n");
	printf("Print special address of item (6)\n");
	printf("Print the address of list (7)\n");
	printf("Print the address of special item section (8)\n");
	printf("Print the size of list (9)\n");
	printf("Print the size of item (10)\n");
	printf("Exit (11)\n");
	scanf("%d",&ch);
	return ch;
}

struct list * createList(){
	 struct list *node = NULL;
	 return node;
}

struct list *insertNodeList(int i,short val, struct list **head){
   
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

struct list * deleteNodeList(struct list **head) {
  
  if (*head != NULL){
    *head = (*head)->next;
  }
  else{
  	printf("Empty List!\n");
  	return;
  }
  return *head;
}

void printNode(struct list *head){
	
	struct list* node = head;
	int s;
	printf("Give node\n");
	scanf("%d",&s);
	int i=0;
	while(i<s){
		if((i == (s-1)) && (node != NULL)){
			printf("Node info:\n\nValue: %d\nID: %d\n",node->value,node->id);
		}
		i++;
		node = node->next;
	}
	return;
}

int printNumOfNodes(struct list *head){
	struct list* node = head;
	int i=0;
	while(node != NULL){
		i++;
		node = node->next;
	}
	return i;
}

void printAddressNode(struct list *head){
	
	struct list* node = head;
	int s;
	printf("Give node\n");
	scanf("%d",&s);
	int i=0;
	while(i<s){
		if((i == (s-1)) && (node != NULL)){
			printf("Node info:\n\nValue: %d\nID: %d\n",node->value,node->id);
			printf("Addresses:\nValue: %d\nID: %d\n",&node->value,&node->id);
			i++;
		}
		node = node->next;
	}
	return;
}

void printAddressList(struct list * head){
	struct list* node = head;
	printf("Address of list: %d\n",&head);
}

void printSpecialNode(struct list* head){
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
				printf("ID address: %d\n",&node->id);
			}
			node = node->next;
		}
	}
	else if (ch == 'v'){
		printf("Give value\n");
		scanf("%d",&s2);
		while(node != NULL){
			if(node->value == s2){
				printf("Value address: %d\n",&node->value);
			}
			node = node->next;
		}
	}
	return;
}

void printSizeList(int help){
	if(help == 0){
		printf("Size of list: %d\n",sizeof(struct list));
	}
	else{
	printf("Size of list: %d\n",help*sizeof(struct list));
	}
}

void printSizeNode(){
	printf("Size of list: %d\n",sizeof(struct list));
}

void printAll(struct list *head,int i){
	if(head == NULL){
		return;
	}
	else {
		printf("Node %d:\n",i);
		printf("Value: %d\nID: %d\n\n\n",head->value,head->id);
		printAll(head->next,i+1);
	}
	return;
}
