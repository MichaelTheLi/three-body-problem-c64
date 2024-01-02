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

    setColorForSprite(0, 13)    // 7 is yellowish
    setColorForSprite(1, 7)     // 13 is greenish

    setAddrPositionForSprite(0, cx, cy)
    setAddrPositionForSprite(1, center + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET, center + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET)

loop:
    //waitForVsync()

    updateBody16bitFP(center, body, f)

    setAddrPositionForSprite(0, cx, cy)

    lda #CENTER_X
    adc body + BODY_INT_POSITION_OFFSET + VECTOR_X_OFFSET
    sta cx

    lda #CENTER_Y
    adc body + BODY_INT_POSITION_OFFSET + VECTOR_Y_OFFSET
    sta cy

    jmp loop

	rts	

*=$2000 "Data"
    body:
        .word 30 * fValue, 35 * fValue  // position
        .word 0, 0  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 1 * fValue   // mass
        .word 1 * fValue   // inversed mass
    center:
        .word CENTER_X * fValue, CENTER_Y * fValue  // position
        .word CENTER_X, CENTER_Y  // int position
        .word 0, 0  // velocity
        .word 0, 0  // acceleration
        .word 256   // mass
        .word 256   // inversed mass

    cx: .byte 0
    cy: .byte 0

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

.print("cx:  $" + toHexString(cx))
.print("cy:  $" + toHexString(cy))

.print(fValue)