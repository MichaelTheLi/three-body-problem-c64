*=$1000 "Main"
	clc
	lda num1
	adc num2
	sta res
	
	lda num1 + 1
	adc num2 + 1
	sta res + 1
	
	lda num1 + 2
	adc num2 + 2
	sta res + 2
	
	lda num1 + 3
	adc num2 + 3
	sta res + 3
	
	rts	
	
*=$1800 "Data"
	num1: .dword 4375 // This is 12.345, stored as LE (Little-Endian)
	num2: .dword 0 // This is 23.456, stored as LE
	res: .word 0, 0     // This should become 35.801, stored as LE
