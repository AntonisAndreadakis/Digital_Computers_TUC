.data
.globl main
.globl printmenu
.globl createArray
.globl insertArray
.globl deleteLast
.globl printItem
.globl numOfItems
.globl printAddressItem
.globl printArrayAddress
.globl printMinValue
.globl mergeSort

                        # Messages
menu_print:   .asciiz "\n\nType (1) to create the array\nType (2) to insert an item to array\nType (3) to delete the last item of array\nType (4) to print special item\nType (5) to print the number of items\nType (6) to print the address of special item\nType (7) to print the address of array\nType (8) to print the minimum value of all items of array\nType (9) to sort the array\nType (10) to exit\n"       
askint:       .asciiz "\nPlease type your choice: "
askid:        .asciiz "\nGive id: "
askvalue:     .asciiz "\nGive value: "
bye:          .asciiz "\nProgram terminated. Bye!"
emptyarr:     .asciiz "\n----Empty Array----\n"
size:         .asciiz "\nGive the number of items: "
printinfo:    .asciiz "\nNode info: \n"
valueinfo:    .asciiz "\nValue: "
idinfo:       .asciiz " ->ID: "
errornode:    .asciiz "\nThis node does not exist!\n"
idaddress:    .asciiz "\nID address: "
valueaddress: .asciiz "\nValue address: "
arrayaddress: .asciiz "\nAddress of array: "
minvalue:     .asciiz "\nMinimum value: "
number:       .asciiz "\nThe number of items is: "
node:         .asciiz "\nGive the item that you want: "
newline:      .asciiz "\n"
beforesort:   .asciiz "\nArray before sort: \n"
aftersort:    .asciiz "\nArray after sort: \n"
array: .align 2
	   .space 800      # space for 100 nodes
	
mergeArray: .align 2
			.space 400 # mergeArray is the array which we have the sorted elements

.text

main:

la $s1, array          # $s1 is head of the array
la $s7, mergeArray     # $s7 is head of mergeArray
li $s5,10              # $s5 is exit register
li $s6, 0              # initialization of $s6 which is the counter of nodes
move $t1, $s1

loop:

li $s4,1

jal printmenu

move $s0, $v0

case_1:                # case if choice is 1

bne $s0,$s4,case_2

li $v0, 4              # print how items want             
la $a0, size
syscall

li $v0,5
syscall

move $s6, $v0		   # $s6 has the number of items
move $a3, $s6		   # counter as argument to $a3
move $a0, $s1		   # head array as argument to $a1

jal createArray

move $s6, $v0
move $a0, $s1

jal printall

j loop

case_2:                # case if choice is  2

addi $s4,$s4,1

bne $s0,$s4,case_3

li $v0, 4              # message to read value
la $a0, askvalue
syscall

li $v0, 5              # read value
syscall
move $s2, $v0	       # move value to $s2

li $v0, 4              # message to read id
la $a0, askid
syscall

li $v0, 5              # read id
syscall
move $s3, $v0		   # move id to $s3

move $a0, $s1	       # head array as argument to $a0
move $a1, $s2		   # value as argument to $a1
move $a2, $s3	       # ID as argument to $a2
move $a3, $s6		   # counter as argument to $a3

jal insertArray

move $s6, $v0

li  $v0, 1             # print integer
move $a0, $s6
syscall 

li  $v0, 4             # print new line
la  $a0, newline  
syscall

move $a0, $s1          # head array as argument to $a0
move $a3, $s6		   # counter as argument to $a3
jal printall

li  $v0, 4             # print new line
la  $a0, newline  
syscall

j loop

case_3:                # case if choice is 3

addi $s4,$s4,1

bne $s0,$s4,case_4

move $a0, $s1

move $a3, $s6

jal deleteLast

move $s6,$v0

move $a0, $s1          # head array as argument to $a0
move $a3, $s6		   # counter as argument to $a3

jal printall

j loop

case_4:                # case if choice is 4

addi $s4,$s4,1

bne $s0,$s4,case_5

move $a0,$s1

jal printItem

j loop

case_5:                # case if choice is 5

addi $s4,$s4,1

