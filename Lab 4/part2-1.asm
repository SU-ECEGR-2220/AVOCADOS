		.data
ftemp:		.asciz "Give an Fahrenheit temp:"
ctemp: 		.asciz "Celsius temperature is:"
ktemp: 		.asciz "\nKelvin temperature is:" 
convert: 	.float 273.15
num1:		.float 5.0
num2:		.float 9.0
num3:		.float 32.0
		.text

main:
	li	a7,4			#system call for print string of ftemp
	la	a0,ftemp
	ecall
	li	a7,6			#system call for reading float input
	ecall
	
	fmv.s	ft1,fa0			#ft1 = input
	
	jal converter			#call function converter
	
	#Celcius temperature	
	fmv.s   fa1,ft6    		# save converter's return to fa1
	fmv.s   fa0,fa1			#move fa1 to fa0 to print
	
	li	a7,4			#system call for print string
	la	a0,ctemp
	ecall
	li	a7,2			#system call for printing float fa0 in ascii
	ecall
	
	#Kelvin temperature
	
	fmv.s   fa2,ft9    		# save converter's return to fa2
	fmv.s   fa0,fa2			#move fa2 to fa0 to print
	
	li	a7,4			#system call for print string
	la	a0,ktemp
	ecall
	li	a7,2			#system call for printing float fa0 in ascii
	ecall
	
	j END
converter:
	flw	ft2,num1,t0
	flw	ft3,num2,t0
	flw	ft4,num3,t0
	
	fdiv.s	ft2,ft2,ft3 	#ft2 = 5/9
	fsub.s	ft4,ft1,ft4	#ft4=ftemp - 32
	fmul.s	ft6,ft2,ft4	#a1 = ctemp
	
	flw    	ft8,convert,t0     # ft4 = 273.15	
	fadd.s	ft9,ft6,ft8	#ctemp+ 273.15
	
	ret

END:
	li  a7, 10 			# call code for terminate
    	ecall 				# system call
