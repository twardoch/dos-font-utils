# dos-font-utils

A collection of command-line font utility programs originally written in the late 1990s in BASIC for MS-DOS, and later rewritten in FreeBasic for compatibility with modern systems (Windows, Linux). These tools are primarily aimed at developers and typographers working with older font formats or requiring fine-grained control over font metrics and bitmap font editing.

Published under the [Apache 2.0 License](/LICENSE).

**Author:** Adam Twardoch <adam@twardoch.com>
**Contributors:** Adam Twardoch <adam@twardoch.com>
**Homepage:** [https://github.com/twardoch/dos-font-utils](https://github.com/twardoch/dos-font-utils)

## Table of Contents

*   [Overview](#overview)
    *   [POLFED32.EXE - Bitmap Font Editor](#polfed32exe---bitmap-font-editor)
    *   [METRXPRS.EXE - AFM Metrics Adjuster](#metrxprsexe---afm-metrics-adjuster)
*   [Who is this for?](#who-is-this-for)
*   [Why is it useful?](#why-is-it-useful)
*   [Installation](#installation)
    *   [Running the Executables](#running-the-executables)
    *   [Building from Source](#building-from-source)
*   [Usage](#usage)
    *   [POLFED32.EXE](#polfed32exe)
        *   [Command Line](#command-line)
        *   [Programmatic Use](#programmatic-use)
    *   [METRXPRS.EXE](#metrxprsexe)
        *   [Command Line](#command-line-1)
        *   [Programmatic Use](#programmatic-use-1)
*   [Technical Deep-Dive](#technical-deep-dive)
    *   [POLFED32.EXE Internals](#polfed32exe-internals)
        *   [Font File Format](#font-file-format)
        *   [User Interface](#user-interface)
        *   [Key Features](#key-features)
        *   [POLFED16.EXE (Historical)](#polfed16exe-historical)
    *   [METRXPRS.EXE Internals](#metrxprsexe-internals)
        *   [AFM File Processing](#afm-file-processing)
        *   [MEQ File Format](#meq-file-format)
*   [Coding and Contribution Rules](#coding-and-contribution-rules)
    *   [Coding Conventions](#coding-conventions)
    *   [Contributing](#contributing)

## Overview

This project provides two main utilities:

### POLFED32.EXE - Bitmap Font Editor

`POLFED32.EXE` is a powerful command-line editor for creating and modifying bitmap screen fonts, primarily those used in DOS text-mode environments. It allows for pixel-level manipulation of glyphs within a font file.

*   **Key Features:** Edits simple bitmap font formats, supports various glyph heights (8, 14, 16, 20 pixels), multiple clipboards, glyph shifting/mirroring effects, and a pattern-making function.
*   **Origin:** Originally written in QBasic (1994), then Visual Basic for DOS (1998), and rewritten in FreeBasic (2015).

### METRXPRS.EXE - AFM Metrics Adjuster

`METRXPRS.EXE` (Metrics Express) is a "metrics assistance" tool designed to process Adobe Font Metrics (`.AFM`) files. It corrects the metrics of composite glyphs (e.g., `Aacute`) to align with their base glyphs (e.g., `A`) based on user-defined equality tables.

*   **Key Features:** Adjusts character width and bounding box information in `.AFM` files according to specified parent-child glyph relationships in a `.MEQ` file.
*   **Origin:** Originally written in QBasic (1998) and rewritten in FreeBasic (2015). Developed to assist with font production workflows, particularly with older versions of font editing software like FontLab 3.0.

## Who is this for?

These tools are primarily for:

*   **Type Designers & Font Developers:** Especially those working with legacy font projects or needing precise control over AFM files or DOS-era bitmap fonts.
*   **Retrocomputing Enthusiasts:** Individuals interested in DOS-era software development or customizing text-mode environments.
*   **Software Developers:** Those who might need to manipulate or generate simple bitmap fonts or AFM files programmatically or as part of a larger toolchain.

## Why is it useful?

*   **POLFED32.EXE:**
    *   Provides a dedicated editor for a niche font format.
    *   Offers pixel-level control for creating custom DOS screen fonts or modifying existing ones.
    *   Useful for localizing old DOS applications or creating unique visual styles in text-mode programs.
*   **METRXPRS.EXE:**
    *   Automates the tedious process of ensuring metric consistency between base glyphs and their accented or composite counterparts in AFM files.
    *   Can be crucial for maintaining visual harmony and correct spacing in fonts, especially those with many composite characters.
    *   Helps bridge functionality gaps in older font editing software.

## Installation

### Running the Executables

Pre-compiled Windows executables (`POLFED32.EXE`, `METRXPRS.EXE`) are provided in their respective subdirectories (`POLFED/` and `METRXPRS/`). These are command-line tools.

*   **Windows:** Can be run directly from a Command Prompt (`cmd.exe`) or PowerShell.
*   **Linux/macOS:** The FreeBasic source code can be compiled on these platforms (see below). For running DOS executables (like the historical `POLFED16.EXE`), an emulator like [DOSBox](https://www.dosbox.com/) would be required.

No special installation steps are typically needed other than placing the executables in a directory that is in your system's `PATH` or navigating to their directory to run them.

### Building from Source

The tools are written in FreeBasic and can be compiled using the FreeBasic compiler (`fbc`).

*   **Prerequisites:** Install the [FreeBasic compiler](http://www.freebasic.net/).
*   **Compilation:**
    *   For `METRXPRS.EXE`:
        ```bash
        cd METRXPRS
        fbc -lang qb METRXPRS.BAS
        ```
    *   For `POLFED32.EXE`:
        ```bash
        cd POLFED
        fbc -lang qb POLFED32.BAS
        ```
    The `-lang qb` option is used for compatibility with QBasic syntax elements.

## Usage

### POLFED32.EXE

#### Command Line

```
POLFED32.EXE INPUT.EXT [OUTPUT.EXT]
```

*   `INPUT.EXT`: The path to the input font file. The file extension determines the expected character height:
    *   `.CGA`: 8 pixels high
    *   `.EGA`: 14 pixels high
    *   `.VGA`: 16 pixels high (e.g., `DOSFONT.VGA`)
    *   `.XGA`: 20 pixels high
    *   `.F<nn>`: Custom height, where `<nn>` is a number from 4 to 20 (e.g., `.F10` for 10 pixels high).
*   `[OUTPUT.EXT]`: (Optional) The path to save the modified font file. If omitted, `POLFED32.EXE` will overwrite the `INPUT.EXT` file upon saving.

Upon execution, `POLFED32.EXE` opens an interactive text-based user interface (TUI) to edit the font. See the "POLFED32.EXE Internals" section for more on its features.

**Example:**
```bash
POLFED\POLFED32.EXE POLFED\DOSFONT.VGA POLFED\MYFONT.VGA
```

#### Programmatic Use

Direct programmatic use of `POLFED32.EXE` is not its primary design. However, one could automate its execution via shell scripts if batch processing of font files is needed, though interaction with its TUI would be complex to automate. The font file format itself (raw bitmap data) is simple and could be generated or manipulated by other custom programs.

### METRXPRS.EXE

#### Command Line

```
METRXPRS.EXE <AFM-INFILE> <AFM-OUTFILE> <MEQ-FILE>
```

*   `<AFM-INFILE>`: Path to the source Adobe Font Metrics (`.AFM`) file that needs correction.
*   `<AFM-OUTFILE>`: Path where the corrected `.AFM` file will be saved.
*   `<MEQ-FILE>`: Path to the "Metrics Equality" file. This plain text file defines which child glyphs should inherit metrics from which parent glyphs. (See [MEQ File Format](#meq-file-format) for details).

**Example:**
```bash
METRXPRS\METRXPRS.EXE METRXPRS\ORIG.AFM METRXPRS\METR_corrected.AFM METRXPRS\ANSI.MEQ
```
This command will process `ORIG.AFM` using rules from `ANSI.MEQ` and save the result to `METR_corrected.AFM`.

If incorrect arguments are provided, or if `/h` or `/?` is used as an argument, the program will display a help message with syntax instructions.

#### Programmatic Use

`METRXPRS.EXE` is well-suited for programmatic use in scripts or build processes due to its command-line nature and distinct input/output files. It can be easily integrated into automated font production workflows.

## Technical Deep-Dive

### POLFED32.EXE Internals

`POLFED32.EXE` is a sophisticated text-mode application that provides a visual environment for editing bitmap fonts.

#### Font File Format

`POLFED32` works with raw binary font files.
*   Each character in the font consists of a sequence of bytes.
*   Each byte represents one row of 8 pixels for the character.
*   The height of the character (number of rows/bytes per character) is determined by the input file's extension:
    *   `.CGA`: 8 lines/bytes
    *   `.EGA`: 14 lines/bytes
    *   `.VGA`: 16 lines/bytes
    *   `.XGA`: 20 lines/bytes
    *   `.F<nn>`: Custom height from 4 to 20 lines/bytes.
*   The font file is simply a concatenation of the bitmap data for all characters it contains (typically 256 characters for an extended ASCII set). For example, a `.VGA` font with 256 characters would be `256 * 16 = 4096` bytes in size.

#### User Interface

The editor presents a Text-based User Interface (TUI):
*   **Main View:** Displays a grid of all characters in the font. The currently selected character is highlighted.
*   **Character Editor View:** Shows a magnified, pixel-level view of the selected character, allowing direct manipulation of individual pixels.
*   **Information Panel:** Displays codes (DEC, HEX, ASCII) for the selected character and context-sensitive help (toggled with `ALT+H` through multiple help screens).
*   **Pixel Representation:** Different character pairs are used to represent 'on' and 'off' pixels, with alternative display modes available.

#### Key Features

*   **Pixel Editing:** Toggle individual pixels using the spacebar within the editor view. Arrow keys move the editing cursor.
*   **Character Navigation:** Use arrow keys, PgUp/PgDn in the main view to select characters.
*   **Effects (available in both main view and editor view via numeric keypad or dedicated keys):**
    *   `0`: Clear character
    *   `5`: Invert character (flips black/white pixels)
    *   `7`: Horizontal mirror
    *   `9`: Vertical mirror
    *   `8, 2, 4, 6` (numpad): Shift character pixels up, down, left, right respectively.
    *   `Alt+P` (in editor): Pattern fill (repeats the current pixel pattern downwards).
*   **Clipboard:**
    *   `F1-F4`: Copy current character to clipboard buffer 1-4.
    *   `Ctrl+F1-F4`: Paste from clipboard buffer 1-4 to current character.
    *   `Shift+F1-F4`: View character in clipboard buffer 1-4.
    *   `Alt+F1-F4`: Clear clipboard buffer 1-4.
*   **Undo:** `Backspace` key provides a single-level undo for the last modification to a character.
*   **Saving/Exiting:**
    *   `Alt+X`: Prompts to save and exit.
    *   `Alt+Q`: Prompts to quit without saving.
*   **Sound Toggle:** `F9` toggles sound effects.
*   **Alternate Display:** `F10` cycles through different pixel display styles.

#### POLFED16.EXE (Historical)

The `POLFED` directory also contains `POLFED16.EXE`. This is an older version of the editor, written in Visual Basic for DOS.
*   It runs in DOS mode only (requires an emulator like DOSBox on modern systems).
*   It does **not** accept command-line arguments for file input/output. Instead, it features a "fancy" (for its time) UI for opening and saving files.
*   The source code for this version is not provided.

### METRXPRS.EXE Internals

`METRXPRS.EXE` processes AFM files based on rules in a MEQ file.

#### AFM File Processing

The program (`METRXPRS.BAS`) operates as follows:
1.  **Argument Parsing:** Reads the input AFM, output AFM, and MEQ file paths from the command line.
2.  **MEQ File Parsing:**
    *   Reads the `MEQ-FILE`. Each line is parsed into a child glyph name and a parent glyph name.
    *   These pairs are stored in an array (e.g., `MEQ$`).
    *   A list of unique parent glyph names is also created (e.g., `UNQ$`).
3.  **Parent Metrics Collection:**
    *   The `AFM-INFILE` is read.
    *   For each character metric line (`C ... N <glyphname> ...`), if `<glyphname>` is in the list of unique parent glyphs, its metrics (character code, width `WX`, and bounding box `B llx lly urx ury`) are stored.
4.  **Child Metrics Adjustment and Output:**
    *   The `AFM-INFILE` is read again, line by line.
    *   Non-character metric lines (headers, comments, kerning data) are written to `AFM-OUTFILE` as-is.
    *   For each character metric line:
        *   The glyph name is extracted.
        *   If this glyph name is found as a "child" in the `MEQ$` array:
            *   Its corresponding "parent" glyph name is retrieved.
            *   The stored metrics (specifically `WX`, `B0` (llx), and `B2` (urx)) of the parent glyph are used to replace those of the child glyph. The `B1` (lly) and `B3` (ury) values, as well as the character code and glyph name, are preserved from the original child glyph entry.
        *   The (potentially modified) character metric line is written to `AFM-OUTFILE`.
5.  **Summary:** After processing, the program prints the number of glyphs whose metrics were corrected.

The core logic ensures that composite characters like 'Aacute' will have the same width and horizontal bounding box extents as their base character 'A', if specified in the MEQ file.

#### MEQ File Format

The Metrics Equality (`.MEQ`) file is a simple plain text file.
*   Each line defines one equality rule.
*   The format of each line is: `<child_glyphname> <space> <parent_glyphname>`
*   Example:
    ```
    Aacute A
    Agrave A
    eacute e
    ```
    This tells `METRXPRS.EXE` to adjust the metrics of `Aacute` and `Agrave` based on `A`, and `eacute` based on `e`.

Sample files `ANSI.MEQ`, `ORIG.AFM` (input example), and `METR.AFM` (output example after processing `ORIG.AFM` with `ANSI.MEQ`) are provided in the `METRXPRS` directory.

## Coding and Contribution Rules

### Coding Conventions

As these tools are written in FreeBasic (with QBasic compatibility - `-lang qb`), any contributions to the `.BAS` source files should aim to:

*   **Maintain Clarity:** Write readable code. Use comments (`REM` or `'`) to explain complex sections.
*   **Variable Naming:** Follow existing patterns (e.g., string variables often end with `$`, integer variables may have no suffix or `%`).
*   **Modularity:** Use `SUB` and `FUNCTION` for procedures where appropriate.
*   **Compatibility:** Ensure changes are compatible with FreeBasic and the `-lang qb` dialect if modifying existing logic.
*   **Error Handling:** Implement or maintain basic error checking.

### Contributing

This project is maintained by Adam Twardoch. While it's a relatively small and mature project, contributions in the form of bug reports or feature suggestions are welcome.

*   **Bug Reports:** If you find a bug, please provide detailed steps to reproduce it, including sample input files if applicable, and the expected vs. actual behavior.
*   **Feature Suggestions:** Clearly describe the proposed feature and why it would be useful.
*   **Pull Requests:** If you wish to contribute code:
    1.  Fork the repository on GitHub.
    2.  Create a new branch for your changes.
    3.  Make your changes, adhering to the coding conventions.
    4.  Test your changes thoroughly.
    5.  Commit your changes with clear and descriptive messages.
    6.  Push your branch to your fork.
    7.  Open a pull request against the main `dos-font-utils` repository.

Please ensure any contributed code is also licensed under the Apache 2.0 License.
