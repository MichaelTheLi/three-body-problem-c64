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
    mulFixedPoint(vector1+2, vector2+2, vectorResult+2, f)
}

//.macro divVectors_16bitFP(vector1, vector2, vectorResult, f) {
//    mulFixedPoint(vector1, vector2, vectorResult, f)
//    mulFixedPoint(vector1+2, vector2+2, vectorResult+2, f)
//}
