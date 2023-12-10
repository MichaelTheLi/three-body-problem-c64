#importonce

#import "int_arith.asm"

.macro addFixedPoint(num1addr, num2addr, resaddr) {
	add16bit(num1addr, num2addr, resaddr)
}

.macro subFixedPoint(num1addr, num2addr, resaddr) {
	sub16bit(num1addr, num2addr, resaddr)
}

.macro mulFixedPoint(multiplier, multiplicand, product) {
    mul16bit(multiplier, multiplicand, product)
}

.macro divFixedPoint(dividend, divisor, remainder) {
    scaleUpFixedPoint(6, dividend)
    div16bit(dividend, divisor, remainder)
    scaleUpFixedPoint(8-6, dividend) // 8-6 = 2
}

.macro scaleUpFixedPoint(num, addr) {
    shiftLeft16bit(num, addr)
}

.macro scaleDownFixedPoint(num, addr) {
    shiftRight16bit(num, addr)
}
