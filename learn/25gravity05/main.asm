#import "lib/graphics.asm"
#import "physics.asm"

*=$1000 "Start"
    jmp $4000

.const f = 8
.const fValue = pow(2, f)

*=$4000 "Main"
    // Enable sprite #0, #1 and #2 by setting 2-th, 1-th and 0-th bit
    enableSprites(%00001111)

    setPointerForSprite(0, $3EC0)
    setPointerForSprite(1, $3EC0)
    setPointerForSprite(2, $3EC0)
    setPointerForSprite(3, $3EC0)

    setColorForSprite(0, 13)    // 13 is greenish
    setColorForSprite(1, 7)     // 7 is yellowish
    setColorForSprite(2, 10)     // 10 is light-red
    setColorForSprite(3, 3)     // 3 is cyan

    updateSpritePositionForBody(0, body0)
    updateSpritePositionForBody(1, body1)
    updateSpritePositionForBody(2, body2)
    updateSpritePositionForBody(3, body3)

loop:
    waitForVsync()

    initializeForcesCalc(body0)
    initializeForcesCalc(body1)
    initializeForcesCalc(body2)
    initializeForcesCalc(body3)

    // Apply all forces
    applyBodyForces16bitFP(body0, body1, f)
    applyBodyForces16bitFP(body0, body2, f)
    applyBodyForces16bitFP(body0, body3, f)

    applyBodyForces16bitFP(body1, body0, f)
    applyBodyForces16bitFP(body1, body2, f)
    applyBodyForces16bitFP(body1, body3, f)

    applyBodyForces16bitFP(body2, body0, f)
    applyBodyForces16bitFP(body2, body1, f)
    applyBodyForces16bitFP(body2, body3, f)

    applyBodyForces16bitFP(body3, body0, f)
    applyBodyForces16bitFP(body3, body1, f)
    applyBodyForces16bitFP(body3, body2, f)

    // Calculate velocities and positions
    updateBodyPos16bitFP(body0, f)
    updateBodyPos16bitFP(body1, f)
    updateBodyPos16bitFP(body2, f)
    updateBodyPos16bitFP(body3, f)

    updateSpritePositionForBody(0, body0)
    updateSpritePositionForBody(1, body1)
    updateSpritePositionForBody(2, body2)
    updateSpritePositionForBody(3, body3)

    jmp loop

	rts

*=$2000 "Data"
    body0:
        .word 0 * fValue, 0 * fValue  // position
        .word 0, 0  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 0, 0  // force
        .word 8 * fValue   // mass (not used for now)
        .word ceil((1/32) * fValue)   // inversed mass
        .byte 0, 0  // screen position
    body1:
        .word 0 * fValue, 25 * fValue  // position
        .word 0, 25  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 0, 0  // force
        .word 8 * fValue   // mass (not used for now)
        .word ceil((1/2) * fValue)//floor((1 / 0.01) * fValue)   // inversed mass
        .byte 0, 0  // screen position
    body2:
        .word -32 * fValue, -36 * fValue  // position
        .word -2, -40  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 0, 0  // force
        .word 8 * fValue   // mass (not used for now)
        .word ceil((1/2) * fValue)//floor((1 / 0.01) * fValue)   // inversed mass
        .byte 0, 0  // screen position
    body3:
        .word -25 * fValue, 45 * fValue  // position
        .word -35, 12  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 0, 0  // force
        .word 8 * fValue   // mass (not used for now)
        .word ceil((1/12) * fValue)//floor((1 / 0.01) * fValue)   // inversed mass
        .byte 0, 0  // screen position

    oneVectorFP: .word 1 * fValue, 1 * fValue
.print(printVectAddr("body_x", body0 + BODY_INT_POSITION_OFFSET))
.print(printVectAddr("body_vx", body0 + BODY_VELOCITY_OFFSET))
.print(printVectAddr("body_ax", body0 + BODY_ACCELERATION_OFFSET))

// 250
*=$3E80 "Sprite #0"
    .byte 0, 126, 0
    .byte 3, 255, 192
    .byte 7, 255, 224
    .byte 31, 255, 248
    .byte 31, 255, 248
    .byte 63, 255, 252
    .byte 127, 255, 254
    .byte 127, 255, 254
    .byte 255, 255, 255
    .byte 255, 255, 255
    .byte 255, 255, 255
    .byte 255, 255, 255
    .byte 255, 255, 255
    .byte 127, 255, 254
    .byte 127, 255, 254
    .byte 63, 255, 252
    .byte 31, 255, 248
    .byte 31, 255, 248
    .byte 7, 255, 224
    .byte 3, 255, 192
    .byte 0, 126, 0

// 251
*=$3EC0 "Sprite #1"
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 126, 0
    .byte 0, 126, 0
    .byte 0, 126, 0
    .byte 0, 126, 0
    .byte 0, 126, 0
    .byte 0, 126, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0
    .byte 0, 0, 0

.print(fValue)