bne $s0,$s4,case_6

move $a3, $s6		   # counter as argument to $a3

jal numOfItems

j loop

case_6:                # case if choice is 6

addi $s4,$s4,1

bne $s0,$s4,case_7

move $a0,$s1

jal printAddressItem

j loop

case_7:                # case if choice is 7

addi $s4,$s4,1
bne $s0,$s4,case_8

move $a0, $s1

jal printArrayAddress

j loop

case_8:                # case if choice is 8

addi $s4,$s4,1
bne $s0,$s4,case_9

move $a0, $s1
move $a3, $s6

jal printMinValue


j loop

case_9:                # case if choice is 9 

addi $s4,$s4,1
bne $s0,$s4,case_10

li $t0, 0
li $t2, 0
li $t3, 0
move $t1, $s1
move $t7, $s7

while_loop_9:
bge $t0, $s6 , after_while_9

lw $t2, 0($t1)
move $t3, $t2
sw $t3, 0($t7)

addi $t0, $t0, 1
addi $t1, $t1, 8
addi $t7, $t7,4

j while_loop_9

after_while_9:

li  $v0, 4             # print message
la  $a0, beforesort  
syscall

move $a0, $s7          # head array as argument to $a0
move $a3, $s6		   # counter as argument to $a3
jal printall_2

move $a0, $s7          # head mergeArray as argument to $a0
addi $t6, $s6,-1
move $a1, $t6		   # num of elements as argument to $a1

jal mergeSort

li  $v0, 4             # print message
la  $a0, aftersort  
syscall

move $a0, $s7          # head array as argument to $a0
move $a3, $s6		   # counter as argument to $a3
jal printall_2


case_10:               # case 10 is the jump to loop label

li  $v0, 4             # print new line
la  $a0, newline  
syscall
bne $s0, $s5,loop      # loop condition 

li  $v0, 4             # print new line
la  $a0, newline  
syscall


li $v0, 4              # print string of terminated program 
la $a0, bye 
syscall

li  $v0, 10            # syscall to exit of program
syscall

################################################################

printmenu:             # menu function

li $v0, 4              # print menu string
la $a0, menu_print
syscall

li  $v0, 4             # print new line
la  $a0, newline  
syscall

li $v0, 4              # print string 
la $a0, askint 
syscall

li  $v0, 5             # read choice
syscall


move $a0,$v0			
move $v0,$a0           	
jr $ra				   # return to main

###############################################################

createArray:

move $t6, $a3          # choice
move $t1, $a0		   # head
li $t5,0               # counter


loop_1:

bge $t5,$t6,after_loop_1
li $v0,4
la $a0,askvalue        # print message  to ask value
syscall

li $v0,5               # read value
syscall
               
move $t9, $v0

srl $t8, $t9, 4		   # $t8 holds the top byte
andi $t9, $t9, 0x000F  # $t9 hold the bottom byte
sb $t8, 0($t1)         # Store the bytes in the memory in the correct order
sb $t9, 1($t1)
lb $t4,0($t1)	       # $t4 holds the top byte
lb $t2,1($t1)	       # $t2 holds the bottom byte
sll $t4, $t4, 4
or $t2, $t4, $t2


sh $t2,0($t1)          # move value to t2

li $v0,4
la $a0,askid           # print message ask id
syscall

li $v0,5               # read id
syscall

                      
move $t3, $v0          # move id to $t3
sw $t3,4($t1)

addi $t5,$t5,1         # counter of nodes
addi $t1,$t1,8         # move head address

bne $t5,$t6,loop_1

after_loop_1:


move $v0, $t6

jr $ra

###################################################################

insertArray:

move $t1, $a0			# $t1 has the head of array
move $t2, $a1			# $t2 has the value
move $t3, $a2			# $t3 has the ID
move $t6, $a3			# $t6 has the number of elements


li $t4,0				# $t4 is a help counter to the next while loop

while_label:            # the perpose of this loop is to go the head to the last element

bge $t4, $t6, after_loop

add $t1, $t1, 8		    # move head to the next cellar
addi $t4, $t4, 1		# add 1 to counter

j while_label

after_loop:

