// assembler constants for special memory locations
.const CLEAR_SCREEN_KERNAL_ADDR = $E544     // Kernal routine to clear screen
.const SCREEN_START = $0400                 // The start of c64 screen memory
.const TWENTY_ROW = $0400 + 40 * 12

*=$1000 "Main"
	jsr CLEAR_SCREEN_KERNAL_ADDR // Should not be used later
		
	ldx #0       	// Column index
	ldy #1			// Forward/Backward flag

loop:
	lda #1			// "a" char
	sta TWENTY_ROW,x	// print "a" to x-index
wait:	
	lda $d012    // load $d012
   	cmp #$80     // is it equal to #$80?
   	bne wait     // if not, keep checking

	cpy #1
	bcc clear_right
clear_left:
	lda #32				// clear previous "a" to the left
	sta TWENTY_ROW-1,x
	jmp check_right
clear_right:
	lda #32				// clear previous "a" to the right
	sta TWENTY_ROW+1,x

check_right:
	cpx #39
	bcc check_left
	ldy #0

check_left:
	cpx #1
	bcs x_routine
	ldy #1

x_routine:
	cpy #1
	bcs increase
decrease:
	dex
	jmp loop_end
increase:
	inx

loop_end:
	
	jmp loop
	rts