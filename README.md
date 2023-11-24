# Three-body problem Commodore 64

Just for fun project, trying to solve some close-to-real-world-problem in the limitations of Commodore 64
 
Developed using these awesome tools:
* [Relaunch64 IDE](http://www.popelganda.de/relaunch64.html)
* [VICE emulator](https://vice-emu.sourceforge.io/)
* [Retro Debugger](https://github.com/slajerek/RetroDebugger)
* [KickAssembler](http://www.theweb.dk/KickAssembler/Main.html#frontpage)

## Running
Binaries can be found in releases on built from sources and can be run using C64 emulator like VICE or any online C64 emulators, load an .prg binary using the emulator's manuals.
Most of the programs are executed by using `SYS 4096` C64 command 

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
