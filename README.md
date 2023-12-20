# Three-body problem Commodore 64

Just for fun project, trying to solve some close-to-real-world-problem in the limitations of Commodore 64
 
Developed using these awesome tools:
* [Relaunch64 IDE](http://www.popelganda.de/relaunch64.html)
* [VICE emulator](https://vice-emu.sourceforge.io/)
* [Retro Debugger](https://github.com/slajerek/RetroDebugger)
* [KickAssembler](http://www.theweb.dk/KickAssembler/Main.html#frontpage)
## Content 
### Learn
These I used to better understand the limitations and mechanisms
* [Single letter print](learn/01print01/readme.md)
* [Single letter on-row moves](learn/02print02/readme.md)
* [Single letter on-whole-screen moves](learn/03print03/readme.md)
* [Fixed-point numbers tests](learn/04fixedPointNumber01/readme.md)
* [Fixed-point numbers arithmetics tests](learn/05fixedPointArithmetics01/readme.md)
* [Sine table generation v0.1](learn/06sineTable01/readme.md)
* [Sine table generation v0.2 - full table with lookup routine](learn/07sineTable02/readme.md)
* [Circling letter A, sin/cos example](learn/08circle01/readme.md)
* [Sprite basics, just show](learn/09sprite01/readme.md)
* [Circling sprite](learn/10spriteCircle/readme.md)
* [Fixed point](learn/11fixedPointScalingFactors01/readme.md)
* [More accurate usage of fixed point](learn/12fixedPointScalingFactors02/readme.md)
* [More experiments with fixed point](learn/13fixedPointScalingFactors03/readme.md)
* [Sine accuracy tests](learn/14sineAccuracyTest01/readme.md)
* [Circling sprite with better precision](learn/15spriteCircle02/readme.md)
* [Output FP demo, with limited accuracy](learn/16outputFixedPointOnScreen01/readme.md)
### Final product
TBD
## Running
Binaries can be found in releases on built from sources and can be run using C64 emulator like VICE or any online C64 emulators, load an .prg binary using the emulator's manuals.
Most of the programs are executed by using `SYS 4096` C64 command 

#### Requirements 
* [VICE emulator](https://vice-emu.sourceforge.io/)
* [Retro Debugger](https://github.com/slajerek/RetroDebugger)
* [KickAssembler](http://www.theweb.dk/KickAssembler/Main.html#frontpage)

```
make run
# or 
make debug
```

### Running with VICE
`[VICE_PATH]/bin/x64sc learn/print01/print01.prg`

### Running with RetroDebugger
`open [RETRO_DEBUGGER_PATH]/RetroDebugger.app learn/print01/print01.prg`

## Manual compiling
`java -jar /Applications/KickAssembler/KickAss.jar learn/print01/print01.asm`
The command above will produce print01.prg in the same folder, use KickAssembler manual if in doubt.
## Using a Relaunch64 IDE
Paths to KickAssembler and VICE are for MacOS, and may require some adjustments

### VICE
```bash
java -jar /Applications/KickAssembler/KickAss.jar RSOURCEFILE
/Applications/vice-x86-64-gtk3-3.7.1/bin/x64sc ROUTFILE
```

### Retro Debugger
```bash
java -jar /Applications/KickAssembler/KickAss.jar RSOURCEFILE
open /Applications/RetroDebugger/RetroDebugger.app ROUTFILE
```
