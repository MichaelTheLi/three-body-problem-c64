#import "sine.asm"

*=$1000 "Start"
    jmp $4000

.const CLEAR_SCREEN_KERNAL_ADDR = $E544
.const FP = 8
.const FP2 = pow(2, FP)

*=$4000 "Main"
    generateSineTable(counter, sinValues, sinTable, tmpDegree, tmpRes, tmp, tmp2, tmp3, one, FP)

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

    // Colors
    lda #13
    sta $D027

    lda #7
    sta $D028

    // Position #1 sprite at the center 340 x 280? screen
    lda #170
    sta $D002

    lda #140
    sta $D003

loop:
wait_vsync:
	lda $d012       // load $d012
   	cmp #$80        // is it equal to #$80?
   	bne wait_vsync  // if not, keep checking
    // Update x
    lda degree
    sta degreeTmp
    lda degree+1
    sta degreeTmp+1
    sinValue(degreeTmp, sinValue, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)
    mul16bit(sinValue, radius, y)
    shiftRight32bit(FP, y)
    add16bit(centery, y, cy)

    // Update y
    add16bit(degree, sin90Deg, degreeTmp2)
    sinValue(degreeTmp2, cosValue, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)
    mul16bit(cosValue, radius, x)
    shiftRight32bit(FP, x)
    add16bit(centerx, x, cx)

    add16bit(degree, degreeRate, degree)

    lda cx
    sta $D000

    lda cy
    sta $D001

    jmp loop

	rts	

*=$2000 "Data"
    x: .dword 0
    y: .dword 0

    cx: .word 0
    cy: .word 0

    centerx: .word 170
    centery: .word 140

    tmpDegree: .word 0
    tmpRes: .word 0
    sinValues: .fill 180, i
    sinTable: .fillword 180, 0
	one: .word 1 * FP2
	counter: .byte 90 * 2 // 90 * 2 because word-base output table
	tmp: .dword 0
	tmp2: .dword 0
	tmp3: .dword 0
	degree90: .word 90 // 23040 is 90 in fixedPoint notation
	degree1to90: .word ceil(1 / 90 * FP2) // 11 is 1/90 in Q6.10fixedPoint notation

    quad: .byte 0
    sinZero: .word 0
    sinDegree: .word 0
    sinRemainder: .word 0
    sin360Deg: .word 360
    sin90Deg: .word 90
    sinTmp: .word 0
    sin2Tmp: .word 0

    radius: .word 50
    degreeRate: .word 1
    degree: .word 30
    sinValue: .dword 0
    cosValue: .dword 0
    degreeTmp: .word 0
    degreeTmp2: .word 0

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
.print("deg:  $" + toHexString(degree))
.print("sin:  $" + toHexString(sinValue))
.print("cos:  $" + toHexString(cosValue))
.print("tmp:  $" + toHexString(tmp))
.print("tmp2:  $" + toHexString(tmp2))
.print("tmp3:  $" + toHexString(tmp3))
.print("sinTable: $" + toHexString(sinTable))
.print("sinTable_30: $" + toHexString(sinTable+30*2))
.print(FP2)
.print(ceil(1 / 90 * FP2))