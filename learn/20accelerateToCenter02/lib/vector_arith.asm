#importonce

#import "fp_arith.asm"

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

*=$2800 "Temp vectors"
    mulTmp: .dword 0, 0

.print("mulTmp x:  $" + toHexString(mulTmp))
.print("mulTmp y:  $" + toHexString(mulTmp + 4))

//.macro divVectors_16bitFP(vector1, vector2, vectorResult, f) {
//    mulFixedPoint(vector1, vector2, vectorResult, f)
//    mulFixedPoint(vector1+2, vector2+2, vectorResult+2, f)
//}
