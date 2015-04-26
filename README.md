# dos-font-utils
Old font utils written in the late 1990s in BASIC for DOS (now rewritten in FreeBASIC). Published under the [Apache 2](/LICENSE) license at http://github.com/twardoch . 

## [POLFED32.EXE](POLFED)
**Bitmap screen font editor for DOS text-mode fonts.** Opens and saves a simple bitmap format where each glyph is 8 pixels wide and 8-20 pixels high. Multiple clipboards, some glyph manipulation effects and really primitive UI.  

## [METRXPRS.EXE](METRXPRS)
**“Metrics assistance” tool for AFM font files**. This program corrects the `.AFM` font metric files according to special metrics equality (`.MEQ`) tables so that the metrics of the “child glyphs”, i.e. of composite glyphs like `Aacute` will be adjusted to fit the metrics of the “parent glyphs”, i.e. of the basic components (like `A`). 
