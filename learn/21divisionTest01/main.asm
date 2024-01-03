#import "lib/fp_arith.asm"

.const f = 6
.const fValue = pow(2, f)

*=$1000 "Start"
    divFixedPoint(dividend, divisor, remainder, f, f+2)
	rts	

*=$2000 "Data"
    dividend: .word 1 * fValue
    divisor: .word 200 * fValue
    remainder: .word 0

.function printAddr(name, varAddr) {
    .return name + ":  $" + toHexString(varAddr)
}
.print("f=" + f +", 2^f=" + fValue)
.print(printAddr("dividend", dividend))
.print(printAddr("divisor", divisor))
.print(printAddr("remainder", remainder))