sh $t2, 0($t1)			# store the value and the ID
sw $t3, 4($t1)

addi $t6, $t6, 1		# add 1 to the number of nodes

move $v0, $t6			# return value is the number of nodes

jr $ra

############################################################################

numOfItems:

move $t6,$a3

li $v0, 4               # print the arrat's size   
la $a0, number
syscall

li  $v0, 1              # print integer
move $a0, $t6
syscall 

jr $ra

#############################################################################

printItem:

move $t1,$a0            # head

li $t5,1                # counter
li $t8,0                # boolean flag

li $v0,4
la $a0,node             # print message ask node
syscall

li $v0,5                # read id
syscall

move $t4, $v0          

loop_2:

beq $t5,$t4,after_loop_2
   
addi $t1,$t1,8

addi $t5,$t5,1
   
j loop_2
  
after_loop_2: 

lw $t2,0($t1)
lw $t3,4($t1)

addi $t8,$t8,1

li $v0,4
la $a0,valueinfo       # print message 
syscall
  
li  $v0, 1             # print integer
move $a0, $t2
syscall 
   
li $v0,4
la $a0,idinfo          # print message 
syscall
   
li  $v0, 1             # print integer
move $a0, $t3
syscall 
 
bne $t8,$zero,after_if

li $v0,4
la $a0,errornode       # print message 
syscall

after_if:
jr $ra
   

############################################################################   
   
printAddressItem:

move $t1,$a0             # head

li $t5,1                 # counter
li $t8,0                 # boolean flag

li $v0,4
la $a0,node              # print message ask node
syscall

li $v0,5                 # read id
syscall

move $t4, $v0          

loop_3:

beq $t5,$t4,after_loop_3  
   
addi $t1,$t1,8
addi $t5,$t5,1
   
j loop_3
  
after_loop_3: 

addi $t8,$t8,1

li $v0,4
la $a0,valueaddress    # print message 
syscall
  
li  $v0, 1             # print integer
move $a0,$t1
syscall 
  
addi $t1,$t1,4 
   
li $v0,4
la $a0,idaddress       # print message 
syscall
   
li  $v0, 1             # print integer
move $a0, $t1
syscall 
 
bne $t8,$zero,after_if_3
   
li $v0,4
la $a0,errornode       # print message 
syscall


after_if_3:
jr $ra
   
###############################################################

deleteLast:

move $t1,$a0

move $t6,$a3

li $t5,0                  # help counter

bne $t6, $zero, after_cond_del     # case if array is empty

li  $v0, 4                # print new line
la  $a0, newline  
syscall

li $v0, 4                 # print string when array is empty
la $a0, emptyarr
syscall

move $v0, $t6

jr $ra

after_cond_del:

loop_4:

beq $t5,$t6,after_loop_4  # the purpose of this loop is to reach to the next of the last item

addi $t1,$t1,8
addi $t5,$t5,1

j loop_4

after_loop_4:
addi $t6,$t6,-1			  # add -1 to the number of items
move $s6,$t6

lw $t2,-8($t1)
lw $t3,-4($t1)

move $t2,$zero
move $t3,$zero

sw $t2,-8($t1)
sw $t3,-4($t1)

move $v0, $t6

jr $ra

###############################################################

printArrayAddress:

move $t1, $a0

li  $v0, 4              # print new line
la  $a0, newline  
syscall

li $v0, 4               # print message
la $a0, arrayaddress 
syscall

li  $v0, 1              # print array address
move $a0, $t1
syscall

li  $v0, 4              # print new line
la  $a0, newline  
syscall

jr $ra

#############################################################

printMinValue:

move $t1, $a0
move $t6, $a3

move $t5,$zero          # help counter

li $t4, 100             # $t4 holds the minimum value

while_label_min:

bge $t5, $t6, after_loop_min

lw $t2, 0($t1)          # load the value

li  $v0, 4              # print new line
la  $a0, newline  
syscall

bge $t2,$t4,after_cond_min

move $t4, $t2           # update minimum value

after_cond_min:

addi $t5, $t5, 1        # add 1 to help counter
addi $t1, $t1, 8        # add 8 to head address

