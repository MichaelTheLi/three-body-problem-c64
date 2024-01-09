# Acceleration to center with gravity

## Tasks

* Fix glitches in previous implementation:
  1. Looks like sometimes velocity is lost midair, some kind of glitch
  2. Close to center of gravity there is extreme values not handled by the "clamp" function at the end of calculate func
  3. Outer bounds also breaks force gravitational calculation

## Results

![debugger.png](images/debugger.gif)

TBD