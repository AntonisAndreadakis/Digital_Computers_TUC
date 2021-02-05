#include <stdio.h>
#include <stdlib.h>

struct list {
  short  value;
  int id;
  struct list *next;
};

int menuPrint();
struct list * createList(struct list **head,int n);
struct list *insertNodeList(int i,short val, struct list **head);
struct list *deleteNodeList(struct list **head,int ret);
void printNode(struct list *head);
int printNumOfNodes(struct list *head);
void printAddressList(struct list * head);
void printSpecialNode(struct list* head);
void printMinValue(struct list * head);
void printAll(struct list *head,int i);

int main(void){
    
	struct list *node = NULL;
	int choice,ch;
    int num;
    int i,j=0,b;
    short v;
    
   
    
    do{
    	choice = menuPrint();
    	if(choice == 1){
    		printf("Give the number of nodes that you want: ");
    		scanf("%d",&ch);
    		node = createList(&node,ch);
    		printAll(node,1);
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
			int rV;
			rV = printNumOfNodes(node);
			deleteNodeList(&node,rV);
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
			printSpecialNode(node);
		}
		else if(choice == 7){
			printAddressList(node);
		}
		else if(choice == 8){
			printMinValue(node);
		}
	}while(choice != 9);   
    

    //system("pause");
	return 0;
}

int menuPrint(){
	int ch;
	printf("\nType (1) to create list\n");
	printf("Type (2) to insert a node\n");
	printf("Type (3) to delete the last node\n");
	printf("Type (4) to print special item\n");
	printf("Type (5) to print the number of items\n");
	printf("Type (6) to print the address of special item section\n");
	printf("Type (7) to print the address of list\n");
	printf("Type (8) to print the minimum value of all nodes\n");
	printf("Type (9) to exit\nYour choice: ");
	scanf("%d",&ch);
	return ch;
}

struct list * createList(struct list **head,int n){						 //  erwthma 1 se clang
	int j,i;
	short v;
	for(j=0; j<n; j++){
		printf("\nNode: %d of %d\n",j+1,n);
		struct list *node;
		struct list **node2 = head;
		printf("Give value\n");
    	scanf("%hd",&v);
    	printf("Give ID\n");
		scanf("%d",&i);
	
   		node = (struct list *)malloc(sizeof(struct list));
  		node->value = v;
   		node->id = i;
   		node->next = NULL;

   		while (*node2 != NULL){
    	
			node2 = &((**node2).next);
   		}
   
   		*node2 = node;
	}
	
	return *head;
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

struct list * deleteNodeList(struct list **head,int ret) {          //  erwthma 3 se clang
	struct list **node2 = head; 
  	while ((*node2 != NULL) && ((**node2).id != ret))
    node2 = &((*node2)->next); 
  	if (*node2 != NULL){
  		*node2 = (*node2)->next;
  	} 
	else{
		printf("\n----Empty List!----\n");
  		return NULL;
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

void printAddressList(struct list * head){
	struct list* node = head;
	printf("Address of list: %d\n",&head);
}

void printMinValue(struct list *head){
	struct list *temp = head;
	int min = 1000,iD;
	while(temp != NULL){
		if(temp->value < min){
			min = temp->value;
			iD = temp->id;
		}
	temp = temp->next;
	}
	temp = head;
	while(temp != NULL){
		if(iD == temp->id){
			printf("\n\nMinimum Value: %d\n",min);
			printf("Node %d Info:\n",iD);
			printf("Value: %d \nID: %d\n",temp->value,temp->id);
		}
	temp = temp->next;
	}
	
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