j while_label_min

after_loop_min:

li $v0, 4               # print message
la $a0, minvalue 
syscall

li $v0, 1
move $a0, $t4           # print minimum value
syscall

jr $ra

#####################################################

mergeSort:
# Save arguments and return address to stack , push
addi $sp, $sp, -16
sw $ra, 8($sp)         # save $ra 
sw $a1, 4($sp)	       # save $a1 (num of elements) 
sw $a0, 0($sp)	       # save $a0 (head of array) 

slti $t0,$a1,2         # If the length is less than 2 return;
beq $t0,$zero, L1
add $v0, $a0,$zero
addi $sp, $sp, 16
jr $ra

L1: 
sra $a1, $a1, 1
jal mergeSort          # Mergesort the left part of the array
lw $t0, 4($sp)
lw $a0, 0($sp)
sw $a1, 12($sp)
sub $t0, $t0, $a1      # Calculate the length of the right part
sll $a1, $a1, 2
add $a0, $a0, $a1      # Calculate the address of the starting point
add $a1,$t0, $zero     # of the right part of the array

jal mergeSort          # Mergesort the right part of the array

add $a2, $a0 , $zero   # The merge function accepts as inputs
add $a3, $a1 , $zero   # a0 = address of the starting point of the left part
lw $a0, 0($sp)         # a2 = address of the starting point of the right part
lw $a1, 12($sp)        # a1/a3 = length of the left/right part of the array
jal merge

# Restore arguments and return address from stack , pop
lw $a0, 0($sp)         # restore $a0 (head of array) 
lw $a1, 4($sp)         # restore $a1 (num of elements) 
lw $ra, 8($sp)		   # restore $ra 
addi $sp, $sp, 16
jr $ra 



#####################################################
merge:

# Save arguments and return address to stack , push
addi $sp, $sp, -12
sw $s4, 8($sp)
sw $s3, 4($sp)
sw $s0, 0($sp)

add $s0, $a0, $zero   # move arguments to callee save registers
add $s3, $a2, $zero
add $s4, $a1, $a3

lop: 

lw $t0, 0($s0)
lw $t1, 0($s1)
slt $t2, $t0, $t1     # Check if start1 <= start2
beq $t2,$zero, L2
addi $a1, $a1, -1     # start1 < start2 so move to next number of the left array
blez $a1, exit        # if there are no numbers left, exit
addi $s0, $s0,-4  

b lop
L2: 
addi $t3, $s1, 4      # start1 > start2 so move all the numbers until start2

L3: 
lw $t4, 0($t3)        # one position to the right and then replace start1
sw $t4, 4($t3)        # start2 and move to compare the next numbers
addi $t3, $t3, -4  
slt $t5, $t3, $s0
beq $t5, $zero, L3
sw $t1, 0($s0)
addi $s0, $s0, 4
addi $a3, $a3, -1
blez $a3, exit        # if there are no numbers left in the right array, exit
addi $s1, $s1, 4

b lop

# Restore arguments and return address from stack , pop
exit: 

lw $s0, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
addi $sp, $sp, 12
jr $ra 

################################################

printall:
move $t1,$a0
move $t6,$a3
li $t7,0

loop_5:
beq $t7,$t6,after_loop_5
lw $t2,0($t1)
lw $t3,4($t1)
   
li $v0,4
la $a0,valueinfo       # print message 
syscall
  
li  $v0, 1             # print integer
move $a0, $t2
syscall 

li $v0,4
la $a0,idinfo          # print message 
syscall
   
li  $v0, 1             # print integer
move $a0, $t3
syscall 
   
add $t1,$t1,8
addi $t7,$t7,1

j loop_5

after_loop_5:

jr $ra

################################################

printall_2:
move $t1,$a0
move $t6,$a3
li $t7,0

loop_51:
beq $t7,$t6,after_loop_51
lw $t2,0($t1)

   
li $v0,4
la $a0,valueinfo       # print message 
syscall
  
li  $v0, 1             # print integer
move $a0, $t2
syscall 
   
add $t1,$t1,4
addi $t7,$t7,1

j loop_51

after_loop_51:

jr $ra