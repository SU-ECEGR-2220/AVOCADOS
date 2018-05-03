	.data
a: 	.word 10
b1:	.word 15
c: 	.word 6
z: 	.word 0
	.text
    
main:
	lw s0,a			# load A
	lw s1,b1		# load B
	lw s2,c			# load C
	lw s3,z			# load Z
    	li t3,5			
    	li t5,7			
    	
    	slt t0,s0,s1		# check if  A < B, if yes t0 = 1
	beq t0,zero,elseif	# if t0 = 0 --> A not < B, branch to elseif
	
	sgt t0,s2,t3		# check if C > 5, if yes t0 = 1
	beq t0,zero,elseif	# if t0 = 0 --> C not < 5, branch to elseif
	li s3,1			# set Z = 1
	j SWITCH		# branch to SWITCH
    
elseif:	
	sgt t1,s0,s1		# check if A > B, , if yes t1 = 1
	bne t1,zero,Do2		# if yes, branch to Do2
	addi t2,s2,1		# t2 = C + 1
	bne t2,t5,Do3		# branch to Do 3 if C+1 != 7
	j Do2			#if not, branch to Do2
				
Do2:	li s3,2			# Z = 2
	j SWITCH		# branch to SWITCH

Do3:	li s3,3			# Z = 3
	j SWITCH		# branch to SWITCH

SWITCH:	li t4,1			# t4 = 1
	bne s3,t4,case2		# if Z !=1, branch to case 2
	li s3,-1		# Z = -1
	j END			
	
case2:	li t4,2			# t4 = 2
	bne s3,t4,case3		# if Z !=2, branch to case 3
	li s3,-2		# Z = -2
	j END			
	
case3:	addi t4,zero,3		# t4 = 3
	bne s3,t4,default	# if Z !=3, branch to default
	li s3,-3		# Z = -3
	j END			
	
default: li s3,0		# Z = 0
	j END

END:
	sw s0,a,t6		#store word from register back to memory
	sw s1,b1,t6
	sw s2,c,t6
	sw s3,z,t6
	
	li a7,1			# system call code for print_int
	lw a0,z			# print z
	ecall			# print it
	
        li a7,10      		#system call for an exit
    	ecall
