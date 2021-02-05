## int Fibonacci(int n){
##	if(n<2)
##		return n;
##	else
##		return Fibonacci(n-1) + Fibonacci(n-2);
##}
.data
.globl main
bye: .asciiz "\nBye"
.text
main:
jal Fibonacci
li $v0, 4              # print string of terminated program 
la $a0, bye 
syscall
li  $v0, 10            # syscall to exit of program
syscall

Fibonacci:

# Prologos - Save
addi $sp, $sp, -4	          # swse ton $s0 sth stack
sw   $s0, ($sp)
addi $sp, $sp, -4	          # swse ton $ra sth stack
sw   $ra, ($sp)
  
# Kyrio Meros - Swma synarthshs
slti $t0, $a0, 2		      # if (a0<2) $t0=1;
beq  $t0, $zero, else_label   # if ($t0==0) goto else_label
add $v0, $a0, $zero 		  # epistrefw ton $a0
lw $ra, ($sp)			      # fortwnw ton $ra apo th stack
addi $sp, $sp, 4
lw $s0, ($sp)			      # fortwnw ton $s0 apo th stack
addi $sp, $sp, 4
jr $ra				          # epistrefw
else_label:
add $s0, $a0, $zero		      # krataw ton a0 se saved register
addi $a0, $a0, -1		      # etoimazw thn Fibonacci(n-1)
jal Fibonacci
add $t1, $v0, $zero		      # bazw thn timh epistrofhs ston $t1
addi $sp, $sp, -4		      # swse ton $t1 sth stack

addi $a0, $s0, -2		      # etoimazw thn Fibonacci(n-2)
jal Fibonacci

# Epilogos - Restore
lw $t1, ($sp)			      # fortwnw ton $t1 apo th stack
addi $sp, $sp, 4
add $v0, $v0, $t1		      # kanw thn pros8esh kai apo8hkeyw ws timh epistrofhs
lw $ra, ($sp)			      # fortwnw ton $ra apo th stack
addi $sp, $sp, 4
lw $s0, ($sp)			      # fortwnw ton $s0 apo th stack
addi $sp, $sp, 4
jr $ra				          # epistrefw