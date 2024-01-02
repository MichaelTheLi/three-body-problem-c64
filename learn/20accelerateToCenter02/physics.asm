#import "lib/vector_arith.asm"

.const VAR_SIZE                 = 2
.const VECTOR_BYTE_SIZE         = 2 * VAR_SIZE

.const VECTOR_X_OFFSET          = 0
.const VECTOR_X_SIZE            = VAR_SIZE

.const VECTOR_Y_OFFSET          = VECTOR_X_OFFSET + VECTOR_X_SIZE
.const VECTOR_Y_SIZE            = VAR_SIZE


.const BODY_POSITION_OFFSET     = 0
.const BODY_POSITION_SIZE       = VECTOR_BYTE_SIZE

.const BODY_VELOCITY_OFFSET     = BODY_POSITION_OFFSET + BODY_POSITION_SIZE
.const BODY_VELOCITY_SIZE       = VECTOR_BYTE_SIZE

.const BODY_ACCELERATION_OFFSET = BODY_VELOCITY_OFFSET + BODY_VELOCITY_SIZE
.const BODY_ACCELERATION_SIZE   = VECTOR_BYTE_SIZE

.const BODY_MASS_OFFSET         = BODY_ACCELERATION_OFFSET + BODY_ACCELERATION_SIZE
.const BODY_MASS_SIZE           = VAR_SIZE

.const BODY_INVERSED_MASS_OFFSET    = BODY_MASS_OFFSET + BODY_MASS_SIZE
.const BODY_INVERSED_MASS_SIZE      = VAR_SIZE

.macro updateBody16bitFP(center, body, f) {
    calculateForce16bitFP(center, body, body + BODY_ACCELERATION_OFFSET)
    //calculateForce16bitFP(center, body, forceVectorTmp)
    //applyForce16BitFP(forceVectorTmp, body + BODY_INVERSED_MASS_OFFSET, body + BODY_ACCELERATION_OFFSET, f)
    calculateVelocityVector16bitFP(body + BODY_ACCELERATION_OFFSET, body + BODY_VELOCITY_OFFSET)
    calculateVelocityVector16bitFP(body + BODY_VELOCITY_OFFSET, body + BODY_POSITION_OFFSET)
}

.macro calculateForce16bitFP(forceSourceBody, body, forceVectorTmp) {
    // Calculate in int, still
    // Should calculate diff with center in FP
    // Now trying to emnulate in integer, just for now
    compareExample16bitFP(
        forceSourceBody + BODY_POSITION_OFFSET + VECTOR_X_OFFSET,
        body + BODY_POSITION_OFFSET + VECTOR_X_OFFSET,
        forceVectorTmp + VECTOR_X_OFFSET
    )

    compareExample16bitFP(
        forceSourceBody + BODY_POSITION_OFFSET + VECTOR_Y_OFFSET,
        body + BODY_POSITION_OFFSET + VECTOR_Y_OFFSET,
        forceVectorTmp + VECTOR_Y_OFFSET
    )
}

.macro compareExample16bitFP(vector1Component, vector2Component, vector3Component) {
    lda vector1Component
    cmp vector2Component
    bcs more
less:
    lda #1
    jmp add
more:
    lda #255
add:
    sta vector3Component
}

.macro applyForce16BitFP(forceVector, inversedMass, accelerationVector, f) {
    mulVectors_16bitFP(forceVector, inversedMass, forceVectorTmp2, f)

    addVectors_16bitFP(accelerationVector, forceVectorTmp2, accelerationVector)
}

.macro calculateVelocityVector16bitFP(accelerationVector, velocityVector) {
    addVectors_16bitFP(velocityVector, accelerationVector, velocityVector)
}

.macro calculatePositionVector16bitFP(velocityVector, positionVector) {
    addVectors_16bitFP(positionVector, velocityVector, positionVector)
}


*=$3000 "Temp physics"
    forceVectorTmp: .word 0, 0
    forceVectorTmp2: .word 0, 0

