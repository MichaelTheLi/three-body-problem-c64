#importonce

.macro add16bit(num1addr, num2addr, resaddr) {
	clc
	lda num1addr
	adc num2addr
	sta resaddr

	lda num1addr + 1
	adc num2addr + 1
	sta resaddr + 1
}

.macro sub16bit(num1addr, num2addr, resaddr) {
	sec
	lda num1addr
	sbc num2addr
	sta resaddr

	lda num1addr + 1
	sbc num2addr + 1
	sta resaddr + 1
}

// See https://codebase64.org/doku.php?id=base:16bit_multiplication_32-bit_product
.macro mul16bit(multiplier, multiplicand, product) {
    lda	#$00
    sta	product+2		// clear upper bits of product
    sta	product+3
    ldx	#$10			// set binary count to 16
shift_r:		
    lsr	multiplier+1	// divide multiplier by 2
    ror	multiplier
    bcc	rotate_r
    lda	product+2		// get upper half of product and add multiplicand
    clc
    adc	multiplicand
    sta	product+2
    lda	product+3
    adc	multiplicand+1
rotate_r:	
    ror					// rotate partial product
    sta	product+3
    ror	product+2
    ror	product+1
    ror	product
    dex
    bne	shift_r

    ldx #8  			// 8 is n from Qm.n fixed point format, Q8.8 in our code
scaleBack:
    lsr product+3
    ror product+2
    ror product+1
    ror product
    dex
    bne	scaleBack
}

.macro div16bit(dividend, divisor, remainder) {
    lda #0	        // preset remainder to 0
	sta remainder
	sta remainder+1
	ldx #16	        // repeat for each bit: ...

divloop:
	asl dividend	// dividend lb & hb*2, msb -> Carry
	rol dividend+1
	rol remainder	// remainder lb & hb * 2 + msb from carry
	rol remainder+1
	lda remainder
	sec
	sbc divisor	// substract divisor to see if it fits in
	tay	        // lb result -> Y, for we may need it later
	lda remainder+1
	sbc divisor+1
	bcc skip	// if carry=0 then divisor didn't fit in yet

	sta remainder+1	// else save substraction result as new remainder,
	sty remainder
	inc dividend	// and INCrement result cause divisor fit in 1 times

skip:
	dex
	bne divloop
}

.macro shiftLeft16bit(num, addr) {
    ldx #num
shift:
    asl addr
    rol addr+1
    dex
    bne	shift
}

.macro shiftRight16bit(num, addr) {
    ldx #num
scaleResult:
    lsr addr+1
    ror addr
    dex
    bne	scaleResult
}