// assembler constants for special memory locations
.const CLEAR_SCREEN_KERNAL_ADDR = $E544     // Kernal routine to clear screen
.const SCREEN_START = $0400                 // The start of c64 screen memory

// a somewhat random location in screen memory to write to directly
.const SCREEN_DIRECT_START = SCREEN_START + $0100 

*=$1000 "Main"
	jsr CLEAR_SCREEN_KERNAL_ADDR // Should not be used later
	lda #1
	sta SCREEN_DIRECT_START
	rts