*=$1000 "Main"
continue:
    lda counter
    lsr
    tax

    lda sinValues,x
    sta tmpDegree

    ldx #8
scaleDegree:
    asl tmpDegree
    rol tmpDegree+1
    dex
    bne	scaleDegree

	sineByParabola(tmpDegree, tmpRes)

    ldx counter

    // TODO Should try separate hi-lo tables
    lda tmpRes
    sta sinTable, x
    lda tmpRes+1
    sta sinTable+1, x

    dec counter
    dec counter
    beq exit
    jmp continue
exit:
    sinValueTest(75, tempRes1)  // Expecting 0.965, 247 in Q8.8
    sinValueTest(57, tempRes2)  // Expecting 0.838, 214 in Q8.8
    sinValueTest(45, tempRes3)  // Expecting 0.707, 181 in Q8.8
    sinValueTest(23, tempRes4)  // Expecting 0.390, 100 in Q8.8
	rts	

.print("tmpRes:  $" + toHexString(tmpRes))
.print("exit:  $" + toHexString(exit))
.print("sinValues start:  $" + toHexString(sinValues))
.print("sinValues end:  $" + toHexString(sinTable-1))
.print("sinTable start:  $" + toHexString(sinTable))
.print("sinTable end:  $" + toHexString(reminder-1))

.print("tempRes1:  $" + toHexString(tempRes1))
.print("tempRes2:  $" + toHexString(tempRes2))
.print("tempRes3:  $" + toHexString(tempRes3))
.print("tempRes4:  $" + toHexString(tempRes4))

.macro sinValueTest(degree, resAddr) {
    lda #degree // Multiply by 2 in A, move to X
    asl
    tax

    lda sinTable, x     // Save low-byte of value to res
    sta resAddr

    lda sinTable+1, x   // Save hi-byte of value to res
    sta resAddr+1
}
*=$1800 "Data"
    tmpDegree: .word 0
    tmpRes: .word 0
    align: .byte 0
    sinValues: .fill 256, i
    sinTable: .fillword 256, 0

    tempRes1: .word 0
    tempRes2: .word 0
    tempRes3: .word 0
    tempRes4: .word 0

	reminder: .word 0
	degree90: .word 23040 // 23040 is 90 in fixedPoint notation
	degree1to90: .word 3 // 23040 is 90 in fixedPoint notation
	one: .word 256
	counter: .byte 180 // 90 * 2 because word-base output table
	
	tmp: .dword 0
	tmp2: .dword 0
	tmp3: .dword 0

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
