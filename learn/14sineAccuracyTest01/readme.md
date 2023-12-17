# Sprite circle v2, with fixed fixed-points arithmetics

## Tasks
* Test different fp format for sine table

## Results
All should be close to 0.75
Real sine is 0.7071 but we are using parabola approximation

### Q8.8
![debugger1.png](images/debuggerq88.png)

### Q3.13
#### Original, with overflowing 16bit intermediate results
![debugger1.png](images/debuggerq313orig.png)
Because 1/90 is 92 in Q3.13, and 45 is 368640 (which is already more than 16bit)

And 92 * 368640 is certainly more than 16bit
#### Fixed

![debuggerQ313.png](images/debuggerQ313.png)

So, multiplying in simple ints
45 by 92 (0.111 is FP3.13)

it gives result that already in FP3.13 format, so no need to scale back

0.7446 is quite close to expected 0.75