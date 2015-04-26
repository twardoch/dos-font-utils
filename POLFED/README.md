# POLFED32.EXE

**Bitmap screen font editor for DOS text-mode fonts.**

Opens a simple bitmap format: depending on file extension, each character is 8 (.CGA), 14 (.EGA), 16 (.VGA), 20 (.XGA) lines/bytes, and each line is 1 byte (8 bits). 

Has 4 built-in clipboard buffers for copy-paste, allows glyph shifting and mirroring and has a pattern-making function. I wrote the editor because I needed a Cyrillic font for my DOS window. I didn't have one, so I decided to make such a Cyrillic DOS font myself. Since I didn't have an editor, I wrote an editor. Once I finished writing the editor, I no longer needed the Cyrillic font, so I never made any single font with the app. :)  

![alt text](POLFED32.GIF "POLFED32.GIF")

Usage:
```
POLFED32.EXE INPUT.EXT [OUTPUT.EXT]
```
Example:
```
POLFED32.EXE DOSFONT.VGA DOSFONT1.VGA
```

Originally written in 1994 in QBasic, then in 1998 in Visual Basic for DOS, rewritten in 2015 using [FreeBasic](http://www.freebasic.net/). The repository contains `POLFED32.BAS`, the source code of the current version written in FreeBasic. To build, use `fbc -lang qb POLFED32.BAS`. It also contains `POLFED32.EXE`, a version that runs under Windows (in command line mode). For historical purposes, it also contains an older version `POLFED16.EXE` which is written in Visual Basic for DOS and runs in DOS mode only. 

Copyright (c) 1994-2015 by Adam Twardoch. Published under the [Apache 2](/LICENSE) license at http://github.com/twardoch . 
