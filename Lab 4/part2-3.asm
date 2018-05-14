		.data
datain_a:	.word 0x01234567
datain_b:	.word 0x11223344
test_add:	.word 0
test_sub:	.word 0
test_addi:	.word 0
test_and:	.word 0
test_or:	.word 0
test_sll:	.word 0
test_srl:	.word 0
		.text
main:
	lw a0, datain_a
	lw a1, datain_b
	lw s0, test_add
	lw s1, test_sub
	lw s2, test_addi
	lw s3, test_and
	lw s4, test_or
	lw s5, test_sll
	lw s6, test_srl
	
	#test add
	add s0,a0,a1
	sw s0, test_add
	
	#test sub
	sub s1,a0,a1
	sw s1,test_sub
	
	#test addi
	addi s2,a0,0x00001111
	sw s2, test_addi
	
	#test and
	and s3,a0,a1
	sw s3, test_and
	
	#test or
	or s4,a0,a1
	sw s0, test_or
	
	#test sll
	sll s5,a0,1
	sw s5, test_sll
	
	#test srl
	srl s6,a0,1
	sw s6, test_srl
	
	li a7, 10
	ecall

#END
	
	