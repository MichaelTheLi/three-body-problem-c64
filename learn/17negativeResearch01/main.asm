#import "lib/int_arith.asm"

*=$1000 "Start"
    copy16bit(value, valueTmp)
    copy16bit(digits, digitsTmp)
    mul16bitNegative(valueTmp, digitsTmp, valueMultiplied)

    shiftLeft32bit(1, valueMultiplied)
    shiftRight32bit(1, valueMultiplied)

    rts

*=$2000 "Data"
    value: .word 12
    digits: .word -3
    valueMultiplied: .dword 0

    valueTmp: .word 0
    digitsTmp: .word 0

.print("value: $" + toHexString(value))
.print("value multiplied: $" + toHexString(valueMultiplied))
