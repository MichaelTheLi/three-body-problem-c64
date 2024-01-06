#import "lib/fp_arith.asm"

.const f = 8
.const fValue = pow(2, f)

*=$1000 "Start"
    divFixedPoint(dividend, divisor, remainder, f, 6)
    divFixedPoint(dividend, divisor2, remainder, f, 10)
	rts

*=$2000 "Data"
    dividend: .word -1 * fValue
    divisor: .word 10 * fValue
    divisor2: .word 20 * fValue
    remainder: .word 0

.function printAddr(name, varAddr) {
    .return name + ":  $" + toHexString(varAddr)
}
.print("f=" + f +", 2^f=" + fValue)
.print(printAddr("dividend", dividend))
.print(printAddr("divisor", divisor))
.print(printAddr("remainder", remainder))
