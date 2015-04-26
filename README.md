# dos-font-utils
Old font utils written in the late 1990s in BASIC for DOS (now rewritten in FreeBASIC). Published under the [Apache 2](/LICENSE) license at http://github.com/twardoch . 

## [METRXPRS.EXE](METRXPRS)
**"Metrics assistance" tool for AFM font files**
This program corrects the 'AFM' font metric files according to special metrics equality (MEQ) tables so that the metrics of the 'child glyphs', i.e. of composite glyphs like 'Aacute' will be adjusted to fit the metrics of the 'parent glyphs', i.e. of the basic components (like 'A'). 

## [POLFED32.EXE](POLFED)
**Bitmap screen font editor for DOS text-mode fonts.**
Opens a simple bitmap format: depending on file extension, each character is 8 (.CGA), 14 (.EGA), 16 (.VGA), 20 (.XGA) lines/bytes, and each line is 1 byte (8 bits). 
