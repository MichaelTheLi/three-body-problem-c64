# Multi-body gravity (3 body test)

## Tasks

* Fix forces calculation - it interfere and cancels, only last one applied

## Results

### Before

![debugger.png](images/before.gif)

Only one force per body, last one applied

### After

![debugger.png](images/after_with_even_masses.gif)

All forces applied. Some inaccuracies lead to overall movement to the top left corner
All masses are the same

### Bonuses

![debugger.png](images/after_green_is_large.gif)

All masses are different, green body has the largest mass

## Next?

1. Bodies leaving screen. Camera tracking common mass center.
2. Better performance - all videos are 2x speed
3. Better library for bodies handling