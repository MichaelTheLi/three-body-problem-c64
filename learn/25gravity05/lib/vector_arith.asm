#importonce

#import "fp_arith.asm"

.const divf = 6
.const divfValue = pow(2, divf)

.macro addVectors_16bitFP(vector1, vector2, vectorResult) {
	addFixedPoint(vector1, vector2, vectorResult)
	addFixedPoint(vector1+2, vector2+2, vectorResult+2)
}

.macro subVectors_16bitFP(vector1, vector2, vectorResult) {
	subFixedPoint(vector1, vector2, vectorResult)
	subFixedPoint(vector1+2, vector2+2, vectorResult+2)
}

.macro mulVectors_16bitFP(vector1, vector2, vectorResult, f) {
    mulFixedPoint(vector1, vector2, vectorResult, f)
    mulFixedPoint(vector1+2, vector2+2, vectorResult+4, f)
}

.macro mulVectorsWith16bitRes_16bitFP(vector1, vector2, vectorResult, f) {
    mulVectors_16bitFP(vector1, vector2, mulTmp, f)

    copy16bit(mulTmp, vectorResult)
    copy16bit(mulTmp + 4, vectorResult + 2) // Additional offset because dword format of tmp
}

.macro mulVectors_16bit(vector1, vector2, vectorResult) {
    mul16bit(vector1, vector2, vectorResult)
    mul16bit(vector1+2, vector2+2, vectorResult+4)
}

.macro mulVectorsWith16bitRes_16bit(vector1, vector2, vectorResult) {
    mulVectors_16bit(vector1, vector2, mulTmp)

    copy16bit(mulTmp, vectorResult)
    copy16bit(mulTmp + 4, vectorResult + 2) // Additional offset because dword format of tmp
}



.macro mulVectorWithScalar_16bitFP(vector, scalar, vectorResult, f) {
    mulFixedPoint(vector, scalar, vectorResult, f)
    mulFixedPoint(vector+2, scalar, vectorResult+4, f) // Because result is 32bit
}

.macro mulVectorWithScalarWith16bitRes_16bitFP(vector, scalar, vectorResult, f) {
    mulVectorWithScalar_16bitFP(vector, scalar, mulTmp, f)

    copy16bit(mulTmp, vectorResult)
    copy16bit(mulTmp + 4, vectorResult +2) // Additional offset because dword format of tmp
}


.macro copyVector_16bitFP(vector, dest) {
    copy16bit(vector, dest)
    copy16bit(vector+2, dest+2)
}

.macro divVectors_16bitFP(vector1, vector2, remainder, f, scaleDiv) {
    divFixedPoint(vector1, vector2, remainder, f, scaleDiv)
    divFixedPoint(vector1+2, vector2+2, remainder+2, f, scaleDiv)
}

.macro divVectors_16bit(vector1, vector2, remainder) {
    div16bit(vector1, vector2, remainder)
    div16bit(vector1+2, vector2+2, remainder+2)
}

*=$2800 "Temp vectors"
    mulTmp: .dword 0, 0
    divTmp: .word 0, 0
    oneVectorFPdiv: .word 1 * divfValue, 1 * divfValue
    oneVector: .word 1, 1

.function printVectAddr(name, varAddr) {
    .return name + "|  x: $" + toHexString(varAddr) + " y:" + " $" + toHexString(varAddr+2)
}

.print(printVectAddr("mulTmp", mulTmp))
.print(printVectAddr("oneVector", oneVector))
.print(printVectAddr("oneVectorFP", oneVectorFP))
.print(printVectAddr("mulTmp", mulTmp))

