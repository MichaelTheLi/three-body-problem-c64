#importonce

#import "fp_arith.asm"

.macro sinValue(degreeAddr, resAddr, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad) {
    div16bit(degreeAddr, sin360Deg, sinDegree)

    copy16bit(sinDegree, sinTmp)
    shiftRight16bit(1, sinTmp) // div degree by 2 so we can process as 8-bit
    lda sinTmp

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

.macro generateSineTable(counter, sinValues, sinTable, tmpDegree, tmpRes, tmp, tmp2, tmp3, one, f) {
continue:
    lda counter
    lsr
    tax

    lda sinValues,x
    sta tmpDegree

	//shiftLeft16bit(f, tmpDegree)

	sineByParabola(tmpDegree, tmpRes, degree90, tmp, tmp2, tmp3, one, f)

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
.macro sineByParabola(degree, resAddr, degree90, tmp, tmp2, tmp3, one, f) {
    subFixedPoint(degree90, degree, tmp2)
    // degree1to90 always in Q1.15
    mul16bit(tmp2, degree1to90, tmp)    // Replaced  x / 90  with  x * (1/90)
                                        // Also multiplying in simple int format,
                                        // so more chances to fit into 16bit
    shiftRight32bit(15-f, tmp)

    copy32bit(tmp, tmp2)

    mulFixedPoint(tmp, tmp2, tmp3, f)

    subFixedPoint(one, tmp3, resAddr)
}
