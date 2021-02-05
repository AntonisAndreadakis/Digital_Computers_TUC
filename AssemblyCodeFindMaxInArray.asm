.data
.globl array
.globl Input
.globl mess1
.globl mess2
.globl cont

Input: .asciiz "Give input:"
mess1: .asciiz "Calling function to find maximum...\n"
mess2: .asciiz "Result returned from function:\n"
cont: .asciiz "You want to continue? (1: Y/ 0: N)\n"

array: .align 2
	   .space 100

.text
.globl main
main:

la $s1, array    #s1 is the beginning address of the array
li $s2, 0
move $t1, $s1

input_loop:

li $v0, 4		 #Print message
la $a0, Input
syscall

li $v0, 5		 #Read input
syscall

move $s0, $v0    #s0 is the input

sw $s0, 0($t1)
addi $s2, $s2, 1 #s2 is the counter
addi $t1, $t1, 4 #move head address

li $v0, 4		 #Print continue? message
la $a0, cont
syscall 

li $v0, 5		 #Read answer
syscall

move $s3, $v0	 #Move answer to s3
li $s4, 0
bne $s4, $s3, input_loop	#

move $a0, $s1	#beginning of array as arg
move $a1, $s2	#size of array as arg

jal Maximum

move $s5, $v0	#s5 has the maximum element address

li $v0, 4		#Print message
la $a0, mess2
syscall

li $v0, 1		#Print value of maximum element
lw $a0, 0($s5)
syscall

li $v0, 10
syscall

Maximum:

	move $t1, $a0	#t1 has the beginning of array
	move $t2, $a1	#t2 has the number of elements
	li $t4, 0 		#t4 will hold the maximum element value
	li $t5, 0 		#t5 will hold the maximum element address

maximum_loop:

	lw $t3, 0($t1)	#t3 holds the element

	bgt $t3, $t4, new_max	#if new element is bigger than max branch
	addi $t1, $t1, 4		#address + 4
	addi $t2, $t2, -1		#counter - 1

	bne $t2, $zero, maximum_loop	#if counter != 0 go to loop
	b end_loop						#else go to end_loop

new_max:
	move $t4, $t3			#update max value
	move $t5, $t1			#update max address
	addi $t1, $t1, 4		#address + 4
	addi $t2, $t2, -1		#counter - 1

	bne $t2, $zero, maximum_loop	#if counter != 0 go to loop
	

end_loop:

	move $v0, $t5			#return max address
	jr $ra