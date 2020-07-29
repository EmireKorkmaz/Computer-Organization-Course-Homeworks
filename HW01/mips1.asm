.data   
	
	ff: .asciiz "Enter first number's exponent: "
	fs: .asciiz  "Enter first number's mantissa: "
	op: .asciiz "Enter the operand: "
	sf: .asciiz "Enter second number's exponent: "
	ss: .asciiz  "Enter second number's mantissa: "
	operand: .space 20
	
	test: .asciiz "girdi"
	plus: .asciiz "+"
	minus: .asciiz "-"
	star: .asciiz "*"
	newLine: .asciiz "\n"
	comma: .ascii ","
.text
	.globl main
main:

	li $v0, 4
	la $a0, ff
	syscall
	
	li $v0, 5
	syscall
	move $s3, $v0
	
	li $v0, 4
	la $a0, fs
	syscall
	
	li $v0, 5
	syscall
	move $s5, $v0
	
	li $v0, 4
	la $a0, op
	syscall
	
   	li $v0, 12
    	syscall
    	move $s7, $v0
					
	li $v0, 4
	la $a0, sf
	syscall
	
	li $v0, 5
	syscall
	move $s4, $v0
	
	li $v0, 4
	la $a0, ss
	syscall
	
	li $v0, 5
	syscall
	move $s6, $v0
											
	move $s1, $s3
	move $s2, $s4
	srl $s1, $s1, 31 # birinci sayinin sign i
	srl $s2, $s2, 31 # ikinci sayinin sign i
	
	move $a1, $s5
	jal findDigit

	move $t7, $v1 #birinici sayinin digiti

	move $a1, $s6
	jal findDigit
	move $t6, $v1 #birinici sayinin digiti

	sub $t3, $t7, $t6
	slt $t0, $t3, $zero # if t3 is neg -> t0=1
	beq $t0, $zero, x
	mul $t3, $t3, -1

x:	add $t1, $zero, $zero # counter = 0
	slt $t0, $t7, $t6 # compare digits t7==t6
	bne $t0, $zero, loop1
	beq $t0, $zero, loop2
loop1:	# 1>2
	slt $t0, $t1, $t3 # counter < digit difference between 2 nums
	beq $t0, $zero, cik
	mul $s5, $s5, 10 # sayiyi 10la carp
	addi $t1, $t1, 1 # increment counter
	j loop1
loop2:	# a1<a2
	slt $t0, $t1, $t3
	beq $t0, $zero, cik
	mul $s6, $s6, 10 # sayiyi 10la carp
	addi $t1, $t1, 1 # increment counter
	j loop2
cik:	
	beq $s7, '+', A
	beq $s7, '-', S
	beq $s7, '*', M	
	j exit
A:	beq $s7, $t1, S
	beq $s7, $t2, M	
	addi $a0, $s3, 0
	addi $a1, $s4, 0
	addi $a2, $s5, 0
	addi $a3, $s6, 0
	jal addition
	j exit
S:	
	beq $s7, $t0, A
	beq $s7, $t2, M	
	addi $a0, $s3, 0
	addi $a1, $s4, 0
	addi $a2, $s5, 0
	addi $a3, $s6, 0
	jal subtract
	j exit
	
M:	beq $s7, $t0, A
	beq $s7, $t1, S
	addi $a0, $s3, 0
	addi $a1, $s4, 0
	addi $a2, $s5, 0
	addi $a3, $s6, 0
	jal multiply
	j exit

exit:	li $v0, 10
	syscall
	
findDigit:
	li $t5, 1000000
	addi $v1, $zero, 7 # a1 number of digits
	slt $t0, $a1, $t5
	beq $t0, $zero, jump
	addi $v1, $v1, -1
	div $t5, $t5, 10 #100000
	slt $t0, $a1, $t5
	beq $t0, $zero, jump
	addi $v1, $v1, -1
	div $t5, $t5, 10 # 10000
	slt $t0, $a1, $t5
	beq $t0, $zero, jump
	addi $v1, $v1, -1
	div $t5, $t5, 10 # 1000
	slt $t0, $a1, $t5
	beq $t0, $zero, jump
	addi $v1, $v1, -1
	div $t5, $t5, 10 # 100
	slt $t0, $a1, $t5
	beq $t0, $zero, jump
	addi $v1, $v1, -1	
	div $t5, $t5, 10 # 10
	slt $t0, $a1, $t5
	beq $t0, $zero, jump
	addi $v1, $v1, -1
jump:	jr $ra

addition:
	move $s1, $a0
	move $s2, $a1
	srl $t1, $s1, 31 # birinci sayinin sign i
	srl $t2, $s2, 31 # ikinci sayinin sign i
		
	beq $t1, $t2, ll1
	j ll2	
