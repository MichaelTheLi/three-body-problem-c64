#import "lib/vector_arith.asm"
#import "lib/graphics.asm"

*=$1000 "Start"
    jmp $4000

.const f = 8
.const fValue = pow(2, f)

*=$4000 "Main"
loop:
    waitForVsync()

    calculateRealForce16bitFP(bodyPos, centerPos, forceVector, f)

    rts

    jmp loop

	rts	

.macro calculateRealForce16bitFP(bodyPos, centerPos, forceVector, f) {
    subVectors_16bitFP(
        bodyPos,
        centerPos,
        distVectorTmp
    )

    copyVector_16bitFP(distVectorTmp, distVector)

    mulVectorsWith16bitRes_16bit(
        distVectorTmp,
        distVector,
        squaredLength
    )

    add16bit(squaredLength, squaredLength + 2, squaredLength + 2)
    copy16bit(squaredLength + 2, squaredLength)

    copyVector_16bitFP(oneVectorFP, forceVector)
    // squaredLength actually not in FP, so it's all scaled up a bit
    divVectors_16bitFP(forceVector, squaredLength, remainderVector, f, 6)

lowerCheck:
    lda forceVector
    cmp #0
    bne lowerY
    lda #1
    sta forceVector
lowerY:
    lda forceVector + 2
    cmp #0
    bne upperCheck
    lda #1
    sta forceVector + 2

upperCheck:
    compare16bit(forceVector, upperBoundVector, more, exit)

more:
    copyVector_16bitFP(upperBoundVector, forceVector)
    jmp exit
exit:
}

*=$2000 "Data"
    bodyPos: .word 150, 150
    centerPos: .word 0, 0
    forceVector: .word 0, 0

    distVector: .word 0, 0
    distVectorTmp: .word 0, 0
    squaredLength: .word 0, 0
    remainderVector: .word 0, 0

    oneVectorFP: .word 1 * fValue, 1 * fValue
    upperBoundVector: .word 1024, 1024

.function printAddr(name, varAddr) {
    .return name + ":  $" + toHexString(varAddr)
}

.print(fValue)

.print(printVectAddr("forceVector", forceVector))
.print(printVectAddr("distVector", distVector))
.print(printVectAddr("distVectorTmp", distVectorTmp))
.print(printVectAddr("squaredLength", squaredLength))
