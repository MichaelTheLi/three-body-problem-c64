// assemler constants for special memory locations
.const CLEAR_SCREEN_KERNAL_ADDR = $E544     // Kernal routine to clear screen
.const SCREEN_START = $0400                 // The start of c64 screen memory
.const TWENTY_ROW = $0400 + 40 * 12
.const SCREEN_CENTER = $0400 + 40 * 12 + 20

*=$1000 "Main"
	jsr CLEAR_SCREEN_KERNAL_ADDR 	// Should not be used later

loop:
wait:	
	lda $d012    // load $d012
   	cmp #$80     // is it equal to #$80?
   	bne wait     // if not, keep checking

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
output:
	ldy #0
	lda #1
	sta ($fb),y
	//ldy cx
	//lda #1
	//sta TWENTY_ROW, y

	update_dir(cx, dx, 0, 40)	
	update_dir(cy, dy, 0, 25)	
	update_pos(cx, dx)
	update_pos(cy, dy)

	jmp loop

	rts

.macro update_dir (addr, dir_addr, low, high)
{
		ldy addr
		update_dir_high:
			cpy #high-1
			bcc update_dir_low
			lda #0                                   
			sta dir_addr
			
		update_dir_low:
			cpy #low+1
			bcs update_dir_exit
			lda #1
			sta dir_addr
		update_dir_exit:
}

.macro update_pos(addr, dir_addr) 
{		
			lda dir_addr
			cmp #1
			bcs update_pos_continue
			dec addr                                   
			jmp continue
		update_pos_continue:
			inc addr
		continue:
}
*=$1100
cx: .byte 0
cy: .byte 12
dx: .byte 1
dy: .byte 1