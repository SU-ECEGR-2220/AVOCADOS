	.data
a: 	.word 0			#int a
b1: 	.word 0			#int b
c: 	.word 0			#int c

	.text
main:
	la a4, a		#give int a a register
	la a5, b1		#give int b a register
	la a6, c		#give int c a register
	
	li t0, 5		#i = 5	
	li t1, 10		#j = 10
	
	addi sp, sp, -8
	mv a2, t0
	sw t0, 0(sp)		#store data from register back to memory
	sw t1, 4(sp)		
	jal AddItUp		#jump to function ADDITUP
	sw a1, 0(a4)		#store data from register back to memory
	lw t0, 0(sp)		#load data from memory to register
	lw t1, 4(sp)		
	mv a2, t1
	jal AddItUp		#jump to function ADDITUP
	sw a1, 0(a5)		#store data from register back to memory
	lw a2, 0(a4)		#load data from memory to register
	add t2, a1, a2		#c=a+b
	sw t2, 0(a6)		#store data from register back to memory
	j Exit			#branch to exit

AddItUp:
	li t0,0 		#x=0
    	li t1,0 		#i=0
    	beq t1,zero,ForLoop 	#branch to loop if i = 0
    
ForLoop:
	add t0,t0,t1 		#x=x+i
    	addi t0,t0,1 		#x=x+i+1
        addi t1,t1,1		#i++
    	blt t1,a2,ForLoop 	#i<n, keep doing loop
    	j Done
Done:
	mv a1,t0		#return x
	ret
	
Exit:	li a7,1			# system call code for print_int
	lw a0,a			# print a
	ecall			# print it
	
	li a7,1			# system call code for print_int
	lw a0,b1		# print b
	ecall			# print it
	
	li a7,1			# system call code for print_int
	lw a0,c			# print c
	ecall			# print it
	
        li a7,10      		#system call for an exit
    	ecall
