#import "lib/graphics.asm"
#import "physics.asm"

*=$1000 "Start"
    jmp $4000

.const f = 6
.const fValue = pow(2, f)

*=$4000 "Main"
    // Enable sprite #0 and #1 by setting 1-th and 0-th bit
    enableSprites(%00000011)

    setPointerForSprite(0, $3EC0)
    setPointerForSprite(1, $3E80)

    setColorForSprite(0, 13)    // 13 is greenish
    setColorForSprite(1, 7)     // 7 is yellowish

    updateSpritePositionForBody(0, body)
    updateSpritePositionForBody(1, center)

loop:
    //waitForVsync()

    updateBody16bitFP(center, body, f)

    updateSpritePositionForBody(0, body)
    // updateSpritePositionForBody(1, center) // Center is not moving for now

    jmp loop

	rts	

*=$2000 "Data"
    body:
        .word 30 * fValue, 50 * fValue  // position
        .word 0, 0  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 1 * fValue   // mass
        .word floor((1 / 0.1) * fValue)   // inversed mass
        .byte 0, 0  // screen position
    center:
        .word 0 * fValue, 0 * fValue  // position
        .word 0, 0  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 256   // mass
        .word 256   // inversed mass
        .byte 0, 0  // screen position

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