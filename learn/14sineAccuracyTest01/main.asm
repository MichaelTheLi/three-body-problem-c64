#import "fp_arith.asm"

.const FP = 13
.const FP2 = pow(2, FP)

*=$1000 "Start"
    sineByParabola(degree, res, degree90, tmp, tmp2, tmp3, one, FP)

*=$2000 "Data"
    degree: .word 45
    res: .word 0
	one: .word 1 * FP2
	tmp: .dword 0
	tmp2: .dword 0
	tmp3: .dword 0
	degree90: .word 90 // 23040 is 90 in fixedPoint notation
    degree1to90: .word ceil(1 / 90 * FP2) // 3 is 1/90 in Q8.8fixedPoint notation

// implements parabola approximation 1-((A-90)/90)^2
.macro sineByParabola(degree, resAddr, degree90, tmp, tmp2, tmp3, one, f) {
label:
    subFixedPoint(degree90, degree, tmp2)
    mul16bit(tmp2, degree1to90, tmp)    // Replaced  x / 90  with  x * (1/90)
                                        // Also multiplying in simple int format,
                                        // so more chances to fit into 16bit

    copy32bit(tmp, tmp2)

    mulFixedPoint(tmp, tmp2, tmp3, f)

    subFixedPoint(one, tmp3, resAddr)
}

.print("deg:    $" + toHexString(degree))
.print("res:    $" + toHexString(res))
.print("tmp:    $" + toHexString(tmp))
.print("tmp2:   $" + toHexString(tmp2))
.print("tmp3:   $" + toHexString(tmp3))
.print("FP:     " + FP)
.print("FP2:    " + FP2)
.print(ceil((1 / 90) * FP2))
.print(ceil((1 / 90) * FP2) / FP2)