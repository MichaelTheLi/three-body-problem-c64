# Fixed point scaling factors demo

## Tasks

* Try different fixed point formats

## Results

### 4 fractional digits of PI
Should be close to 3.14159
From Q8.8 to Q0.16

![debugger1.png](images/debugger.png)

Results looks similar to [wiki info about scaling factors](https://en.wikipedia.org/wiki/Fixed-point_arithmetic#Choice_of_scaling_factors)

### 4 fractional digits of 0.123456789

![debugger1.png](images/debugger2.png)

Again, as expected

## Update after part 2

Not an actual fixed-point arithmetics, multiplying by the actual 2 is not the same as multiplying in fixed-point. Should be 2 in FP, like 2 * 256 in Q8.8