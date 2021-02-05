####################################################################
#
#struct node{
#			int x;
#			struct node *next;
#};
# struct node *Start --> $t0 //it keeps the address of the first node 
######################################################################### 
#struct node *ptr = Start;
#while(ptr -> next != NULL)
#{
#	if(ptr -> x > 0)
#		ptr->x = ptr->x + 5;
#	else
#		ptr->x = 0;
#	ptr = ptr -> next;
#}
#########################################################################

move $t1, $t0		#struct node *ptr = Start;
					#$t1 = ptr

loop_while:
			add $t2, $t1, 4			#$t2 = &(ptr -> next)
			lw $t3, 0($t2)			#$t3 = ptr -> next
			beqz $t3, end_loop		#ptr->next != NULL
			
			lw $t4, 0($t1)			#$t4 = ptr -> x
			
			ble $t4, $0, else_label	#if(ptr->x > 0)
			
			addi $t4, $t4, 5		# 
			sw $t4, 0($t1)			# ptr-> x = ptr->x + 5
			
			j end_if
else_label:
			sw $0, 0($t1)			# ptr-> x = 0
			
end_if:
			move $t1, $t3			# ptr = ptr -> next
			
			j loop_while
	
end_loop:

		
			
	
			
			
			