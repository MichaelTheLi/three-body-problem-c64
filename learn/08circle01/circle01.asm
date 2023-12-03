#import "sine.asm"

*=$1000 "Start"
    jmp $4000

.const CLEAR_SCREEN_KERNAL_ADDR = $E544     // Kernal routine to clear screen
.const SCREEN_START = $0400                 // The start of c64 screen memory
.const TWENTY_ROW = $0400 + 40 * 12
.const SCREEN_CENTER = $0400 + 40 * 12 + 20

*=$4000 "Main"
    generateSineTable(counter, sinValues, sinTable, tmpDegree, tmpRes, tmp, tmp2, tmp3, one)

	jsr CLEAR_SCREEN_KERNAL_ADDR 	// Should not be used later

loop:
wait_vsync:
	lda $d012       // load $d012
   	cmp #$80        // is it equal to #$80?
   	bne wait_vsync  // if not, keep checking


    ldy #0
	lda #32
	sta ($fb),y

	lda #<SCREEN_START
	ldy #>SCREEN_START

	sta $fb
 	sty $fc

	ldy cy
addition_loop:
	cpy #0
	beq addx

    lda $fb     //Add the least
    clc         //significant pair
    adc #40     	//with the carry
    sta $fb   	//cleared ...

    lda $fb+1   //Add next byte
    adc #0   //pair without
    sta $fb+1 //clearing carry
	dey
	jmp addition_loop
addx:
    lda $fb     //Add the least
    clc         //significant pair
    adc cx     	//with the carry
    sta $fb   	//cleared ...

    lda $fb+1   //Add next byte
    adc #0   //pair without
    sta $fb+1 //clearing carry

    ldy #0
	lda #1
	sta ($fb),y

    // Update cx
    lda degree
    sta degreeTmp
    lda degree+1
    sta degreeTmp+1
    sinValue(degreeTmp, sinValue, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)
    mul16bit(sinValue, radius, x)
    scaleDownFixedPoint(8, x)
    add16bit(centerx, x, cx)

    // Update cy
    add16bit(degree, sin90Deg, degreeTmp2)
    sinValue(degreeTmp2, cosValue, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)
    mul16bit(cosValue, radius, y)
    scaleDownFixedPoint(8, y)
    add16bit(centery, y, cy)

    add16bit(degree, degreeRate, degree)

    jmp loop

	rts	

*=$2000 "Data"
    tmpDegree: .word 0
    tmpRes: .word 0
    align: .byte 0
    sinValues: .fill 180, i
    sinTable: .fillword 180, 0

    quad: .byte 0
    sinZero: .word 0
    sinDegree: .word 0
    sinRemainder: .word 0
    sin360Deg: .word 360
    sin90Deg: .word 90
    sinTmp: .word 0
    sin2Tmp: .word 0

	degree90: .word 23040 // 23040 is 90 in fixedPoint notation
	degree1to90: .word 3 // 23040 is 90 in fixedPoint notation
	one: .word 256
	counter: .byte 180 // 90 * 2 because word-base output table
	
	tmp: .dword 0
	tmp2: .dword 0
	tmp3: .dword 0

    radius: .word 2560 // Fixed point val
    degreeRate: .word 5
    degree: .word 0
    sinValue: .word 0
    cx: .word 0
    cy: .word 0

    x: .dword 0
    y: .dword 0
    centerx: .word 20
    centery: .word 12
    degreeTmp: .word 0
    cosValue: .word 0
    degreeTmp2: .word 0

.print("degree:  $" + toHexString(degree))
.print("cx:  $" + toHexString(cx))
.print("cy:  $" + toHexString(cy))
.print("sin:  $" + toHexString(sinValue))
.print("cos:  $" + toHexString(cosValue))

.print("x:  $" + toHexString(x))
.print("y:  $" + toHexString(y))

.print("degTmp:  $" + toHexString(degreeTmp))
.print("degTmp2:  $" + toHexString(degreeTmp2))