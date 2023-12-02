#import "sine.asm"

*=$1000 "Start"
    jmp $4000
*=$4000 "Main"
    generateSineTable(counter, sinValues, sinTable, tmpDegree, tmpRes, tmp, tmp2, tmp3, one)

values:
    sinValue(sinValue1, tempRes1, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 75 degree,   Expecting 0.965,    247 in Q8.8
    sinValue(sinValue2, tempRes2, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 57 degree,   Expecting 0.838,    214 in Q8.8
    sinValue(sinValue3, tempRes3, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 45 degree,   Expecting 0.707,    181 in Q8.8
    sinValue(sinValue4, tempRes4, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 23 degree,   Expecting 0.390,    100 in Q8.8
    sinValue(sinValue5, tempRes5, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 90 degree,   Expecting 1.000,    256 in Q8.8
    sinValue(sinValue6, tempRes6, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 135 degree,  Expecting 0.707,    181 in Q8.8
    sinValue(sinValue7, tempRes7, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 180 degree,  Expecting 0.000,    0   in Q8.8
    sinValue(sinValue8, tempRes8, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 225 degree,  Expecting -0.707,   -181 in Q8.8
    sinValue(sinValue9, tempRes9, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)       // 270 degree,  Expecting -1.000,   -256 in Q8.8
    sinValue(sinValue10, tempRes10, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)     // 315 degree,  Expecting -0.707,   -181 in Q8.8
    sinValue(sinValue11, tempRes11, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)     // 360 degree,  Expecting 0.000,    0 in Q8.8
    sinValue(sinValue12, tempRes12, sin360Deg, sin90Deg, sinZero, sinTmp, sin2Tmp, sinDegree, quad)     // 405 degree,  Expecting 0.707,    181 in Q8.8
	rts	

.print("tmpRes:  $" + toHexString(tmpRes))
.print("valuesStart:  $" + toHexString(values))
.print("sinValues start:  $" + toHexString(sinValues))
.print("sinValues end:  $" + toHexString(sinTable-1))
.print("sinTable start:  $" + toHexString(sinTable))
.print("sinTable end:  $" + toHexString(reminder-1))

.print("tempRes1:  $" + toHexString(tempRes1))
.print("tempRes2:  $" + toHexString(tempRes2))
.print("tempRes3:  $" + toHexString(tempRes3))
.print("tempRes4:  $" + toHexString(tempRes4))
.print("tempRes5:  $" + toHexString(tempRes5))
.print("tempRes6:  $" + toHexString(tempRes6))
.print("tempRes7:  $" + toHexString(tempRes7))
.print("tempRes8:  $" + toHexString(tempRes8))
.print("tempRes9:  $" + toHexString(tempRes9))
.print("tempRes10:  $" + toHexString(tempRes10))
.print("tempRes11:  $" + toHexString(tempRes11))
.print("tempRes12:  $" + toHexString(tempRes12))

*=$2000 "Data"
    tmpDegree: .word 0
    tmpRes: .word 0
    align: .byte 0
    sinValues: .fill 256, i
    sinTable: .fillword 256, 0

    tempRes1: .word 0
    tempRes2: .word 0
    tempRes3: .word 0
    tempRes4: .word 0
    tempRes5: .word 0
    tempRes6: .word 0
    tempRes7: .word 0
    tempRes8: .word 0
    tempRes9: .word 0
    tempRes10: .word 0
    tempRes11: .word 0
    tempRes12: .word 0

    quad: .byte 0
    sinZero: .word 0
    sinDegree: .word 0
    sinRemainder: .word 0
    sin360Deg: .word 360
    sin90Deg: .word 90
    sinTmp: .word 0
    sin2Tmp: .word 0

    sinValue1: .word 75
    sinValue2: .word 57
    sinValue3: .word 45
    sinValue4: .word 23
    sinValue5: .word 90
    sinValue6: .word 135
    sinValue7: .word 180
    sinValue8: .word 225
    sinValue9: .word 270
    sinValue10: .word 315
    sinValue11: .word 360
    sinValue12: .word 405

	reminder: .word 0
	degree90: .word 23040 // 23040 is 90 in fixedPoint notation
	degree1to90: .word 3 // 23040 is 90 in fixedPoint notation
	one: .word 256
	counter: .byte 180 // 90 * 2 because word-base output table
	
	tmp: .dword 0
	tmp2: .dword 0
	tmp3: .dword 0
