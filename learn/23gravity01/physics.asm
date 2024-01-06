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
    //calculateForce16bitFP(center, body, forceVectorTmp)
    calculateRealForce16bitFP(center, body, forceVectorTmp, f)
    applyForce16BitFP(
        forceVectorTmp,
        body + BODY_INVERSED_MASS_OFFSET,
        body + BODY_ACCELERATION_OFFSET,
        f
    )

    calculateVelocityVector16bitFP(body + BODY_ACCELERATION_OFFSET, body + BODY_VELOCITY_OFFSET)
    calculatePositionVector16bitFP(body + BODY_VELOCITY_OFFSET, body + BODY_POSITION_OFFSET)

    copy16bit(body + BODY_POSITION_OFFSET + VECTOR_X_OFFSET, body + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET)
    shiftRight16bit(f, body + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET)

    copy16bit(body + BODY_POSITION_OFFSET + VECTOR_Y_OFFSET, body + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET)
    shiftRight16bit(f, body + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET)
}

.macro calculateForce16bitFP(forceSourceBody, body, forceVectorTmp) {
    // Calculate in int, still
    // Should calculate diff with center in FP
    // Now trying to emnulate in integer, just for now
    compareExample16bitFP(
        forceSourceBody + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET,
        body + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET,
        forceVectorTmp + VECTOR_X_OFFSET
    )

    compareExample16bitFP(
        forceSourceBody + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET,
        body + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET,
        forceVectorTmp + VECTOR_Y_OFFSET
    )
}

// TODO Not working correctly
.macro calculateRealForce16bitFP(forceSourceBody, body, forceVectorTmp, f) {
    // Calculate in int, still
    // Should calculate diff with center in FP
    // Now trying to emnulate in integer, just for now

    subVectors_16bitFP(
        body + BODY_INT_POSITION_OFFSET,
        forceSourceBody + BODY_INT_POSITION_OFFSET,
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
    copyVector_16bitFP(oneVector, forceVectorTmp)
test:
.print("test:  $" + toHexString(test))
.print("exit2:  $" + toHexString(exit2))
    // TODO Division result is wrong? Should check divisition
    divVectors_16bitFP(forceVectorTmp, squaredLength, remainderVector, f, 8)
exit2:
}

.macro compareExample16bitFP(vector1Component, vector2Component, vector3Component) {
    lda vector1Component
    sbc vector2Component
    bmi more
less:
    lda #1
    sta vector3Component
    lda #0
    sta vector3Component + 1

    jmp exit
more:
    lda #1
    sta vector3Component
    lda #0
    sta vector3Component + 1

    negate(vector3Component, 2)
exit:
}

*=$3000 "Temp physics"
    forceVectorTmp: .word 0, 0
    forceVectorTmp2: .word 0, 0
    squaredLength: .word 0, 0
    distVector: .word 0, 0
    distVectorTmp: .word 0, 0
    remainderVector: .word 0, 0

.print("forceVectorTmp x:  $" + toHexString(forceVectorTmp))
.print("forceVectorTmp y:  $" + toHexString(forceVectorTmp + 2))
.print("squaredLength x:  $" + toHexString(squaredLength + 0))
.print("squaredLength y:  $" + toHexString(squaredLength + 2))

.print("distVector x:  $" + toHexString(distVector + 0))
.print("distVector y:  $" + toHexString(distVector + 2))

.macro applyForce16BitFP(forceVector, inversedMass, accelerationVector, f) {
    mulVectorWithScalarWith16bitRes_16bitFP(forceVector, inversedMass, accelerationVector, f)
}

.macro calculateVelocityVector16bitFP(accelerationVector, velocityVector) {
    addVectors_16bitFP(velocityVector, accelerationVector, velocityVector)
}

.macro calculatePositionVector16bitFP(velocityVector, positionVector) {
    addVectors_16bitFP(positionVector, velocityVector, positionVector)
}
