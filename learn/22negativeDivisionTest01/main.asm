#import "lib/int_arith.asm"

*=$1000 "Start"
    div16bit(dividend, divisor, remainder)
	rts

*=$2000 "Data"
    dividend: .word -13
    divisor: .word 3
    remainder: .word 0

.function printAddr(name, varAddr) {
    .return name + ":  $" + toHexString(varAddr)
}
.print(printAddr("dividend", dividend))
.print(printAddr("divisor", divisor))
.print(printAddr("remainder", remainder))
