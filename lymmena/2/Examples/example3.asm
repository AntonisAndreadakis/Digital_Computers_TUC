########################################################
# EXAMPLE4 : Pseudocode String Convertion
########################################################
#void main()
#{
#	char string[20];
#	char reverse_string[20];
#	int return_value;
#	scanf("%s",string);
#	return_value = reverse(string, reverse_string, 20);
#	printf("%s\n",reverse_string);
#}
#void reverse(char *s, char *r_s, int max_char)
#{
#	int i;
#	char *ptr;
#	char *reverse_ptr;
#	ptr = s;
#	reverse_ptr = r_s;

#	for(i = 0; i < max_char; i++)
#	{
#		if(*ptr == '\n')
#		{
#			while(i > 0)
#			{
#				ptr--;
#				*reverse_ptr = *ptr;	
#				reverse_ptr++;
#				i--;
#			}
#			break;
#		}
#		ptr++;
#	}
#	*reverse_ptr = '\n';
#	return(0);
#}
##########################################################	
	.data
newline: .asciiz "\n"
		.align 2
		
string:
	.space 21	
	.align 2

reverse_string:
	.space 21

	.text	
	.globl main
main:
	
	la $a0, string	#$a0 = &string[0]
	li $v0, 8		#read string
	syscall
	li $a1, 20
	
	jal reverse
	
	la $a0, reverse_string
	li $v0,4
	syscall
	
	li $v0, 10
	syscall
	
reverse:

	move $t0, $a0			#$t0 -> &string[0]
	la $t1, reverse_string	#$t1 -> &reverse_string[0]
	li $t2, 0				#$t2 = i = 0
	move $t3, $a1			#$t3 = max_char
	li $t5, 10				#$t5 = ascii character of newline
	
loop:
	bge $t2,$t3, end_loop   #i < max_char
	
if_label:	
	lb	$t4,0($t0)			#
	bne $t4,$t5,end_if		#*ptr == '\0'

while_loop:	
	ble	$t2,$0, end_while_loop
	addi $t0,$t0,-1
	lb	$t4,0($t0)
	sb	$t4,0($t1)
	addi $t1, $t1, 1
	addi $t2, $t2, -1
	j while_loop

end_while_loop:
	j end_loop	
end_if:
	addi $t0,$t0,1
	addi $t2,$t2,1
	j loop

end_loop:

	sb	$t5,0($t1)	#load the \0 character
	li $v0, 0		#return(0)
	jr $ra			#
	