# Sine table continued

## Tasks
* ~~Should try to lower values in formulas with scaling down input degrees~~
* ~~Should try to use another fixed-point format~~
* ~~Should implement rescale funcs, up and down~~ 
* Full quadrant generation

## Results
Generated one quadrant on sine
```asm
    sinValueTest(75, tempRes1)  // Expecting 0.965, or 247 in Q8.8
    sinValueTest(57, tempRes2)  // Expecting 0.838, or 214 in Q8.8
    sinValueTest(45, tempRes3)  // Expecting 0.707, or 181 in Q8.8
    sinValueTest(23, tempRes4)  // Expecting 0.390, or 100 in Q8.8
```

![Image from the debugger](images/debugger.png)
