#include <stdio.h>
#include <stdlib.h>

char temp[100];
void printLabyrinth(void);
int makeMove(int user_index);
void leep(int time);


char userInput;
int PlayerPos;
int W = 21;
int H = 11;
int startX = 1;
int TotalElements = 231;
char map[232] = "I.IIIIIIIIIIIIIIIIIII"
                "I....I....I.......I.I"
                "III.IIIII.I.I.III.I.I"
                "I.I.....I..I..I.....I"
                "I.I.III.II...II.I.III"
                "I...I...III.I...I...I"
                "IIIII.IIIII.III.III.I"
                "I.............I.I...I"
                "IIIIIIIIIIIIIII.I.III"
                "@...............I..II"
                "IIIIIIIIIIIIIIIIIIIII";

int main(){
    int choice;
    int index = startX;
    printf("HELLO !!! \nWelcome to my game!  \n");
    printf("Would you like to play?     \n");
    do {
        printf("->Press 1 for YES \n");
        printf("->Press 2 for NO \n");
        printf("==> Your choice: ");
        scanf("%d", &choice);
        if (choice == 2)
        {
            printf("\nGoodbye... :( \n");
            return 0;
        }
        else if (choice == 1)
        {
            printf("\nWELCOME AGAIN. \nLet's start ! \n");
            printf("\n");
            printf("-You have 4 eligible moves!- \n");
            printf("•PRESS -W- TO MOVE UP. \n");
            printf("•PRESS -S- TO MOVE DOWN. \n");
            printf("•PREES -A- TO MOVE LEFT. \n");
            printf("•PRESS -D- TO MOVE RIGHT. \n");
            printf("•PRESS -E- TO SHOW SOLUTION. \n");
            printf("\n");
            while (index!='@')
            {
                if(index<0 || index >= TotalElements)
                    return 0;
                
                PlayerPos = index;
                printLabyrinth();
                printf("Give me your move: ");
                scanf("%s", &userInput);
                
                if(map[index] != '@')
                {
                    
                    if (userInput == 'W')
                    {
                        if(map[index-W] == 'I')
                        {
                            printf("==>INELIGIBLE MOVE!\n==>TRY AGAIN !!! \n");
                        }
                        else {
                            map[index]='*';
                            index = index-W;
                            if(map[index] == '@')
                            {
                                map[index] = '%';
                                printLabyrinth();
                                printf("\nWINNER WINNER CHICKEN DINNER\n");
                                return 0;
                            }else
                            {
                                map[index]='P';
                            }
                            printLabyrinth();
                        }
                    }
                    
                    if (userInput == 'S')
                    {
                        if (map[index+W] == 'I')
                        {
                            printf("\n==>INELIGIBLE MOVE!\n==>TRY AGAIN !!! \n");
                            
                        } else {
                            map[index]='*';
                            index = index+W;
                            if(map[index] == '@')
                            {
                                map[index] = '%';
                                printLabyrinth();
                                printf("\nWINNER WINNER CHICKEN DINNER\n");
                                return 0;
                            }else
                            {
                                map[index]='P';
                            }
                            printLabyrinth();
                        }
                    }
                    
                    if (userInput == 'A')
                    {
                        if (map[index-1] == 'I')
                        {
                            printf("\n==>INELIGIBLE MOVE! \n==>TRY AGAIN !!! \n");
                        } else {
                            map[index]='*';
                            index = index-1;
                            if(map[index] == '@')
                            {
                                map[index] = '%';
                                printLabyrinth();
                                printf("\nWINNER WINNER CHICKEN DINNER\n");
                                return 0;
                            }else
                            {
                                map[index]='P';
                            }
                            printLabyrinth();
                        }
                    }
                    
                    if (userInput == 'D')
                    {
                        if (map[index+1] == 'I')
                        {
                            printf("\n==>INELIGIBLE MOVE! \n==>TRY AGAIN !!! \n");
                        } else {
                            map[index]='*';
                            index = index+1;
                            if(map[index] == '@')
                            {
                                map[index] = '%';
                                printLabyrinth();
                                printf("\nWINNER WINNER CHICKEN DINNER\n");
                                return 0;
                            }else
                            {
                                map[index]='P';
                            }
                            printLabyrinth();
                        }
                    }
                    if (userInput == 'E')
                    {
                        index = startX;
                        makeMove(index);
                        printLabyrinth();
                        printf("Pitty you have given up. It was very easy... \n");
                        return 0;
                    }
                }
            }
            
            
        }
    }while (choice!=1 || choice != 2);
    
    return 0;
    
}
void printLabyrinth(void)
{
    int i, j, k=0;
    leep(20000000);
    printf("Labyrinth: \n");
    for (i=0; i<H; i++)
    {
        for (j=0; j<W; j++)
        {
            if(k == PlayerPos)
                temp[j] = 'P';
            else
            {
                temp[j]=map[k];
            }
            k++;
        }
        temp[j+1]='\0';
        printf("%s\n", temp);
    }
    printf("\n");
}


int makeMove(int user_index)
{
    
    if(user_index<0 || user_index>=TotalElements)
    {
        return 0;
    }
    
    if(map[user_index] == '.')
    {   map[user_index] ='*';
        
        printLabyrinth();
        if(makeMove(user_index+1)== 1)
        {
            map[user_index]='#';
            return 1;
        }
        if(makeMove(user_index+W)==1)
        {   map[user_index]='#';
            return 1;
        }
        if(makeMove(user_index-1) == 1)
        {
            map[user_index]='#';
            return 1;
        }
        if(makeMove(user_index-W)==1)
        {
            map[user_index]='#';
            return 1;
        }
    }
    else if (map[user_index] =='@')
    {   map[user_index] = '%';
        
        return 1;
    }
    
    return 0;
}


void leep(int time)
{
    int i;
    for(i=0;i<time;i++)
    {
    }
}



