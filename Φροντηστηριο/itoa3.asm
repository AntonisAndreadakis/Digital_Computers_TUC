#######################################################################
#                                                                     #
# File Name: itoa.asm		                                        #
# Description: This program takes a number from the user and convert  #
#              into an ASCII string.                                  #
# Errors: none                                                        #
# Date: 2/10/2003                                                     #
# Authors: Sotiriadis Euripidis - Vernardos George                    #
#                                                                     #
#######################################################################

#################################################
#					 	            #
#		text segment			      #
#						            #
#################################################	
	.text
	.globl main	   # main must be global
main:	
	#***************  Print the first prompt to console ******************* 
	la  $a0,firstNum   # load the addr of first message into a0
	li  $v0,4	       # 4 is the print_string syscall
	syscall		 # do the syscall
	#**********************************************************************
	
	#************ Get the number from the user, put into $t0 **************
	li  $v0,5	       # 5 is the read_integer syscall
	syscall		 # do the syscall
	move $a0,$v0	 # move the number read into $t0
	#**********************************************************************
	la  $a1,string	 # load the address of string into a1	
itoa:
	move $t0,$a0	 # move the number into t0	
	move $t3,$a1	 # move the address of string into t3
	bgez $a0,nonNeg	 # if number is positive goto label
	sub  $a0,$0,$a0	 # else calculate the absolute value	
nonNeg:
	li  $t2,10	       # load the value 10 into t2
itoaLoop:
	div $a0,$t2	       # do the division 
	mfhi $t1	       # move the quotient into t1 
	mflo $a0	       # move the reminder into a0
	addi $t1,$t1,48    # do the addition
	sb  $t1,0($a1)     # store the number
	add $a1,$a1,1      # increase pointer
	bnez $a0,itoaLoop  # if (reminder !=0) do the loop again
	bgez $t0,nonNeg2   # check the sign, if positive goto label
	li  $t1,'-'        # load the negative sign
	sb  $t1,0($a1)     # store the sign
	addi $a1,$a1,1     # increase pointer	
nonNeg2:
	sb  $0,0($a1)      # store the "\n"
	move $a0,$t3       # prepare to do the reversion
reverse:
	addi $t2,$a0,-1    # j=s-1
	lbu  $t3,1($t2)    # while ( *(j+1) )
	beqz $t3,endStrlen
strlenLoop:
	addi $t2,$t2,1	 # j++	
	lbu  $t3,1($t2)
	bnez $t3,strlenLoop
endStrlen:		       # now j = &s[ strlen(s)-1 ]
	bge  $a0,$t2,endReverse # while ( i<j )
reverseLoop:                  # {
	lbu  $t3,($a0)          #    $t3=*i
	lbu  $t4,($t2)		#    $t4=*j	
	sb   $t3,($t2)	      #    *i=$t4
	sb   $t4,($a0)          #    *j=$t3
	addi $a0,$a0,1          #     i++
	addi $t2,$t2,-1         #     j--
	blt  $a0,$t2,reverseLoop
endReverse:
	#***************  Print the result prompt to console ******************* 
      la  $a0,result     # load the addr of result into a0
	li  $v0,4	       # 4 is the print_string syscall
	syscall		 # do the syscall
	#**********************************************************************
	
	#***************  Print the string to console ******************* 
      la  $a0,string     # load the addr of first message into a0
	li  $v0,4	       # 4 is the print_string syscall
	syscall		 # do the syscall
	#**********************************************************************

exit:	
	#*****************  Terminate the programm ****************************** 
	li   $v0,10	   # 10 is the exit syscall
	syscall	   # do the syscall
	#*****************  Exit the programm *********************************** 

#################################################
#                                               #
#               data segment                    #
#                                               #
#################################################
	 .data
firstNum: .asciiz "Give the number N:>"    # prompt 
result:   .asciiz "The string is  "
string:   .space 128
# End of file itoa.asm