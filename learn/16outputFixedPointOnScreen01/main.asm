#import "lib/fp_arith.asm"
#import "lib/output.asm"

*=$1000 "Start"
    jmp $4000

.const CLEAR_SCREEN_KERNAL_ADDR = $E544

.const FP = 10
.const FP2 = pow(2, FP)

.const EXAMPLE_VALUE = 0.12345
.const EXAMPLE_VALUE_IN_FP = ceil(EXAMPLE_VALUE * FP2)
.const DIGITS = 5   // Limited to 32bit result of multiplication
                    // Value in fp format will be multiplied by 10 ^ DIGITS
                    // Even 127 (0.12345 in Q6.10) with 5 digits will become 12700000
                    // And final result after converting to int again(right shift by FP)
                    //      should fit in 16bit, because I don't have 32bit arith lib yet
                    // So, be careful
.const EXAMPLE_VALUE2 = 0.98765

*=$4000 "Main"
    jsr CLEAR_SCREEN_KERNAL_ADDR

    mul16bit(value, digits, valueMultiplied)    // For digits 10 ^ 5 result somehow become garbage
                                                // But results should fit into 32bit product
    // shiftRight32bit(FP, valueMultiplied)
    copy16bit(valueMultiplied, valueTmp)
    outputFp(valueTmp, DIGITS+3, DIGITS, 40 * 12 + 1, remainderTmp, base, FP)

    mul16bit(value2, digits, valueMultiplied2)    // For digits 10 ^ 5 result somehow become garbage
                                                // But results should fit into 32bit product
    shiftRight32bit(FP, valueMultiplied2)
    copy16bit(valueMultiplied2, valueTmp2)

    outputFp(valueTmp2, DIGITS+3, DIGITS, 40 * 13 + 1, remainderTmp2, base, FP)

    rts

*=$2000 "Data"
    value: .word ceil(EXAMPLE_VALUE * FP2)
    valueMultiplied: .dword 0
    valueTmp: .word 0
    remainderTmp: .word 0

    value2: .word ceil(EXAMPLE_VALUE2 * FP2)
    valueMultiplied2: .dword 0
    valueTmp2: .word 0
    remainderTmp2: .word 0

    digits: .word pow(10, DIGITS)
    base: .word 10

.print("value: $" + toHexString(value))
.print("value multiplied: $" + toHexString(valueMultiplied))

.print("FP: " + FP)
.print("FP2: " + FP2)

.print("Example value: " + EXAMPLE_VALUE)
.print("Example value in FP: " + EXAMPLE_VALUE_IN_FP)
.print("Example value multiplied with digits: " + (EXAMPLE_VALUE_IN_FP * pow(10, DIGITS)))