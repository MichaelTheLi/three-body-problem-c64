# Acceleration to center with fixed-point arithmetics and more accurate gravitation application

## Tasks

* Fixed-point calculations
* [Gravity law](https://en.wikipedia.org/wiki/Gravitational_acceleration) applied 

## Results

### Fixed point calculations

![debugger1.png](images/debuggerFixedPoint.gif)

Issues faced:

* doubleword vs word arithmetics mixed up in vector lib
* Some tuning in scaling factor was necessary, Q6.10 overshooting. Now works in Q10.6 
* VSync removed. Should update physics more often than graphics 

### Gravity law

#### Gravity field
`g = -1 * r * ((G * M) / d ^ 2)`

where:

* `M` is large mass,
* `d` is distance between masses 
* `r` is unit-vector

#### Attraction force

`F = m * g`

where:

* `m` is sample mass
* `g` is gravity field

#### Calculation

Without masses, just scale force with inverted distance square

#### Result
None, will implement in the next try, need to check if division works correctly
1