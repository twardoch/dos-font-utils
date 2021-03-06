## METRXPRS.EXE
**“Metrics assistance” tool for AFM font files.**

This program corrects the `.AFM` font metric files according to special metrics equality (`.MEQ`) tables so that the metrics of the “child glyphs”, i.e. of composite glyphs like `Aacute` will be adjusted to fit the metrics of the “parent glyphs”, i.e. of the basic components (like `A`). Written when I used FontLab 3.0 which did not have a “metrics assistance” function. 
```
------------------------------------------------------------------------------
SYNTAX:    METRXPRS.EXE <AFM-INFILE> <AFM-OUTFILE> <MEQ-FILE>
WHERE:     <AFM-INFILE>     is the font metric file to be corrected
           <AFM-OUTFILE>    is the target font metric file
           <MEQ-FILE>       is the table of equalities
EXAMPLE:   METRXPRS.EXE INPUT.AFM OUTPUT.AFM ANSI.MEQ
------------------------------------------------------------------------------
SYNTAX OF THE MEQ EQUALITY FILE:
           <child glyphname><space><parent glyphname><enter>
           <child glyphname><space><parent glyphname><enter>
           ...
------------------------------------------------------------------------------
```

Copyright © 1998-2015 by Adam Twardoch. Published under the [Apache 2](/LICENSE) license at http://github.com/twardoch . 

Originally written in 1998 in QBasic, rewritten in 2015 using [FreeBasic](http://www.freebasic.net/). The repository contains `METRXPRS.BAS`, the source code of the current version written in FreeBasic. To build, use `fbc -lang qb METRXPRS.BAS`. It also contains `METRXPRS.EXE`, a version that runs under Windows (in command line mode). Sample files `ANSI.MEQ`, `ORIG.AFM`, `METR.AFM` are included. 
