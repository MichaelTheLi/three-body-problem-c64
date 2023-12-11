#import "fp_arith.asm"

*=$1000 "Start"
    fpTest(value_Q8_8, 8)
    fpTest(value_Q7_9, 9)
    fpTest(value_Q6_10, 10)
    fpTest(value_Q5_11, 11)
    fpTest(value_Q4_12, 12)
    fpTest(value_Q3_13, 13)
    fpTest(value_Q2_14, 14)
    fpTest(value_Q1_15, 15)
    fpTest(value_Q0_16, 16)

	rts	

.macro fpTest(value, f) {
    copy16bit(twoOrig, two)
    shiftLeft32bit(f, two)

    mulFixedPoint(value, two, valueTmp, f)
    copy16bit(valueTmp, value)
    divFixedPoint(value, two, remainder, f, 6)

    // To show 4 fractional digits of result
    copy16bit(digitsOrig, digits)
    shiftLeft16bit(f, digits)

    mulFixedPoint(value, digits, valueTmp, f)
    shiftRight32bit(f, valueTmp)
    copy16bit(valueTmp, value)
exit:
}

.const VALUE = 0.123456789
*=$2000 "Data"
    value_Q8_8: .word ceil(VALUE * pow(2, 8))
    value_Q7_9: .word ceil(VALUE * pow(2, 9))
    value_Q6_10: .word ceil(VALUE * pow(2, 10))
    value_Q5_11: .word ceil(VALUE * pow(2, 11))
    value_Q4_12: .word ceil(VALUE * pow(2, 12))
    value_Q3_13: .word ceil(VALUE * pow(2, 13))
    value_Q2_14: .word ceil(VALUE * pow(2, 14))
    value_Q1_15: .word ceil(VALUE * pow(2, 15))
    value_Q0_16: .word ceil(VALUE * pow(2, 16))
    digitsOrig: .word pow(10, 2)
    digits: .word 0
    twoOrig: .word 2
    two: .word 0
    valueTmp: .dword 0
    remainder: .word 0

.print(pow(2, 8))
.print(VALUE * pow(2, 8))
.print(ceil(VALUE * pow(2, 8)))
.print("Q8.8:  $" + toHexString(value_Q8_8))
.print("Q7.9:  $" + toHexString(value_Q7_9))
.print("Q6.10:  $" + toHexString(value_Q6_10))
.print("Q5.11:  $" + toHexString(value_Q5_11))
.print("Q4.12:  $" + toHexString(value_Q4_12))
.print("Q3.13:  $" + toHexString(value_Q3_13))
.print("Q2.14:  $" + toHexString(value_Q2_14))
.print("Q1.15:  $" + toHexString(value_Q1_15))
.print("Q0.16:  $" + toHexString(value_Q0_16))
.print("valueTmp:  $" + toHexString(valueTmp))
.print("two:  $" + toHexString(two))