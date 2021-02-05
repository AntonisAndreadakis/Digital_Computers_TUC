.data
.globl menu
.globl repint
menu: .asciiz "Type (1) to create list\n        
Type (2) to insert a node\n
Type (3) to delete the 1st node\n
Type (4) to print special item\n
Type (5) to exit\n"
             
bye: .asciiz "Program terminated. Bye!"
askint: .asciiz "Please type your choice: "
repint: .asciiz "Your choice is : "
newline: .asciiz "\n"

.text
.globl main
main:

li $t1, 5                        # initialization exit register

li $v0, 4                         # Print Menu
la $a0, menu
syscall

loop:

li  $v0, 4                        # print new line
la  $a0, newline  
syscall

li $v0, 4                         # print string 
la $a0, askint 
syscall

li  $v0, 5                        # read integer
syscall
add  $t0, $v0,$zero



li $v0, 4                         # print string 
la $a0, repint 
syscall



li  $v0, 1                        # print integer
move $a0, $t0
syscall 

li  $v0, 4                        # print new line
la  $a0, newline  
syscall

bne $t0, $t1,loop                 # loop condition and in case of true goto loop label

                           


li  $v0, 4                        # print new line
la  $a0, newline  
syscall


li $v0, 4                         # print string 
la $a0, bye 
syscall

li  $v0, 10                       #exit of program
syscall