ll1:	beq $t1, $zero, L2  # eksiyi bastirmak icin
	li $v0, 4
	la $a0, minus
	syscall 
	j L2
	
ll2:	beq $t1, $zero, ll3 # +, -
	sub $t0, $a1, $a0
	sub $t1, $a3, $a2
	
	bgt $t1, $zero, add_sub_print
	beq $t1, $zero, add_sub_print
	mul $t1, $t1, -1
	addi $t0, $t0, -1
	j add_sub_print 
ll3:	add $t0, $a0, $a1
	sub $t1, $a2, $a3

	bgt $t1, $zero, add_sub_print
	beq $t1, $zero, add_sub_print
	mul $t1, $t1, -1
	addi $t0, $t0, -1
add_sub_print:	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 10
	syscall
            
L2:	
	add $s5, $a2, $a3
	li $t5, 1000000
	addi $t4, $zero, 7 # a1 number of digits
	slt $t0, $s5, $t5
	beq $t0, $zero, before
	addi $t4, $t4, -1
	div $t5, $t5, 10 #100000
	slt $t0, $s5, $t5
	beq $t0, $zero, before
	addi $t4, $t4, -1
	div $t5, $t5, 10 # 10000
	slt $t0, $s5, $t5
	beq $t0, $zero, before
	addi $t4, $t4, -1
	div $t5, $t5, 10 # 1000
	slt $t0, $s5, $t5
	beq $t0, $zero, before
	addi $t4, $t4, -1
	div $t5, $t5, 10 # 100
	slt $t0, $s5, $t5
	beq $t0, $zero, before
	addi $t4, $t4, -1	
	div $t5, $t5, 10 # 10
	slt $t0, $s5, $t5
	beq $t0, $zero, before
	addi $t4, $t4, -1
	
before:	
	move $t3, $t4	
	addi $t3, $t3, -2
	addi $t4, $zero, 1
	move $t5, $zero # counter t5 = 0

	
loop3:  bgt $t5, $t3, p
	mul $t4, $t4, 10
	addi $t5, $t5, 1
	j loop3
p:	
	bgt $s5, $t4, q # sagin toplami 1den buyukse
	sub $s5, $s5, $t4
	add $s3, $a0, $a1
	addi $s3, $s3, 1
	j print
q:	add $s3, $a0, $a1 
print:	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	jr $ra		
multiply:
	move $s1, $a0
	move $s2, $a1
	srl $t1, $s1, 31 # birinci sayinin sign i
	srl $t2, $s2, 31 # ikinci sayinin sign i

	beq $t1, $t2, w
	li $v0, 4
	la $a0, minus
	syscall
	
w:	
	li $t5, 1000000
	addi $t1, $zero, 7 # a1 number of digits
	slt $t0, $a2, $t5
	beq $t0, $zero, jump1
	addi $t1, $t1, -1
	div $t5, $t5, 10 #100000
	slt $t0, $a2, $t5
	beq $t0, $zero, jump1
	addi $t1, $t1, -1
	div $t5, $t5, 10 # 10000
	slt $t0, $a2, $t5
	beq $t0, $zero, jump1
	addi $t1, $t1, -1
	div $t5, $t5, 10 # 1000
	slt $t0, $a2, $t5
	beq $t0, $zero, jump1
	addi $t1, $t1, -1
	div $t5, $t5, 10 # 100
	slt $t0, $a2, $t5
	beq $t0, $zero, jump1
	addi $t1, $t1, -1	
	div $t5, $t5, 10 # 10
	slt $t0, $a2, $t5
	beq $t0, $zero, jump1
	addi $t1, $t1, -1

jump1:	
	move $t3, $t1		
	addi $t3, $t3, -1
	addi $t1, $zero, 1
	move $t5, $zero # counter t5 = 0
loop5:  
	bgt $t5, $t3, p1
	mul $t1, $t1, 10
	addi $t5, $t5, 1
	j loop5
	
p1:	mul $s1, $s1, $t1
	add $s1, $s1, $a2
	mul $s2, $s2, $t1
	add $s2, $s2, $a3
	
	mul $s1, $s1, $s2

	div $s3, $s1, $t1
k:	
	li $v0, 1
	move $a0, $s3
	syscall

	mul $s3, $s3, $t1
	sub $s1, $s1, $s3 # s1 ikinci kisim
		
	li $v0, 4
	la $a0, comma
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	
	jr $ra
subtract:
	sub $t0, $a0, $a1
	sub $t1, $a2, $a3

	bgt $t1, $zero, sub_print
	beq $t1, $zero, sub_print
	mul $t1, $t1, -1
	addi $t0, $t0, -1
	

sub_print:	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
quit:	jr $ra
