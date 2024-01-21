#import "lib/graphics.asm"
#import "physics.asm"

*=$1000 "Start"
    jmp $4000

.const f = 8
.const fValue = pow(2, f)

*=$4000 "Main"
    // Enable sprite #0, #1 and #2 by setting 2-th, 1-th and 0-th bit
    enableSprites(%00000111)

    setPointerForSprite(0, $3EC0)
    setPointerForSprite(1, $3E80)
    setPointerForSprite(2, $3EC0)

    setColorForSprite(0, 13)    // 13 is greenish
    setColorForSprite(1, 7)     // 7 is yellowish
    setColorForSprite(2, 10)     // 6 is redish

    updateSpritePositionForBody(0, body)
    updateSpritePositionForBody(1, center)
    updateSpritePositionForBody(2, body2)

loop:
    waitForVsync()

    // Aplly all forces
    applyBodyForces16bitFP(center, body, f)
    //applyBodyForces16bitFP(center, body2, f)

    applyBodyForces16bitFP(body, center, f)
    //applyBodyForces16bitFP(body, body2, f)

    //applyBodyForces16bitFP(body2, center, f)
    //applyBodyForces16bitFP(body2, body, f)

    // Calculate velocities and positions
    updateBodyPos16bitFP(center, f)
    updateBodyPos16bitFP(body, f)
    //updateBodyPos16bitFP(body2, f)

    updateSpritePositionForBody(0, body)
    updateSpritePositionForBody(1, center)
    updateSpritePositionForBody(2, body2)

    jmp loop

	rts

.const INITIAL_X = 25
.const INITIAL_Y = 0

.const INITIAL_X_2 = 0
.const INITIAL_Y_2 = 15
*=$2000 "Data"
    body:
        .word INITIAL_X * fValue, INITIAL_Y * fValue  // position
        .word INITIAL_X, INITIAL_Y  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 1 * fValue   // mass (not used for now)
        .word ceil((1/8) * fValue)//floor((1 / 0.01) * fValue)   // inversed mass
        .byte 0, 0  // screen position

    body2:
        .word INITIAL_X_2 * fValue, INITIAL_Y_2 * fValue  // position
        .word INITIAL_X_2, INITIAL_Y_2  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 1 * fValue   // mass (not used for now)
        .word ceil((1/8) * fValue)//floor((1 / 0.01) * fValue)   // inversed mass
        .byte 0, 0  // screen position
    center:
        .word 0 * fValue, 0 * fValue  // position
        .word 0, 0  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 8 * fValue   // mass (not used for now)
        .word ceil((1/8) * fValue)   // inversed mass
        .byte 0, 0  // screen position

    oneVectorFP: .word 1 * fValue, 1 * fValue
.print(printVectAddr("body_x", body + BODY_INT_POSITION_OFFSET))
.print(printVectAddr("body_vx", body + BODY_VELOCITY_OFFSET))
.print(printVectAddr("body_ax", body + BODY_ACCELERATION_OFFSET))

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