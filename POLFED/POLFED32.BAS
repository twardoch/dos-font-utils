DECLARE SUB ShowMainWindow ()
DECLARE SUB AppAbout ()
DECLARE SUB AppExit ()
DECLARE SUB AppExitError ()
DECLARE SUB ClrChar (CurrChar!)
DECLARE SUB CopyChar2Buf (CharFrom!, BufTo!)
DECLARE SUB CopyBuf2Char (BufFrom!, CharTo!)
DECLARE SUB Clr (CurrChar!)
DECLARE SUB Invert (CurrChar)
DECLARE SUB vMir (CurrChar)
DECLARE SUB hMir (CurrChar!)
DECLARE SUB Pattern (CurrChar!)
DECLARE SUB MoveDown (CurrChar!)
DECLARE SUB MoveUp (CurrChar!)
DECLARE SUB MoveRight (CurrChar!)
DECLARE SUB MoveLeft (CurrChar!)
DECLARE SUB ExitAsk ()
DECLARE SUB CommonNormKeys ()
DECLARE SUB EditReadKey ()
DECLARE SUB DisplayCharEdit (CurrChar!)
DECLARE SUB UndoChar (CurrChar!)
DECLARE SUB SaveUndoChar (CurrChar!)
DECLARE SUB ChangePoz ()
DECLARE SUB SaveCurrChar (CurrChar!)
DECLARE SUB CommonSpecKeys ()
DECLARE SUB MenuReadKey ()
DECLARE SUB DisplayCharView (CurrChar!)
DECLARE SUB EditChar (CurrChar)
DECLARE SUB HotKeys (Ver!)
DECLARE SUB BufSwitch (Buf!, Switch!)
DECLARE SUB ClrBuf (char!)
DECLARE SUB CopyChar (CharFrom!, CharTo!)
DECLARE SUB InputFileName ()
DECLARE SUB OutputFileName ()
DECLARE SUB ExitProg ()
DECLARE SUB SaveFont ()
DECLARE SUB OIfirst ()
DECLARE SUB OIlast ()
DECLARE SUB PrepChar ()
DECLARE SUB CheckASCIIpos (CurrChar!, X!, y!)
DECLARE SUB ReadKey ()
DECLARE SUB CheckCode (CurrChar!, A$, b$, C$, D$)
DECLARE SUB GetChar (CurrChar!)
DECLARE SUB CnvChar2Disp (v!)
DECLARE SUB FillSquare (y!, X!, l!, H!, char$)
DECLARE SUB NewInput (y, X, Text$, XLength, YHeight, Limit, Limit$, Terminate$, Default$)
DECLARE SUB Flash (y!, X!, XLength!)
DECLARE SUB Comline (N, A$(), Max)
DECLARE SUB GetComline (FontPathOpen$, FontPathSave$)

COMMON SHARED B0$(), Z0$(), OI$(), Font$, Buf$, Zn$(), H, w, K0, K1, K$, o$, i$
COMMON SHARED FontPathSave$, FontPathOpen$, o0$, i0$, i1$, Yof, Xof, xo, yo
COMMON SHARED FontPathExt$, LastChar, OST, CurrChar, Undo$
COMMON SHARED DispEnd$, AltDisplay, Esc, AktX, AktY, AktZn$, AktCur$
COMMON SHARED SndSwitch, Quit, Hot, BUFused
COMMON SHARED PathName$
COMMON SHARED PolFEDversion$, PolFEDerror$

' =============================================================================
' ============================= POLFED ========================================
' =============================================================================
' DOS font editor
' Copyright (c) 1994, 1997, 2015 by Adam Twardoch
' Originally written 1994 in QBasic, then 1998 Visual Basic for DOS
' Rewritten in FreeBASIC in 2015. 
' Published under the Apache 2 opensource license
' http://github.com/twardoch
' 
' This app 
' 
' Version 2.002
' HISTORY: 
' v2.002 (2015-04-26): rewritten using FreeBASIC
' v2.001 (1997-07-30): rewritten using MS Visual Basic for DOS
' v1.000 (1994.12.27): written using QBasic

PolFEDversion$ = "2.002"

' # PREPARATION, DATA INPUT

CLS
CALL InputFileName
DIM SHARED Zn$(H)
DIM SHARED OI$(0 TO 15)
DIM SHARED B0$(2), Z0$(2)
DIM SHARED Undo(10, H)

Xof = 1
Yof = 0
UndoLevel = 1
SndSwitch = -1
Save% = 1

CALL ShowMainWindow ()

' # OPEN AND READ FONT FILE

CALL Flash(Yof + 6, Xof + 3, 7)
LOCATE Yof + 6, Xof + 3, 0
PRINT "READING"
LOCATE Yof + 4, Xof + 24, 0
PRINT LEFT$(PathName$, 28)
LOCATE Yof + 6, Xof + 26, 0
PRINT FileName$

AktX = 4
AktY = INT(H / 2)

OPEN FontPathOpen$ FOR BINARY AS 1
CurrChar = 0

' ## Reading file

