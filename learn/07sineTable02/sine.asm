#importonce

#import "fp_arith.asm"

.macro sinValue(degreeAddr, resAddr, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad) {
    div16bit(degreeAddr, sin360Deg, sinDegree)

    shiftRight16bit(1, sinDegree) // div degree by 2 so we can process as 8-bit
    .print("sinDegree:  $" + toHexString(sinDegree))
    lda sinDegree

    shiftLeft16bit(1, sinDegree)

    cmp #135
    bcs iv

    cmp #90
    bcs iii

    cmp #45
    bcs ii

i:
    lda #1
    sta quad
    jmp sinCalc
ii:
    lda #2
    sta quad
    subFixedPoint(sinDegree, sin90Deg, sinTmp)
    subFixedPoint(sin90Deg, sinTmp, sinDegree)
    jmp sinCalc
iii:
    subFixedPoint(sinDegree, sin90Deg, sinTmp)
    subFixedPoint(sinTmp, sin90Deg, sinDegree)
    lda #3
    sta quad
    jmp sinCalc
iv:
    lda #4
    sta quad
    subFixedPoint(sinDegree, sin90Deg, sinTmp)
    subFixedPoint(sinTmp, sin90Deg, sinDegree)
    subFixedPoint(sinDegree, sin90Deg, sinTmp)
    subFixedPoint(sin90Deg, sinTmp, sinDegree)
    jmp sinCalc

sinCalc:
    .print("sinDegree:  $" + toHexString(sinDegree))
    sinValueTableLookup(sinDegree, sinTable, resAddr)

chk3:
    lda quad
    cmp #3
    bne chk4

    lda resAddr
    sta sin2Tmp

    lda resAddr+1
    sta sin2Tmp+1
    subFixedPoint(sinZero, sin2Tmp, resAddr)
    jmp exit
chk4:
    lda quad
    cmp #4
    bne exit

    lda resAddr
    sta sin2Tmp

    lda resAddr+1
    sta sin2Tmp+1
    subFixedPoint(sinZero, sin2Tmp, resAddr)
    jmp exit
exit:
}

.macro sinValueTableLookup(sinDegree, sinTable, resAddr) {
    lda sinDegree // Multiply by 2 in A, move to X
    asl
    tax

    lda sinTable, x     // Save low-byte of value to res
    sta resAddr

    lda sinTable+1, x   // Save hi-byte of value to res
    sta resAddr+1
}

.macro generateSineTable(counter, sinValues, sinTable, tmpDegree, tmpRes, tmp, tmp2, tmp3, one) {
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

	sineByParabola(tmpDegree, tmpRes, degree90, tmp, tmp2, tmp3, one)

    ldx counter

    lda tmpRes
    sta sinTable, x
    lda tmpRes+1
    sta sinTable+1, x

    dec counter
    dec counter
    beq exit
    jmp continue
exit:
}

// implements parabola approximation 1-((A-90)/90)^2
.macro sineByParabola(degree, resAddr, degree90, tmp, tmp2, tmp3, one) {
	subFixedPoint(degree90, degree, tmp2)
	//divFixedPoint(resAddr, degree90, reminder)
	mulFixedPoint(tmp2, degree1to90, tmp) // Replaced  x / 90  with  x * (1/90)

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
