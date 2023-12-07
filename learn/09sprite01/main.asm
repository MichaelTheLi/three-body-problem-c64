*=$1000 "Start"
    jmp $4000

.const CLEAR_SCREEN_KERNAL_ADDR = $E544

*=$4000 "Main"
    // Enable sprite #0 and #1 by setting 1-th and 0-th bit
    lda #%00000011
    sta $D015

    // 250 is $3E80/64 (adress should be divisible by 64)
    // $07F8 is sprite #0 location
    lda #250
    sta $07F8

    // 251 is $3EC0/64 (adress should be divisible by 64)
    // $07F9 is sprite #1 location
    lda #251
    sta $07F9

    // Positions at the center of 320 x 200 screen
    lda #170
    sta $D000

    lda #140
    sta $D001

    // Position #1 sprite
    lda #44
    sta $D002
    lda $D010
    ora #%00000010
    sta $D010

    lda #230
    sta $D003


    // Colors
    lda #13
    sta $D027

    lda #7
    sta $D028

	rts	

*=$2000 "Data"
    x: .word 0
    y: .word 0

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
.print("y:  $" + toHexString(y))
