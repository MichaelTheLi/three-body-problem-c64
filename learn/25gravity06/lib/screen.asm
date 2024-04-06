#importonce

.const CLEAR_SCREEN_KERNAL_ADDR = $E544

.const BACKGROUND_COLOR = $D021
.const FRAME_COLOR = $D020
.const TEXT_COLOR = $0286

.const SCREEN_COLOR_START = $D800
.const SCREEN_START = $0400

.macro clearScreen() {
    jsr CLEAR_SCREEN_KERNAL_ADDR
}

.macro setLine(lineNumber,string,color) {
        lda #$00
    loop_text:
        lda string,x      // read characters from line1 table of text...
        sta SCREEN_START + lineNumber * 40, x      // ...and store in screen ram

        lda #color
        sta SCREEN_COLOR_START+ lineNumber * 40, x
        inx
        cpx #40         // finished when all 40 cols of a line are processed
        bne loop_text    // loop if we are not done yet
}

.macro printChar(x, y, char, color) {
    lda #char
	sta SCREEN_START
	lda #color
	sta SCREEN_COLOR_START
}

.macro setBackgroundColor(backColor, frameColor) {
    lda #backColor
    sta BACKGROUND_COLOR

    lda #frameColor
    sta FRAME_COLOR
}

.macro setTextColor(textColor) {
    lda #textColor
    sta TEXT_COLOR
}
