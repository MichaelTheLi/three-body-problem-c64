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
.macro mul16bitPositive(multiplier, multiplicand, product) {
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
}

// See https://codebase64.org/doku.php?id=base:16bit_multiplication_32-bit_product
.macro mul16bit(multiplier, multiplicand, product) {
checkMultiplier:
	ldy #$00			    // .y will hold the sign of product, .x used in macro mul16bit. Should use jsr
	lda multiplier+1
	bpl checkMultiplicand	// if factor1 is negative
	negate(multiplier, 2)   // then factor1 := -factor1
	iny				        // and switch sign
checkMultiplicand:
	lda multiplicand+1
	bpl doMultiplication    // if factor2 is negative
	negate(multiplicand, 2)	// then factor2 := -factor2
	iny				        // and switch sign
doMultiplication:
	mul16bitPositive(multiplier, multiplicand, product) // do unsigned multiplication
	tya
	and #$01			    // if .x is odd
	beq quit
	negate(product, 4)	    // then product := -product
quit:
}

// Two complement form
.macro negate(value, bytes) {
    .for(var i=bytes-1;i>=0;i--)  {
        lda value+i
        eor #$ff

        .if (i == 0) {
            clc
            adc #$01
        }

        sta value+i
    }
}

// Remainder possibly has wrong sign
.macro div16bit(dividend, divisor, remainder) {
checkDividend:
	ldy #$00			    // .y will hold the sign of product, .x used in macro mul16bit. Should use jsr
	lda dividend+1
	bpl checkDivisor	// if factor1 is negative
	negate(dividend, 2)   // then factor1 := -factor1
	iny				        // and switch sign
checkDivisor:
	lda divisor+1
	bpl doDivision   // if factor2 is negative
	negate(divisor, 2)	// then factor2 := -factor2
	iny				        // and switch sign
doDivision:
    sty divisionSign
	div16bitPositive(dividend, divisor, remainder) // do unsigned division
	lda divisionSign
	and #$01			    // if .x is odd
	beq quit
	negate(dividend, 2)	    // then product := -product
quit:
}

.macro div16bitPositive(dividend, divisor, remainder) {
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

*=$1800 "Int arith data"
    divisionSign: .byte 0

.macro shiftLeft16bit(num, addr) {
.if (num > 0) {
    ldx #num
shift:
    asl addr
    rol addr+1
    dex
    bne	shift
}
}

.macro shiftRight16bit(num, addr) {
.if (num > 0) {
    ldx #num
scaleResult:
    lda addr + 1 // Will set carry for the first ROR op, to fill MSB after shift
    asl
    ror addr+1
    ror addr
    dex
    bne	scaleResult
}
}

// Clear carry before calling
.macro shiftRight16bitPositive(num, addr) {
.if (num > 0) {
    ldx #num
scaleResult:
    ror addr+1
    ror addr
    dex
    bne	scaleResult
}
}

.macro shiftLeft32bit(num, addr) {
.if (num > 0) {
    ldx #num
shift:
    asl addr
    rol addr+1
    rol addr+2
    rol addr+3
    dex
    bne	shift
}
}

.macro shiftRight32bit(num, addr) {
.if (num > 0) {
    lda addr + 3 // Will set carry for the first ROR op, to fill MSB after shift
    // TODO Doesn't work as expected
    shiftRight32bitPositive(num, addr)
}
}

// Clear carry before calling
.macro shiftRight32bitPositive(num, addr) {
.if (num > 0) {
    ldx #num
scaleResult:
    ror addr+3
    ror addr+2
    ror addr+1
    ror addr
    dex
    bne	scaleResult
}
}

.macro copy16bit(source, dest) {
    lda source
    sta dest

    lda source + 1
    sta dest + 1
}

.macro copy32bit(source, dest) {
    copy16bit(source, dest)
    copy16bit(source+2, dest+2)
}

.macro compare16bit(N1, N2, N2Bigger, N1Bigger) {
	lda N1
	cmp N2
	lda N1+1
	sbc N2+1
	eor N1+1
	bmi num1IsBigger
	jmp num2IsBigger

num2IsBigger:
    jmp N2Bigger
	jmp endOfAbsCompare

num1IsBigger:
    jmp N1Bigger

endOfAbsCompare:
}

.macro compare16bitSigned(N1, N2, N2Bigger, N1Bigger) {
	lda N1+1
	eor N2+1
	bmi differentSigns

sameSigns:
	lda N1
	cmp N2
	lda N1+1
	sbc N2+1
	eor N1+1
	bmi num1IsBigger
	jmp num2IsBigger

differentSigns:
	clc
	lda N1
	adc N2
	lda N1+1
	adc N2+1
	eor N1+1
	bmi num1IsBigger

num2IsBigger:
    jmp N2Bigger
	jmp endOfAbsCompare

num1IsBigger:
    jmp N1Bigger

endOfAbsCompare:
}

.function printAddr(name, varAddr) {
    .return name + ":  $" + toHexString(varAddr)
}