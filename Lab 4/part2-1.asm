		.data
ftemp:		.asciz "Give F temp:"
ctemp: 		.asciz "C temp:"
ktemp: 		.asciz "F temp:" 
convert: 	.float 273.15
		.text

main:
	li	a7,4			#system call for print string
	la	a0,ftemp
	ecall
	li	a7,5			#system call for reading int
	ecall
	
	add	ft0, zero, fa0	#save to f0
	
	jal converter		#call function converter
	
	#C
	li	a7,4			#system call for print string
	la	a0,ctemp
	ecall
	
	fsw    	fa1,ctemp,t0    # save f10 to Val2
	li	a7,2			#system call for printing float fa0 in ascii
	ecall
	
	#K
	li	a7,4			#system call for print string
	la	a0,ktemp
	ecall
	
	fsw    	fa2, ktemp, t0    # save f10 to Val2
	li	a7,2			#system call for printing float fa0 in ascii
	ecall
	
	j END
converter:
	li	ft1,5.0
	li	ft2,9.0
	li	ft3,32.0
	
	div	ft1,ft1,ft2 	#t4 = 5/9
	sub	ft3,ft0,ft3	#t6=ftemp - 32
	mul	fa1,ft1,ft3	#a1 = ctemp
	
	flw    	ft4,convert, t0     # ft4 = 273.15	
	add	fa2,fa1,ft4	#ctemp+ 273.15
	
	ret

END:
	li  a7, 10 			# call code for terminate
    	ecall 				# system call
