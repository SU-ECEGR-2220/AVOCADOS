		.data
datain_a:	.word 0x01234567
datain_b:	.word 0x11223344
test_add:	.word 0
test_sub:	.word 0
test_addi:	.word 0
test_and:	.word 0
test_andi:	.word 0
test_or:	.word 0
test_ori:	.word 0
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
	lw s4, test_andi
	lw s5, test_or
	lw s6, test_ori
	lw s7, test_sll
	lw s8, test_srl
	
	#test add
	add s0,a0,a1
	sw s0, test_add,t0
	
	#test sub
	sub s1,a0,a1
	sw s1,test_sub,t0
	
	#test addi
	addi s2,a0,0x00000011
	sw s2, test_addi,t0
	
	#test and
	and s3,a0,a1
	sw s3, test_and,t0
	
	#test andi
	andi s4,a0,0x00000011
	sw s4, test_andi,t0
	
	#test or
	or s5,a0,a1
	sw s5, test_or,t0
	
	#test ori
	ori s6,a0,0x00000011
	sw s6, test_ori,t0
	
	#test sll
	slli s7,a0,1
	sw s7, test_sll,t0
	
	#test srl
	srli s8,a0,2
	sw s8, test_srl,t0
	
	li a7, 10
	ecall

#END
	
	
