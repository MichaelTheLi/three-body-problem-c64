#import "lib/vector_arith.asm"
#import "lib/graphics.asm"

.const VAR_SIZE                 = 2
.const VECTOR_BYTE_SIZE         = 2 * VAR_SIZE

.const VECTOR_X_OFFSET          = 0
.const VECTOR_X_SIZE            = VAR_SIZE

.const VECTOR_Y_OFFSET          = VECTOR_X_OFFSET + VECTOR_X_SIZE
.const VECTOR_Y_SIZE            = VAR_SIZE


.const BODY_POSITION_OFFSET     = 0
.const BODY_POSITION_SIZE       = VECTOR_BYTE_SIZE

.const BODY_INT_POSITION_OFFSET = BODY_POSITION_OFFSET + BODY_POSITION_SIZE
.const BODY_INT_POSITION_SIZE   = VECTOR_BYTE_SIZE

.const BODY_VELOCITY_OFFSET     = BODY_INT_POSITION_OFFSET + BODY_INT_POSITION_SIZE
.const BODY_VELOCITY_SIZE       = VECTOR_BYTE_SIZE

.const BODY_ACCELERATION_OFFSET = BODY_VELOCITY_OFFSET + BODY_VELOCITY_SIZE
.const BODY_ACCELERATION_SIZE   = VECTOR_BYTE_SIZE

.const BODY_MASS_OFFSET         = BODY_ACCELERATION_OFFSET + BODY_ACCELERATION_SIZE
.const BODY_MASS_SIZE           = VAR_SIZE

.const BODY_INVERSED_MASS_OFFSET    = BODY_MASS_OFFSET + BODY_MASS_SIZE
.const BODY_INVERSED_MASS_SIZE      = VAR_SIZE

.const BODY_SCREEN_POSITION         = BODY_INVERSED_MASS_OFFSET + BODY_INVERSED_MASS_SIZE
.const BODY_SCREEN_POSITION_SIZE    = VAR_SIZE

.print("Offsets")
.print("" + BODY_POSITION_OFFSET + ": pos")
.print("" + BODY_INT_POSITION_OFFSET + ": int_pos")
.print("" + BODY_VELOCITY_OFFSET + ": vx")
.print("" + BODY_ACCELERATION_OFFSET + ": ax")
.print("" + BODY_MASS_OFFSET + ": mass")
.print("" + BODY_INVERSED_MASS_OFFSET + ": inv_mass")
.print("" + BODY_SCREEN_POSITION + ": screen_pos")


.macro updateSpritePositionForBody(sprite, body) {
    lda #CENTER_X
    adc body + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET
    sta body + BODY_SCREEN_POSITION

    lda #CENTER_Y
    adc body + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET
    sta body + BODY_SCREEN_POSITION + 1

    setAddrPositionForSprite(
        sprite,
        body + BODY_SCREEN_POSITION,
        body + BODY_SCREEN_POSITION + 1 // Because BODY_SCREEN_POSITION is byte instead of word
    )
}

.macro updateBody16bitFP(center, body, f) {
    calculateRealForce16bitFP(
        body + BODY_INT_POSITION_OFFSET,
        center + BODY_INT_POSITION_OFFSET,
        forceVectorTmp,
        f
    )

    applyForce16BitFP(
        forceVectorTmp,
        body + BODY_INVERSED_MASS_OFFSET,
        body + BODY_ACCELERATION_OFFSET,
        f
    )

    addVectors_16bitFP(
        body + BODY_ACCELERATION_OFFSET,
        body + BODY_VELOCITY_OFFSET,
        body + BODY_VELOCITY_OFFSET
    )
    addVectors_16bitFP(
        body + BODY_VELOCITY_OFFSET,
        body + BODY_POSITION_OFFSET,
        body + BODY_POSITION_OFFSET
    )

    copy16bit(
        body + BODY_POSITION_OFFSET + VECTOR_X_OFFSET,
        body + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET
    )
    shiftRight16bit(f, body + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET)

    copy16bit(
        body + BODY_POSITION_OFFSET + VECTOR_Y_OFFSET,
        body + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET
    )
    shiftRight16bit(f, body + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET)
exit:
}

.macro calculateRealForce16bitFP(bodyPos, centerPos, forceVector, f) {
negateCheckX:
    compare16bit(centerPos, bodyPos, bodyXMore, checkY)

bodyXMore:
    lda #1
    sta signByteVector

checkY:
    compare16bit(centerPos + 2, bodyPos + 2, bodyYMore, continueCalculation)

bodyYMore:
    lda #1
    sta signByteVector + 1

continueCalculation:
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

    copyVector_16bitFP(distVector, forceVector)
    // squaredLength actually not in FP, so it's all scaled up a bit
    divVectors_16bitFP(forceVector, squaredLength, remainderVector, f, 6)

lowerCheck:
    compare16bit(forceVector, lowerBoundVector, lowerCheckY, lowerMore)

lowerMore:
    copy16bit(lowerBoundVector, forceVector)

lowerCheckY:
    compare16bit(forceVector + 2, lowerBoundVector + 2, upperCheck, lowerMoreY)

lowerMoreY:
    copy16bit(lowerBoundVector + 2, forceVector + 2)

upperCheck:
    compare16bit(forceVector, upperBoundVector, more, upperCheckY)

more:
    copy16bit(upperBoundVector, forceVector)

upperCheckY:
    compare16bit(forceVector + 2, upperBoundVector + 2, moreY, negateForceX)

moreY:
    copy16bit(upperBoundVector + 2, forceVector + 2)

negateForceX:
    lda signByteVector
    bne negateForceY
    negate(forceVector, 2)

negateForceY:
    lda signByteVector + 1
    bne exit
    negate(forceVector + 2, 2)
exit:
}

*=$3000 "Temp physics"
    forceVectorTmp: .word 0, 0
    forceVectorTmp2: .word 0, 0
    squaredLength: .word 0, 0
    distVector: .word 0, 0
    distVectorTmp: .word 0, 0
    remainderVector: .word 0, 0
    lowerBoundVector: .word 1, 1
    upperBoundVector: .word 1024, 1024
    signByteVector: .byte 0, 0

.print(printVectAddr("forceVectorTmp", forceVectorTmp))
.print(printVectAddr("squaredLength", squaredLength))
.print(printVectAddr("distVector", distVector))
.print(printAddr("signByteVector", signByteVector))

.macro applyForce16BitFP(forceVector, inversedMass, accelerationVector, f) {
    //(accelerationVector, inversedMass, forceVector, f)
    copyVector_16bitFP(forceVector, accelerationVector)
}

