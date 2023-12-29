#import "lib/graphics.asm"

*=$1000 "Start"
    jmp $4000

.const FP = 8
.const FP2 = pow(2, FP)

*=$4000 "Main"
    // Enable sprite #0 and #1 by setting 1-th and 0-th bit
    enableSprites(%00000011)

    setPointerForSprite(0, $3E80)
    setPointerForSprite(1, $3EC0)

    setColorForSprite(0, 13)    // 7 is yellowish
    setColorForSprite(1, 7)     // 13 is greenish

    setAddrPositionForSprite(0, cx, cy)
    setPositionForSprite(1, 170, 140) // Kinda center

loop:
    waitForVsync()

    setAddrPositionForSprite(0, cx, cy)

    // Should calculate diff with center in FP
    // Now trying to emnulate in integer, just for now
    lda #170
    cmp x
    bcs right
left:
    lda #1
    sta ax
    jmp velocityComputation
right:
    lda #255
    sta ax

velocityComputation:
    // Update velocity based on acceleration
    lda vx
    clc
    adc ax
    sta vx

positionComputation:
    // Update position based on velocity
    lda x
    clc
    adc vx
    sta x

    lda #170
    adc x
    sta cx

    lda #140
    adc y
    sta cy

    jmp loop

	rts	

*=$2000 "Data"
    x: .byte (255 - 170) // Max right in one byte (sprite position is actually 9-bit value)
    vx: .byte 0
    ax: .byte 0

    y: .byte 0

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

.print("x:  $" + toHexString(x))
.print("vx:  $" + toHexString(vx))
.print("ax:  $" + toHexString(ax))

.print("y:  $" + toHexString(y))
//.print("vy:  $" + toHexString(vy))
//.print("ay:  $" + toHexString(ay))

.print("cx:  $" + toHexString(cx))
.print("cy:  $" + toHexString(cy))

.print(FP2)
.print(ceil(1 / 90 * FP2))
.print(ceil(1 / 90 * pow(2, 15)))