Font$ = INPUT$(10000, #1)
OST = LEN(Font$)
LastChar = OST / H - 1
IF LastChar <> INT(OST / H) - 1 THEN PRINT "BAD": CALL AppExitError ()
CLOSE #1

' ## Setting buffer
FOR w = 1 TO H
    A$ = A$ + CHR$(0)
NEXT w
FOR w = 1 TO 4
    Font$ = Font$ + A$
NEXT w

' # BEGIN EDITING

IntroGoto:
'ON ERROR GOTO 0
IF Esc = 1 THEN CALL ShowMainWindow ()
Quit = 0
Esc = 0

CALL Flash(Yof + 6, Xof + 3, 7)
LOCATE Yof + 6, Xof + 3, 0
PRINT "EDITING the font file"

CALL Flash(Yof + 6, Xof + 39, 13)
LOCATE Yof + 6, Xof + 40, 0
PRINT " CHARACTER  "
LOCATE Yof + 7, Xof + 40, 0
PRINT "   CODE:"

' # MENU WORK
' ## Intro

xo = Xof + 52: yo = Yof + 1
DispEnd$ = "ศออออออออออออออออผ"
CALL OIfirst
CALL PrepChar
CurrChar = 0
CALL HotKeys(0)

' ## Select char

MenuGoto:
Esc = 0
DO
    CALL DisplayCharView(CurrChar)
    CALL MenuReadKey
LOOP UNTIL Quit

CALL ExitProg
GOTO IntroGoto

' # EDIT CHAR
' See SUB Edit
END

' # SUBROUTINES
ErrHandlerGoto:
PRINT "Error!"
END

SUB BufSwitch (Buf, Switch)    
    PosY = 8
    PosX = 8 + 2 * Buf
    XX = Xof + PosX + 4
    YY = Yof + PosY + 8
    
    LOCATE YY, XX, 0
    SELECT CASE Switch
    CASE 0
        PRINT " "
    CASE ELSE
        PRINT "๚"
    END SELECT
END SUB

SUB ChangePoz ()
    ' ON/OFF pixel in position (AktX,AktY) if space pressed
    IF AktZn$ = i$ THEN
        AktZn$ = o$
    ELSE
        AktZn$ = i$
    END IF
    
    MID$(Zn$(AktY), AktX * 2 - 1, 2) = AktZn$
    
END SUB

SUB CheckASCIIpos (CurrChar, XX, YY)
    
    SELECT CASE CurrChar
    
    CASE IS > LastChar
        PosY = 8: PosX = 7 + 2 * (CurrChar - LastChar) ' Buffers
    CASE IS > 255
        PosY = 8: PosX = 31                       ' Additional Chars (above 255)
    CASE IS > 31
        PosY = INT(CurrChar / 32)             ' Displayable ASCII
        PosX = CurrChar - PosY * 32
    CASE IS >= 0
        
        PosY = 0: PosX = 0                ' Control Chars
    CASE ELSE
    END SELECT
    
    XX = Xof + PosX + 4
    YY = Yof + PosY + 8
END SUB

SUB CheckCode (CurrChar, A$, b$, C$, D$)
    D$ = "ASCII: "
    A$ = LTRIM$(STR$(ABS(CurrChar)))
    A$ = STRING$(3 - LEN(A$), " ") + A$
    b$ = HEX$(ABS(CurrChar))
    b$ = STRING$(3 - LEN(b$), " ") + b$
    C$ = "  "
    IF CurrChar > 31 AND CurrChar < 256 THEN
        C$ = C$ + CHR$(CurrChar)
    ELSE
        IF CurrChar > LastChar THEN
            C$ = "-" + LTRIM$(STR$(CurrChar - LastChar)) + "-": A$ = "---"
            b$ = A$
            D$ = "  BUF: "
        ELSE
            IF CurrChar < 32 THEN
                CALL SpecChars (C$)
            ELSE
                IF CurrChar > 255 THEN
                    D$ = " CODE: "
                    C$ = LTRIM$(STR$(CurrChar - 256))
                    C$ = STRING$(3 - LEN(C$), " ") + C$
                END IF
            END IF
        END IF
    END IF
    EXIT SUB
END SUB

SUB SpecChars (C$)
    SELECT CASE CurrChar
    ' Control Characters
    CASE 0: C$ = "nul"
    CASE 1: C$ = "soh"
    CASE 2: C$ = "stx"
    CASE 3: C$ = "etx"
    CASE 4: C$ = "eot"
    CASE 5: C$ = "enq"
    CASE 6: C$ = "ack"
    CASE 7: C$ = "bel"
    CASE 8: C$ = " bs"
    CASE 9: C$ = "tab"
    CASE 10: C$ = " lf"
    CASE 11: C$ = " vt"
    CASE 12: C$ = " np"
    CASE 13: C$ = " cr"
    CASE 14: C$ = " so"
    CASE 15: C$ = " si"
    CASE 16: C$ = "dle"
    CASE 17: C$ = "dc1"
    CASE 18: C$ = "dc2"
    CASE 19: C$ = "dc3"
    CASE 20: C$ = "dc4"
    CASE 21: C$ = "nak"
    CASE 22: C$ = "syn"
    CASE 23: C$ = "etb"
    CASE 24: C$ = "can"
    CASE 25: C$ = " em"
    CASE 26: C$ = "eof"
    CASE 27: C$ = "esc"
    CASE 28: C$ = " fs"
    CASE 29: C$ = " gs"
    CASE 30: C$ = " rs"
    CASE 31: C$ = " us"
    END SELECT
END SUB

SUB Clr (CurrChar)
    
    FOR w = 1 TO H
        A$ = ""
        FOR X = 1 TO 8
            A$ = A$ + o$
        NEXT X
        Zn$(w) = A$
    NEXT w
    
END SUB

SUB ClrChar (CurrChar)
    MID$(Font$, CurrChar * H + 1, H) = STRING$(H, CHR$(0))
END SUB

SUB CommonNormKeys ()
    SELECT CASE K$
    
    CASE "8"
        CALL MoveUp(CurrChar)
    CASE "2"
        CALL MoveDown(CurrChar)
    CASE "4"
        CALL MoveLeft(CurrChar)
    CASE "6"
        CALL MoveRight(CurrChar)
    CASE "5"
        CALL Invert(CurrChar)
    CASE "7"
        CALL hMir(CurrChar)
    CASE "9"
        CALL vMir(CurrChar)
    CASE "0"
        CALL Clr(CurrChar)
    CASE ELSE
    END SELECT
END SUB

SUB CommonSpecKeys ()    
    ' BUFFER OPERATIONS '
    SELECT CASE K$
    
    ' Copy to buffer <Fx>
    ' f1
    CASE ";"
        CALL CopyChar(CurrChar, LastChar + 1)
        CALL BufSwitch(1, 1)
    ' f2
    CASE "<"
        CALL CopyChar(CurrChar, LastChar + 2)
        CALL BufSwitch(2, 1)
    ' f3
    CASE "="
        CALL CopyChar(CurrChar, LastChar + 3)
        CALL BufSwitch(3, 1)
    ' f4
    CASE ">"
        CALL CopyChar(CurrChar, LastChar + 4)
        CALL BufSwitch(4, 1)
        
    ' Copy from buffer Ctrl+<Fx>
    ' ct+f1
    CASE "^"
        CALL CopyChar(LastChar + 1, CurrChar)
    ' ct+f2
    CASE "_"
        CALL CopyChar(LastChar + 2, CurrChar)
    ' ct+f3
    CASE "`"
        CALL CopyChar(LastChar + 3, CurrChar)
    ' ct+f4
    CASE "a"
        CALL CopyChar(LastChar + 4, CurrChar)
        
    ' Display buffer Shift+<Fx>
    ' sh+f1
    CASE "T"
        IF BUFused = 0 THEN BUFused = CurrChar
        CurrChar = LastChar + 1
    ' sh+f2
    CASE "U"
        IF BUFused = 0 THEN BUFused = CurrChar
        CurrChar = LastChar + 2
    ' sh+f3
    CASE "V"
        IF BUFused = 0 THEN BUFused = CurrChar
        CurrChar = LastChar + 3
    ' sh+f4
    CASE "W"
        IF BUFused = 0 THEN BUFused = CurrChar
        CurrChar = LastChar + 4
        
    ' Clean buffer Alt+<Fx>
    ' alt+f1
    CASE "h"
        CALL ClrChar(LastChar + 1)
        CALL BufSwitch(1, 0)
    ' alt+f2
    CASE "i"
        CALL ClrChar(LastChar + 2)
        CALL BufSwitch(2, 0)
    ' alt+f3
    CASE "j"
        CALL ClrChar(LastChar + 3)
        CALL BufSwitch(3, 0)
    ' alt+f4
    CASE "k"
        CALL ClrChar(LastChar + 4)
        CALL BufSwitch(4, 0)
        
    ' F9  - Sound ON/OFF
    CASE "C"
        SndSwitch = NOT SndSwitch
        
    ' Alt Q - Quit, no Save
    CASE CHR$(16)
        Quit = 1
        Esc = 1
        
    ' Alt X - Save & Exit
    CASE "-"
        Quit = 2
        Esc = 1
        
    ' Alt H - More Help
    CASE "#"
        Hot = Hot + 1
        CALL HotKeys(Hot)
        
    'Alt I - Info Window
    'CASE CHR$(23)
    '    CALL PolFED
    '    CALL ShowMainWindow   'DOESN'T WORK (2.0)
        
    CASE ELSE
    END SELECT
END SUB

SUB CopyChar (CharFrom, CharTo)
    Undo$ = MID$(Font$, CharTo * H + 1, H)
    MID$(Font$, CharTo * H + 1, H) = MID$(Font$, CharFrom * H + 1, H)
END SUB

SUB DisplayCharEdit (CurrChar)
    ' Displaying the Char
    FOR w = 1 TO H
        LOCATE yo + w, xo + 1, 0
        PRINT Zn$(w)
    NEXT w
    
    ' Displaying the Cursor
    AktZn$ = MID$(Zn$(AktY), AktX * 2 - 1, 2)
    
    IF AktZn$ = i$ THEN
        AktCur$ = i0$
    ELSE
        AktCur$ = o0$
    END IF
    
    LOCATE yo + AktY, xo + AktX * 2 - 1, 0
    PRINT AktCur$
END SUB

SUB DisplayCharView (CurrChar)
    ' * Getting the Char
    CALL GetChar(CurrChar)
    
    FOR w = 1 TO H
        LOCATE yo + w, xo, 0
        PRINT "บ"; Zn$(w); "บ"
    NEXT w
    
    LOCATE yo + H + 1, xo, 0
    PRINT DispEnd$
    LOCATE yo + 2, xo: PRINT "น"
    LOCATE yo + 4, xo: PRINT "น"
    
    ' *** Display the code
    CALL CheckCode(CurrChar, A$, b$, C$, D$)
    LOCATE Yof + 8, Xof + 40, 0: PRINT "  DEC: "; A$
    LOCATE Yof + 9, Xof + 40, 0: PRINT "  HEX: "; b$
    LOCATE Yof + 10, Xof + 40, 0: PRINT D$; C$
    
    ' *** Display the position on the ASCII chart
    CALL CheckASCIIpos(CurrChar, XX, YY)
    LOCATE YY, XX, 1, 8
END SUB

SUB EditChar (CurrChar)
    CALL SaveUndoChar(CurrChar)
    DO
        CALL DisplayCharEdit(CurrChar)
        CALL EditReadKey
    LOOP UNTIL Esc = 1
END SUB

SUB EditReadKey ()
    EditReadKeyGoto:
    ' *** Read from keyboard ***
    CALL ReadKey
    
    ' Special keys
    IF K0 = 0 THEN
        SELECT CASE K$
        ' Left
        CASE "K"
            AktX = AktX - 1
            IF AktX < 1 THEN AktX = 8
        ' Right
        CASE "M"
            AktX = AktX + 1
            IF AktX > 8 THEN AktX = 1
        ' Up
        CASE "H"
            AktY = AktY - 1
            IF AktY < 1 THEN AktY = H
        ' Down
        CASE "P"
            AktY = AktY + 1
            IF AktY > H THEN AktY = 1
        ' AltP
        CASE CHR$(25)
            CALL Pattern(CurrChar)
           
        ' Other keys
        CASE ELSE
            CALL CommonSpecKeys
        END SELECT
        
        ' Alphanumeric keys
    ELSE
        SELECT CASE K$
        
        ' Space
        CASE " "
            CALL ChangePoz
            
        ' Enter
        CASE CHR$(13)
            CALL SaveCurrChar(CurrChar)
            Esc = 1
            
        ' Esc
        CASE CHR$(27)
            Esc = 1
            
        ' BkSp
        CASE CHR$(8)
            CALL UndoChar(CurrChar)
            
        ' Other keys
        CASE ELSE
            CALL CommonNormKeys
        END SELECT
        
    END IF
END SUB

SUB ExitAsk ()
    CALL Flash(Yof + 6, Xof + 3, 21)
    LOCATE Yof + 6, Xof + 3, 0
    IF Quit = 1 THEN
        PRINT "QUIT, NO SAVE (Y/N)?"
    ELSE
        PRINT "SAVE & EXIT (Y/N) ?"
    END IF
    
    CALL NewInput(Yof + 6, Xof + 23, Text$, 1, 1, 2, "YN", CHR$(13), "N")
    IF Text$ = "N" THEN
        Esc = 1
        LOCATE Yof + 6, Xof + 3, 0
        PRINT "FONT NOT SAVED!"
    END IF
END SUB

SUB ExitProg ()
    CALL ExitAsk
    IF Esc THEN EXIT SUB
    IF Quit > 1 THEN CALL SaveFont
    
    IF Esc THEN EXIT SUB
    
    CALL AppExit
END SUB

SUB FillSquare (y, X, l, H, char$)
    FOR YY = y TO y + H - 1
        FOR XX = X TO X + l - 1
            LOCATE YY, XX, 0
            PRINT char$
        NEXT XX
    NEXT YY
END SUB

SUB Flash (y, X, XLength)
    CALL FillSquare(y, X, XLength, 1, "Û")
    Pause = 0
    WHILE Pause < 100
        Pause = Pause + 1
    WEND
    CALL FillSquare(y, X, XLength, 1, "ฒ")
    CALL FillSquare(y, X, XLength, 1, "ฑ")
    CALL FillSquare(y, X, XLength, 1, "ฐ")
    CALL FillSquare(y, X, XLength, 1, " ")
END SUB

SUB GetChar (CurrChar)
    FOR w = 1 TO H
        Bajt = ASC(MID$(Font$, CurrChar * H + w, 1))
        b$ = HEX$(Bajt)
        IF LEN(b$) = 1 THEN b$ = "0" + b$
        B0$(1) = LEFT$(b$, 1)
        B0$(2) = RIGHT$(b$, 1)
        FOR b = 1 TO 2
            SELECT CASE B0$(b)
            CASE "0": Z0$(b) = OI$(0)
            CASE "1": Z0$(b) = OI$(1)
            CASE "2": Z0$(b) = OI$(2)
            CASE "3": Z0$(b) = OI$(3)
            CASE "4": Z0$(b) = OI$(4)
            CASE "5": Z0$(b) = OI$(5)
            CASE "6": Z0$(b) = OI$(6)
            CASE "7": Z0$(b) = OI$(7)
            CASE "8": Z0$(b) = OI$(8)
            CASE "9": Z0$(b) = OI$(9)
            CASE "A": Z0$(b) = OI$(10)
            CASE "B": Z0$(b) = OI$(11)
            CASE "C": Z0$(b) = OI$(12)
            CASE "D": Z0$(b) = OI$(13)
            CASE "E": Z0$(b) = OI$(14)
            CASE "F": Z0$(b) = OI$(15)
            END SELECT
        NEXT b
        Zn$(w) = Z0$(1) + Z0$(2)
    NEXT w
END SUB

SUB hMir (CurrChar)
    FOR w = 1 TO H
        A$ = Zn$(w)
        C$ = ""
        FOR X = 15 TO 1 STEP -2
            b$ = MID$(A$, X, 2)
            C$ = C$ + b$
        NEXT X
        Zn$(w) = C$
    NEXT w
END SUB

SUB HotKeys (Hot)
    HotGoto:
    SELECT CASE Hot
    
    CASE 0
        LOCATE Yof + 17, Xof + 1, 0
        PRINT "ฬออออออออออออออออออออออออออออหอออออออสออออออออออออป": LOCATE Yof + 18, Xof + 1, 0
        PRINT "บ POLFED Font Editor  v" + PolFEDversion$ + " บ ALT<H> to see HELP บ": LOCATE Yof + 19, Xof + 1, 0
        PRINT "วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤะฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ": LOCATE Yof + 20, Xof + 1, 0
        PRINT "บ DOS Font Editor                                 บ": LOCATE Yof + 21, Xof + 1, 0
        PRINT "บ File format: 8(.CGA) 14(.EGA) 16(.VGA) 20(.XGA) บ": LOCATE Yof + 22, Xof + 1, 0
        PRINT "บ    lines per char. Each line is 1 byte (8 bits) บ": LOCATE Yof + 23, Xof + 1, 0
        PRINT "บ http://github.com/twardoch FreeBASIC + Apache 2 บ": LOCATE Yof + 24, Xof + 1, 0
        PRINT "ศอออออออออออออออออออออออออออออออออออออออออออออออออผ";
        
    CASE 1
        LOCATE Yof + 17, Xof + 1, 0
        PRINT "ฬอออออออออออออออออออออออหออออออออออออสออออออออออออป": LOCATE Yof + 18, Xof + 1, 0
        PRINT "บ SELECT & MAIN OPTIONS บ ALT<H> to toggle HELP 1 บ": LOCATE Yof + 19, Xof + 1, 0
        PRINT "วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ": LOCATE Yof + 20, Xof + 1, 0
        PRINT "บ  cursor อ select char บ    <F9> อ sound on/off  บ": LOCATE Yof + 21, Xof + 1, 0
        PRINT "บ <Enter> อ edit char   บ   <F10> อ alt display   บ": LOCATE Yof + 22, Xof + 1, 0
        PRINT "บ  <BkSp> อ undo edit   บ  alt<X> อ save & exit   บ": LOCATE Yof + 23, Xof + 1, 0
        PRINT "บ                       บ  alt<Q> อ quit, no save บ": LOCATE Yof + 24, Xof + 1, 0
        PRINT "ศอออออออออออออออออออออออสอออออออออออออออออออออออออผ";
        
    CASE 2
        LOCATE Yof + 17, Xof + 1, 0
        PRINT "ฬอออออออออออออออออออออออหออออออออออออสออออออออออออป": LOCATE Yof + 18, Xof + 1, 0
        PRINT "บ EDIT & BUFFER OPTIONS บ ALT<H> to toggle HELP 2 บ": LOCATE Yof + 19, Xof + 1, 0
        PRINT "วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ": LOCATE Yof + 20, Xof + 1, 0
        PRINT "บ  cursor อ move around บ <F1>๖<F4> อ char อ> BUF บ": LOCATE Yof + 21, Xof + 1, 0
        PRINT "บ <Space> อ toggle bit  บ  ctrl<Fx> อ BUF อ> char บ": LOCATE Yof + 22, Xof + 1, 0
        PRINT "บ <Enter> อ accept char บ shift<Fx> อ view BUFfer บ": LOCATE Yof + 23, Xof + 1, 0
        PRINT "บ   <Esc> อ cancel edit บ   alt<Fx> อ clear BUF   บ": LOCATE Yof + 24, Xof + 1, 0
        PRINT "ศอออออออออออออออออออออออสอออออออออออออออออออออออออผ";
        
    CASE 3
        LOCATE Yof + 17, Xof + 1, 0
        PRINT "ฬอออออออออออออออออออออออหออออออออออออสออออออออออออป": LOCATE Yof + 18, Xof + 1, 0
        PRINT "บ        EFFECTS        บ ALT<H> to toggle HELP 3 บ": LOCATE Yof + 19, Xof + 1, 0
        PRINT "วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ": LOCATE Yof + 20, Xof + 1, 0
        PRINT "บ    <8> <อป            บ <7> อ flip horizontally บ": LOCATE Yof + 21, Xof + 1, 0
        PRINT "บ <4> + <6>ฬอ move char บ <9> อ flip vertically   บ": LOCATE Yof + 22, Xof + 1, 0
        PRINT "บ    <2> <อผ            บ <5> อ invert character  บ": LOCATE Yof + 23, Xof + 1, 0
        PRINT "บ    alt<P> อ pattern   บ <0> อ clear character   บ": LOCATE Yof + 24, Xof + 1, 0
        PRINT "ศอออออออออออออออออออออออสอออออออออออออออออออออออออผ";
        
    CASE ELSE
        Hot = 0
        GOTO HotGoto
    END SELECT
END SUB

SUB InputFileName ()
    Call GetComline (FontPathOpen$, FontPathSave$)
    FontPathExt$ = RIGHT$(FontPathOpen$, 3)
    
    IF LEFT$(FontPathExt$, 1) = "F" THEN
        H = VAL(RIGHT$(FontPathExt$, 2))
        IF H < 4 OR H > 20 THEN
            PolFEDerror$ = "Unknown file or file type!"
            CALL AppExitError
        END IF
    ELSE
        SELECT CASE FontPathExt$
        
        CASE IS = "CGA"
            H = 8
            
        CASE IS = "EGA"
            H = 14
            
        CASE IS = "VGA"
            H = 16
            
        CASE IS = "XGA"
            H = 20
        CASE ELSE
            AppError$ = "Unknown file or file type!"
            CALL AppExitError
            
        END SELECT
    END IF
END SUB

SUB Comline (NumArgs, Args$(), MaxArgs)
    CONST TRUE = -1, FALSE = 0
    
    NumArgs = 0: In = FALSE
    ' Get the command line using the COMMAND$ function
    Cl$ = COMMAND$
    L = LEN(Cl$)
    ' Go through the command line a character at a time
    FOR i = 1 TO L
        C$ = MID$(Cl$, i, 1)
        ' Test for character being a blank or a tab
        IF (C$ <> " " AND C$ <> CHR$(9)) THEN
            ' Neither blank nor tab; test if you're already inside
            ' an argument
            IF NOT In THEN
                ' You've found the start of a new argument
                ' Test for too many arguments
                IF NumArgs = MaxArgs THEN EXIT FOR
                NumArgs = NumArgs + 1
                In = TRUE
            END IF
            ' Add the character to the FontPathExtnt argument
            Args$(NumArgs) = Args$(NumArgs) + C$
        ELSE
            ' Found a blank or a tab.
            ' Set "Not in an argument" flag to FALSE
            In = FALSE
        END IF
    NEXT i
    
END SUB

SUB GetComline (FontPathOpen$, FontPathSave$)
    DIM CmdLine$(1 TO 15)
    CALL Comline(NoCmdLine, CmdLine$(), 15)
    IF NoCmdLine < 1 OR NoCmdLine > 2 OR CmdLine$(1) = "/?" OR CmdLine$(1) = "/H" OR CmdLine$(1) = "-?" OR CmdLine$(1) = "-H" THEN
        CALL AppAbout
        END
    ELSE
        FontPathOpen$ = CmdLine$(1)
        IF NoCmdLine < 2 THEN
            FontPathSave$ = FontPathOpen$
        ELSE
            FontPathSave$ = CmdLine$(2)
        END IF
    END IF
END SUB

SUB Invert (CurrChar)
    FOR w = 1 TO H
        A$ = Zn$(w)
        FOR X = 1 TO 15 STEP 2
            b$ = MID$(A$, X, 2)
            IF b$ = i$ THEN
                MID$(Zn$(w), X, 2) = o$
            ELSE
                MID$(Zn$(w), X, 2) = i$
            END IF
        NEXT X
    NEXT w
END SUB

SUB MenuReadKey ()
    ReadKeyGoto:
    ' *** Keyboard input ***
    CALL ReadKey
    
    ' Special keys
    IF K0 = 0 THEN
        SELECT CASE K$
        ' Left
        CASE "K"
            CurrChar = CurrChar - 1
            GOSUB ChkRangeCurrChar
        ' PgUp
        CASE "I"
            CurrChar = CurrChar - 1
            GOSUB ChkRangeCurrChar
        ' Ct-Left
        CASE "s"
            CurrChar = CurrChar - 1
            GOSUB ChkRangeCurrChar
        ' Right
        CASE "M"
            CurrChar = CurrChar + 1
            GOSUB ChkRangeCurrChar
        ' Ct-Right
        CASE "t"
            CurrChar = CurrChar + 1
            GOSUB ChkRangeCurrChar
        ' PgDn
        CASE "Q"
            CurrChar = CurrChar + 1
            GOSUB ChkRangeCurrChar
        ' Up
        CASE "H"
            CurrChar = CurrChar - 32
            GOSUB ChkRangeCurrChar
        ' Down
        CASE "P"
            CurrChar = CurrChar + 32
            GOSUB ChkRangeCurrChar
        ' F10 - Alternate Display
        CASE "D"
            AltDisplay = AltDisplay + 1
            CALL OIfirst
            CALL PrepChar
            
        ' Other keys
        CASE ELSE
            CALL CommonSpecKeys
        END SELECT
        
        ' Alphanumeric keys
    ELSE
        SELECT CASE K$
        
        ' Enter
        CASE CHR$(13)
            CALL EditChar(CurrChar)
            Esc = 0
            
        ' Esc
        CASE CHR$(27)
            Esc = 1
            
        ' BkSp
        CASE CHR$(8)
            CALL UndoChar(CurrChar)
            
        ' inne klawisze
        CASE ELSE
            CALL GetChar(CurrChar)
            CALL SaveUndoChar(CurrChar)
            CALL CommonNormKeys
            CALL SaveCurrChar(CurrChar)
        END SELECT
        
    END IF
    EXIT SUB
    
    '                                  SUBROUTINES:
    ChkRangeCurrChar:
    IF BUFused = 0 THEN
        IF CurrChar < 0 THEN CurrChar = LastChar
        IF CurrChar > LastChar THEN CurrChar = 0
    ELSE
        CurrChar = BUFused
    END IF
    BUFused = 0     ' A variable which shows if buffer was
    ' displayed recently. If yes, it contains
    ' the previous value of CurrChar
    ' (i.e. the code of the char displayed just before.)
    RETURN
END SUB

SUB MoveDown (CurrChar)
    Pomoc$ = Zn$(H)
    FOR w = H - 1 TO 1 STEP -1
        Zn$(w + 1) = Zn$(w)
    NEXT w
    Zn$(1) = Pomoc$
END SUB

SUB MoveLeft (CurrChar)
    FOR w = 1 TO H
        A$ = Zn$(w)
        Zn$(w) = RIGHT$(A$ + LEFT$(A$, 2), 16)
    NEXT w
END SUB

SUB MoveRight (CurrChar)
    FOR w = 1 TO H
        A$ = Zn$(w)
        Zn$(w) = LEFT$(RIGHT$(A$, 2) + A$, 16)
    NEXT w
END SUB

SUB MoveUp (CurrChar)
    Pomoc$ = Zn$(1)
    FOR w = 1 TO H - 1
        Zn$(w) = Zn$(w + 1)
    NEXT w
    Zn$(H) = Pomoc$
END SUB

SUB NewInput (y, X, Text$, XLength, YHeight, Limit, Limit$, Terminate$, Default$)
    ' Inputting of text strings
    ' Y and X are coordinates
    ' Text$ is the output variable
    ' XLength is the desired length of the string
    ' YHeight is the desired height of the string
    ' Limit is to check, whether there are any limitations
    '       considering the input string.
    ' "0" means - no limitations, "2" means - limited, not case sensitive,
    ' "1" means - limited, case sensitive
    ' Limit$ is to verify which characters may be entered and which ones not
    ' Terminate$ is a list of keys to be pressed to finish entering
    ' Default$ is the default value which is entered when ENTER pressed
    
    ' *** Preparing input area
    Text$ = ""
    CALL FillSquare(y, X, XLength, 1, "Û")
    Pause = 0
    WHILE Pause < 100
        Pause = Pause + 1
    WEND
    CALL FillSquare(y, X, XLength, 1, "ฒ")
    CALL FillSquare(y, X, XLength, 1, "ฑ")
    CALL FillSquare(y, X, XLength, YHeight, "ฐ")
    
    FOR YH = 0 TO YHeight - 1
        FOR XL = 0 TO XLength - 1
            
            StartGoto:
            ' *** Waiting for keyboard input
            DO
                LOCATE y + YH, X + XL, 1, 8
                KeyPr$ = LEFT$(INKEY$, 1)
            LOOP UNTIL KeyPr$ <> ""
            
            ' *** Check: Esc Key pressed?
            Esc = 0
            IF KeyPr$ = CHR$(27) THEN Esc = 1: EXIT SUB
            
            ' *** Check: Enter/Terminate Key pressed?
            FOR A = 1 TO LEN(Terminate$)
                Term$ = MID$(Terminate$, A, 1)
                IF KeyPr$ = Term$ THEN
                    ' *** Check: Default text should be used?
                    IF Text$ = "" THEN
                        Text$ = Default$
                        LOCATE y + YH, X + XL, 0: PRINT Text$
                        XL = XL + LEN(Text$)
                    END IF
                    GOTO FinishGoto
                END IF
            NEXT A
            
            ' *** Check: BackSpace/Delete pressed?
            IF KeyPr$ = CHR$(8) THEN
                XL = XL - 1
                IF XL < 0 THEN
                    XL = XLength - 1
                    YH = YH - 1
                    IF YH < 0 THEN YH = 0: XL = 0
                END IF
                CutLen = LEN(Text$) - 1
                IF CutLen < 0 THEN CutLen = 0
                REM ### : SOUND 50, 3
                Text$ = LEFT$(Text$, CutLen)
                LOCATE y + YH, X + XL, 0
                PRINT "ฐ";
                GOTO StartGoto
            END IF
            
            ' *** Limit check ***
            IF Limit THEN
                ' *** Case sensitivity ***
                IF Limit > 1 THEN
                    KeyPr$ = UCASE$(KeyPr$)
                    Limit$ = UCASE$(Limit$)
                END IF
                OK = 0
                FOR A = 1 TO LEN(Limit$)
                    IF KeyPr$ = MID$(Limit$, A, 1) THEN OK = 1
                NEXT A
                IF OK = 0 THEN GOTO StartGoto
            END IF
            
            Text$ = Text$ + KeyPr$
            
            ' *** Printing the pressed key
            LOCATE y + YH, X + XL, 0: PRINT KeyPr$
            
        NEXT XL
    NEXT YH
    
    ' YH = YHeight - 1
    ' XL = XLength - 1
    ' GOTO Start:
    
    FinishGoto:
    ' *** Clearing the rest of the area
    CALL FillSquare(y + YH, X + XL, XLength - XL, 1, " ")
    IF YH < y + YHeight THEN CALL FillSquare(y + YH + 1, X, XLength, YHeight - YH - 1, " ")
END SUB

SUB OIfirst ()
    OIfirstGoto:
    SELECT CASE AltDisplay
    
    CASE 0
        o$ = "ฐฐ"
        i$ = "ฒฒ"
        o0$ = "ฑฑ"
        i0$ = "ÛÛ"
    CASE 1
        o$ = "๙๚"
        i$ = "ÞÝ"
        o0$ = "ฐฐ"
        i0$ = "ฒฒ"
    CASE 2
        o$ = ".."
        i$ = "##"
        o0$ = "oo"
        i0$ = "XX"
    CASE 3
        o$ = "๗๘"
        i$ = "Ü฿"
        o0$ = "ฐฐ"
        i0$ = "ฒฒ"
        
    CASE ELSE
        AltDisplay = 0
        GOTO OIfirstGoto
    END SELECT
END SUB

SUB OIlast ()
    o$ = "ณ "
    
    i$ = "ณÛ"
    
    o0$ = "ฺฤยฤยฤยฤยฤยฤยฤยฤฟ"
    i0$ = "ภฤมฤมฤมฤมฤมฤมฤมฤู"
    i1$ = "รฤลฤลฤลฤลฤลฤลฤลฤด"
END SUB

SUB Pattern (CurrChar)
    FOR y = 1 TO AktY
        FOR w = y + AktY TO H STEP AktY
            Zn$(w) = Zn$(y)
        NEXT w
    NEXT y
END SUB

SUB AppExit ()
    CLS
    PRINT "POLFED v" + PolFEDversion$ + " finished!"
    END
END SUB

SUB AppExitError ()
    CLS
    PRINT "POLFED v" + PolFEDversion$ + " error! "; AppError$
    END
END SUB

SUB PrepChar ()
    OI$(0) = o$ + o$ + o$ + o$
    OI$(1) = o$ + o$ + o$ + i$
    OI$(2) = o$ + o$ + i$ + o$
    OI$(3) = o$ + o$ + i$ + i$
    OI$(4) = o$ + i$ + o$ + o$
    OI$(5) = o$ + i$ + o$ + i$
    OI$(6) = o$ + i$ + i$ + o$
    OI$(7) = o$ + i$ + i$ + i$
    OI$(8) = i$ + o$ + o$ + o$
    OI$(9) = i$ + o$ + o$ + i$
    OI$(10) = i$ + o$ + i$ + o$
    OI$(11) = i$ + o$ + i$ + i$
    OI$(12) = i$ + i$ + o$ + o$
    OI$(13) = i$ + i$ + o$ + i$
    OI$(14) = i$ + i$ + i$ + o$
    OI$(15) = i$ + i$ + i$ + i$
END SUB

SUB AppAbout ()
    PRINT "ษอออออออออออออออออออออออออออออออออออออออออออออออออป"
    PRINT "บ POLFED Font Editor v" + PolFEDversion$ + "                       บ"
    PRINT "ศอออออออออออออออออออออออออออออออออออออออออออออออออผ";
    PRINT
    PRINT "  Bitmap screen font editor for DOS text-mode fonts."
    PRINT "  Copyright (c) 1994-2015 by Adam Twardoch."
    PRINT "  Written in QBasic, Visual Basic for DOS, FreeBASIC"
    PRINT "  opensource under Apache 2: http://github.com/twardoch"
    PRINT 
    PRINT "  Opens a simple bitmap format: depending on .EXT,"
    PRINT "  each character is 8 (.CGA), 14 (.EGA), 16 (.VGA), 20 (.XGA)"
    PRINT "  lines/bytes, and each line is 1 byte (8 bits). "
    PRINT 
    PRINT "  Usage:"
    PRINT "  POLFED32.EXE INPUT.EXT [OUTPUT.EXT]"
    PRINT "  Example:"
    PRINT "  POLFED32.EXE DOSFONT.VGA DOSFONT1.VGA"
    PRINT 
END SUB

SUB ReadKey ()
    DO
        K$ = INKEY$
    LOOP UNTIL K$ <> ""
    K0 = ASC(K$)
    K$ = RIGHT$(K$, 1)
    K1 = ASC(K$)
END SUB

SUB SaveFont ()
    CALL OIlast
    CALL PrepChar
    CALL Flash(Yof + 6, Xof + 3, 7)
    LOCATE Yof + 6, Xof + 3, 0
    PRINT "WRITING"
    
    OPEN FontPathSave$ FOR OUTPUT AS 1
    Font$ = LEFT$(Font$, OST)
    PRINT #1, Font$;
    CLOSE #1
    
    LOCATE Yof + 6, Xof + 47, 0
    PRINT LastChar
END SUB

SUB SaveUndoChar (CurrChar)
    Undo$ = MID$(Font$, CurrChar * H + 1, H)
END SUB

SUB SaveCurrChar (CurrChar)
    ' this SUB converts the actual state of a char saved in Zn$()
    ' into a position in Font$
    ConFont$ = ""
    FOR w = 1 TO H
        ConZn = 0
        FOR X = 1 TO 8
            ConZn$ = MID$(Zn$(w), X * 2 - 1, 2)
            IF ConZn$ = i$ THEN
                Index = 1
            ELSE
                Index = 0
            END IF
            ConZn = ConZn + Index * 2 ^ (8 - X)
        NEXT X
        ConFont$ = ConFont$ + CHR$(ConZn)
    NEXT w
    MID$(Font$, CurrChar * H + 1, H) = ConFont$
END SUB

SUB ShowMainWindow ()
    CLS
    LOCATE Yof + 1, Xof + 1
    PRINT "ษอออออออออออออออออออออหออออออออออออออออออออออออออออหออออออออออออออออป": LOCATE Yof + 2, Xof + 1
    PRINT "บ    POLFED " + PolFEDversion$ + "     บ Bitmap Screen Font Editor  บ POLFED v" + PolFEDversion$ + " บ": LOCATE Yof + 3, Xof + 1
    PRINT "ศอออออออออหอออออออออออฮออออออออออออออออออออออออออออน (c) 1994-97 by บ": LOCATE Yof + 4, Xof + 1
    PRINT "          บ Directory บ                            บ Adam  TWARDOCH บ": LOCATE Yof + 5, Xof + 1
    PRINT "ษอออออออออสอออออออออออสอหออออออออออออหอออออออออออออสออออออออออออออออผ": LOCATE Yof + 6, Xof + 1
    PRINT "บ Name of the font file บ            บ": LOCATE Yof + 7, Xof + 1
    PRINT "ฬอออออออออออออออออออออออสออออออออออออน": LOCATE Yof + 8, Xof + 1
    PRINT "บ  < Control Chars                   บ": LOCATE Yof + 9, Xof + 1
    PRINT "บ   !"; CHR$(34); "#$%&'()*+,-./0123456789:;<=>?  บ": LOCATE Yof + 10, Xof + 1
    PRINT "บ  @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_  บ": LOCATE Yof + 11, Xof + 1
    PRINT "บ  `abcdefghijklmnopqrstuvwxyz{|}~  บ": LOCATE Yof + 12, Xof + 1
    PRINT "บ  €…‘’“”•–—  บ": LOCATE Yof + 13, Xof + 1
    PRINT "บ   กขฃคฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟ  บ": LOCATE Yof + 14, Xof + 1
    PRINT "บ  ภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุูÛÜÝÞ฿  บ": LOCATE Yof + 15, Xof + 1
    PRINT "บ  เแโใไๅๆ็่้๊๋์ํ๎๏๐๑๒๓๔๕๖๗๘๙๚๛üýþÿ  บ": LOCATE Yof + 16, Xof + 1
    PRINT "บ  Buffers: 1 2 3 4    More Chars >  บ": LOCATE Yof + 17, Xof + 1
    PRINT "ศออออออออออออออออออออออออออออออออออออผ": LOCATE Yof + 18, Xof + 1
END SUB

SUB UndoChar (CurrChar)
    MID$(Font$, CurrChar * H + 1, H) = Undo$
END SUB

SUB vMir (CurrChar)
    FOR w = 1 TO H
        A$ = LEFT$(Zn$(w), 16)
        b$ = RIGHT$(Zn$(H - w + 1), 16)
        Zn$(w) = b$ + A$
    NEXT w
    
    FOR w = 1 TO H
        Zn$(w) = LEFT$(Zn$(w), 16)
    NEXT w
END SUB

