#importonce

#import "int_arith.asm"

.macro addFixedPoint(num1addr, num2addr, resaddr) {
	add16bit(num1addr, num2addr, resaddr)
}

.macro subFixedPoint(num1addr, num2addr, resaddr) {
	sub16bit(num1addr, num2addr, resaddr)
}

.macro mulFixedPoint(multiplier, multiplicand, product, f) {
    mul16bit(multiplier, multiplicand, product)
    shiftRight32bit(f, product)
}

.macro divFixedPoint(dividend, divisor, remainder, f, scaleDiv) {
    shiftLeft16bit(scaleDiv, dividend)
    div16bit(dividend, divisor, remainder)
.if (f-scaleDiv > 0) {
    shiftLeft16bit(f-scaleDiv, dividend)
} else {
    shiftRight16bit(scaleDiv-f, dividend)
}
    shiftRight16bit(scaleDiv, remainder)
}
