	.data
A: 		.word 0,0,0,0,0		#create array A
B: 		.word 1,2,4,8,16	#create B = [1,2,4,8,16]
iterator: 	.word 0			#i
size: 		.word 5			#size
	.text
main:
	la x10, A			#load address of A	
    	la x11, B			#load address of B
    	lw x12, iterator		#load i
    	lw x13, size			#load size

while:    
    	beq x12, x13, next		#if i = 5, branch to next, else, do following commands
    	slli x14, x12, 2		
    	add x16, x14, zero
    	add x14, x14, x11		#B[i]
    	lw x15, 0(x14)			#load B[i] into x15
    	addi x15, x15, -1		#B[i] - 1
    	add x16, x16, x10		# get A[i] = B[i] - 1
    	sw x15, 0(x16)			#store value A[i] back to memory
    	addi x12, x12, 1			#i++
    	j while
    
next: 
	addi x12, x12, -1			#i--
	li t0, -1
	la x10, A			#load address of A
	la x11, B			#load address of B
loop:
	beq x12, t0, Exit 		#if i = -1, branch to exit
    	slli x14, x12, 2  		# = i*4	
    	add x16, x14, zero  		# x16 = x14
    	add x14, x14, x11 		# address of B + (i*4) gives the address of B[i]
    	lw x15, 0(x14) 			# put b[i] into x15
    	add x16, x16, x10 		#x16 gets address of a[i]
    	lw x17, 0(x16) 			# x17 gets a[i]
    	add x15, x15, x17 		#A[i] + B[i]
    	add x15, x15, x15 		#(A[i] + B[i])*2
    	sw x15, 0(x16) 			#put x15 into a[i]
    	addi x12, x12, -1		#i--
    	j loop
    
Exit:
        li a7,10      		#system call for an exit
    	ecall

