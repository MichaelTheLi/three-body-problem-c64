#importonce

.const SCREEN_START = $0400                 // The start of c64 screen memory
.const ZERO_SCREEN_CODE = $30               // 48 in dec, code for "0"
.const DOT_SCREEN_CODE = $2E                // 46 in dec, code for "."


.macro outputFp(valueTmp, digits, fractionalDigits, startPos, remainderTmp, base, f) {
.for(var i=0;i<digits+1;i++)  {
    .print("i: " + (startPos + digits - i))

    .if (i == fractionalDigits) {
        lda #DOT_SCREEN_CODE
        sta SCREEN_START + startPos + (digits-1) - i
    } else {
        div16bit(valueTmp, base, remainderTmp)
        lda remainderTmp
        clc
        adc #ZERO_SCREEN_CODE
        sta SCREEN_START + startPos + (digits-1) - i
    }
}
}
