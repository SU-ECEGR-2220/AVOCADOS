		.data
ftemp:		.asciz "Give F temp:"
ctemp: 		.asciz "C temp:"
ktemp: 		.asciz "\nK temp:" 
convert: 	.float 273.15
num1:		.float 5.0
num2:		.float 9.0
num3:		.float 32.0
		.text

main:
	li	a7,4			#system call for print string
	la	a0,ftemp
	ecall
	li	a7,5			#system call for reading int
	ecall
	
	fmv.s	ft1,f0	#load FP val from memory
	
	jal converter		#call function converter
	
	#C
	li	a7,4			#system call for print string
	la	a0,ctemp
	ecall
	
	fmv.s   fa1,ft6    # save f10 to Val2
	#fmv.x.s	t1, ft6		# copy FP value to t reg
	#fsw	fa1, 0(a0)	#store FP val to memory
	li	a7,2			#system call for printing float fa0 in ascii
	ecall
	
	#K
	li	a7,4			#system call for print string
	la	a0,ktemp
	ecall
	
	fmv.s   fa2,ft9    # save f10 to Val2
	#fmv.x.s	t2, ft9		# copy FP value to t reg
	#fsw	fa2, 0(a0)	#store FP val to memory
	li	a7,2			#system call for printing float fa0 in ascii
	ecall
	
	j END
converter:
	flw	ft2,num1,t0
	flw	ft3,num2,t0
	flw	ft4,num3,t0
	
	fdiv.s	ft2,ft2,ft3 	#t4 = 5/9
	fsub.s	ft4,ft1,ft4	#t6=ftemp - 32
	fmul.s	ft6,ft2,ft4	#a1 = ctemp
	
	flw    	ft8,convert,t0     # ft4 = 273.15	
	fadd.s	ft9,ft6,ft8	#ctemp+ 273.15
	
	ret

END:
	li  a7, 10 			# call code for terminate
    	ecall 				# system call
