*=$1000 "Main"
	sineByParabola(sinValues, sinTable)      		// 0.0, or 0 in fp
	sineByParabola(sinValues + 2, sinTable + 2) 	// 0.707, or 181 in fp
	sineByParabola(sinValues + 4, sinTable + 4)		// 0.866, or 221 in fp
	sineByParabola(sinValues + 6, sinTable + 6) 	// 1.0, or 256 in fp
	rts	

*=$1800 "Data"
	sinValues: .word 1280, 11520, 15360, 22000  // 0, 45, 60, 90 in degrees
	sinTable: .word 0, 0, 0, 0
	reminder: .word 0
	degree90: .word 23040 // 23040 is 90 in fixedPoint notation
	degree1to90: .word 3 // 23040 is 90 in fixedPoint notation
	one: .word 256
	
	tmp: .dword 0
	tmp2: .dword 0
	tmp3: .dword 0

.print("tmp: $"  + toHexString(tmp))
.print("tmp2: $" + toHexString(tmp2))
.print("tmp3: $" + toHexString(tmp3))

// implements parabola approximation 1-((A-90)/90)^2
.macro sineByParabola(degree, resAddr) {
	subFixedPoint(degree90, degree, tmp2)    	
	//divFixedPoint(resAddr, degree90, reminder)
	mulFixedPoint(tmp2, degree1to90, tmp) // Replaced x / 90 with x * (1/90) to 
	lda tmp
	sta tmp2
	lda tmp+1
	sta tmp2+1
	lda tmp+2
	sta tmp2+2
	lda tmp+3
	sta tmp2+3
	mulFixedPoint(tmp, tmp2, tmp3)
	lda tmp3
	sta resAddr
	lda tmp3 + 1
	sta resAddr + 1

	subFixedPoint(one, tmp3, resAddr) 				// 256 is 1 in fixedPoint notation
}


.macro addFixedPoint(num1addr, num2addr, resaddr) {
	clc
	lda num1addr
	adc num2addr
	sta resaddr

	lda num1addr + 1
	adc num2addr + 1
	sta resaddr + 1
}

.macro subFixedPoint(num1addr, num2addr, resaddr) {
	clc
	lda num1addr
	sbc num2addr
	sta resaddr

	lda num1addr + 1
	sbc num2addr + 1
	sta resaddr + 1
}

// See https://codebase64.org/doku.php?id=base:16bit_multiplication_32-bit_product
.macro mulFixedPoint(multiplier, multiplicand, product) {
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

.macro divFixedPoint(dividend, divisor, remainder) {
    ldx #6
scaleDivisorToLowerScale:
    asl dividend
    rol dividend+1
    dex
    bne	scaleDivisorToLowerScale

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
	
    ldx #2
scaleResult:
    asl dividend
    rol dividend+1
    dex
    bne	scaleResult
}
