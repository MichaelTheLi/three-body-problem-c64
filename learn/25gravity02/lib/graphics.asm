#importonce

#import "fp_arith.asm"

.const SPRITE_STATE = $D015
.const SPRITE_POINTERS = $07F8  // $07F8 is sprite #0 pointer location
.const SPRITE_COLORS = $D027    // $D027 is sprite #0 color
.const SPRITE_POSITIONS = $D000 // $D000 is sprite #0 X, $D001 is Y

.const CENTER_X = 170
.const CENTER_Y = 140

.macro enableSprites(x) {
    // Enable sprite #0 and #1 by setting 1-th and 0-th bit
    lda #x
    sta SPRITE_STATE
}

// https://www.c64-wiki.com/wiki/Sprite#Sprite_pointers
.macro setPointerForSprite(spriteNum, addr) {
    // Adress should be divisible by 64, and the pointer should contain that division result
    // For example, $3E80 address should become $3E80/64=250 ()
    lda #(addr / 64)
    sta SPRITE_POINTERS + spriteNum
}

// TODO Use enums?
// https://www.c64-wiki.com/wiki/Sprite#Color_settings
.macro setColorForSprite(spriteNum, color) {
    lda #color
    sta $D027 + spriteNum
}

// https://www.c64-wiki.com/wiki/Sprite#Sprite_locations
.macro setPositionForSprite(spriteNum, x, y) {
    lda #x
    sta SPRITE_POSITIONS + (spriteNum * 2)

    lda #y
    sta SPRITE_POSITIONS + (spriteNum * 2) + 1
}

// https://www.c64-wiki.com/wiki/Sprite#Color_settings
// TODO Use enums?
.macro setAddrColorForSprite(spriteNum, color) {
    lda color
    sta $D027 + spriteNum
}

// https://www.c64-wiki.com/wiki/Sprite#Sprite_locations
// TODO 9th bit not set in $D010
.macro setAddrPositionForSprite(spriteNum, x, y) {
    lda x
    sta SPRITE_POSITIONS + (spriteNum * 2)

    lda y
    sta SPRITE_POSITIONS + (spriteNum * 2) + 1
}

.macro waitForVsync() {
wait_vsync:
	lda $d012       // load $d012
   	cmp #$80        // is it equal to #$80?
   	bne wait_vsync  // if not, keep checking
}