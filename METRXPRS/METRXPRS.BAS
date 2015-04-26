REM $DYNAMIC

DECLARE SUB ArrangeMetrics (AFMfile$, OutFile$, MEQFile$)
DECLARE SUB ProcError (ErrorName$)
DECLARE SUB PrintHelp ()
DECLARE SUB GetComline (DoArrangeMetrics!, AFMfile$, OutFile$, MEQFile$)
DECLARE SUB PrintVisitCard ()
DECLARE SUB GetUniques ()
DECLARE SUB Comline (N, A$(), Max)
DIM SHARED MEQ$(600, 2)
DIM SHARED Bound$(3)
DIM SHARED UNQ$(100, 6)
DIM SHARED NumUNQ, NumMEQ, Ver$

Ver$ = "1.1"

' ON ERROR GOTO ErrFile
' Checking for command line paramenters
' and calling help if needed
CALL GetComline(DoArrangeMetrics, AFMfile$, OutFile$, MEQFile$)
' ArrangeMetricsing if needed
IF DoArrangeMetrics THEN
    CALL PrintVisitCard
    CALL ArrangeMetrics(AFMfile$, OutFile$, MEQFile$)
END IF
END

ErrFile:
CALL ProcError(ERROR$)
END

REM $STATIC
SUB ArrangeMetrics (AFMfile$, OutFile$, MEQFile$)
    
    ' ### EVALUATING EQUATIONS FILE
    OPEN MEQFile$ FOR INPUT AS #1
    index = 0
    DO
        LINE INPUT #1, strg$
        strg$ = LTRIM$(RTRIM$(strg$))
        IF strg$ <> "" THEN
            MEQ$(index, 0) = RTRIM$(LTRIM$(LEFT$(strg$, INSTR(strg$, " ") - 1)))
            MEQ$(index, 1) = RTRIM$(LTRIM$(RIGHT$(strg$, LEN(strg$) - LEN(MEQ$(index, 0)))))
            index = index + 1
        END IF
    LOOP UNTIL EOF(1)
    NumMEQ = index - 1
    CLOSE #1
    
    CALL GetUniques
    
    ' ###
    
    ' EVALUATING METRICS FILE
    
    OPEN AFMfile$ FOR INPUT AS #1
    
    isMetrics% = 0
    
    DO
        LINE INPUT #1, strg$
        IF LEFT$(UCASE$(strg$), 14) = "ENDCHARMETRICS" THEN
            isMetrics% = 0
        END IF
        
        IF isMetrics% = 1 THEN
            
            LStrg = LEN(strg$)
            
            glyph$ = MID$(strg$, INSTR(strg$, " ; N ") + 5, INSTR(strg$, " ; B ") - INSTR(strg$, " ; N ") - 5)
            Code$ = MID$(strg$, 3, INSTR(strg$, " ; WX ") - 3)
            Width$ = MID$(strg$, INSTR(strg$, " ; WX ") + 6, INSTR(strg$, " ; N ") - INSTR(strg$, " ; WX ") - 6)
            Bd$ = RIGHT$(strg$, LStrg - INSTR(strg$, " ; B ") - 4)
            Bd$ = LEFT$(Bd$, LEN(Bd$) - 1)
            
            FOR BoundIndex = 0 TO 3
                Bound$(BoundIndex) = LEFT$(Bd$, INSTR(Bd$, " ") - 1)
                Bd$ = RIGHT$(Bd$, LEN(Bd$) - INSTR(Bd$, " "))
            NEXT BoundIndex
            
            FOR index = 0 TO NumUNQ
                REM IF LEN(glyph$) = 1 THEN PRINT "'"; glyph$; "' '"; UNQ$(index, 0); "'"
                
                IF UNQ$(index, 0) = glyph$ THEN
                    UNQ$(index, 1) = Code$
                    UNQ$(index, 2) = Width$
                    UNQ$(index, 3) = Bound$(0)
                    UNQ$(index, 4) = Bound$(1)
                    UNQ$(index, 5) = Bound$(2)
                    UNQ$(index, 6) = Bound$(3)
                END IF
            NEXT index
            
        END IF
        
        IF LEFT$(UCASE$(strg$), 16) = "STARTCHARMETRICS" THEN
            isMetrics% = 1
        END IF
        
    LOOP UNTIL EOF(1)
    CLOSE #1
    
    ' ######
    
    OPEN AFMfile$ FOR INPUT AS #1
    OPEN OutFile$ FOR OUTPUT AS #2
    
    isMetrics% = 0
    
    DO
        LINE INPUT #1, strg$
        IF LEFT$(UCASE$(strg$), 14) = "ENDCHARMETRICS" THEN
            isMetrics% = 0
        END IF
        
        IF isMetrics% = 0 THEN
            PRINT #2, strg$
        ELSE
            LStrg = LEN(strg$)
            
            glyph$ = MID$(strg$, INSTR(strg$, " ; N ") + 5, INSTR(strg$, " ; B ") - INSTR(strg$, " ; N ") - 5)
            Code$ = MID$(strg$, 3, INSTR(strg$, " ; WX ") - 3)
            Width$ = MID$(strg$, INSTR(strg$, " ; WX ") + 6, INSTR(strg$, " ; N ") - INSTR(strg$, " ; WX ") - 6)
            Bd$ = RIGHT$(strg$, LStrg - INSTR(strg$, " ; B ") - 4)
            Bd$ = LEFT$(Bd$, LEN(Bd$) - 1)
            
            FOR BoundIndex = 0 TO 3
                Bound$(BoundIndex) = LEFT$(Bd$, INSTR(Bd$, " ") - 1)
                Bd$ = RIGHT$(Bd$, LEN(Bd$) - INSTR(Bd$, " "))
            NEXT BoundIndex
            
            ' WRITING OUTPUT
            FOR index = 0 TO NumMEQ
                
                IF MEQ$(index, 0) = glyph$ THEN
                    
                    Counter = Counter + 1
                    
                    FOR j = 0 TO NumUNQ
                        IF UNQ$(j, 0) = MEQ$(index, 1) THEN
                            Width$ = UNQ$(j, 2)
                            Bound$(0) = UNQ$(j, 3)
                            Bound$(2) = UNQ$(j, 5)
                        END IF
                    NEXT j
                END IF
                
            NEXT index
            
            ' PRINT
            PRINT #2, "C "; Code$; " ; WX "; Width$; " ; N "; glyph$;
            PRINT #2, " ; B "; Bound$(0); " "; Bound$(1); " "; Bound$(2); " ";
            PRINT #2, Bound$(3); " ;"
            
        END IF
        
        IF LEFT$(UCASE$(strg$), 16) = "STARTCHARMETRICS" THEN
            isMetrics% = 1
        END IF
        
    LOOP UNTIL EOF(1)
    CLOSE #1
    
    
    PRINT AFMfile$; " -> "; OutFile$; ": "; RTRIM$(LTRIM$(STR$(Counter))); " glyphs corrected."
    END
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
            ' Add the character to the current argument
            Args$(NumArgs) = Args$(NumArgs) + C$
        ELSE
            ' Found a blank or a tab.
            ' Set "Not in an argument" flag to FALSE
            In = FALSE
        END IF
    NEXT i
    
END SUB

SUB GetComline (DoArrangeMetrics, AFMfile$, OutFile$, MEQFile$)
    DIM CmdLine$(1 TO 15)
    CALL Comline(NoCmdLine, CmdLine$(), 15)
    IF NoCmdLine < 3 OR NoCmdLine > 3 OR CmdLine$(1) = "/?" OR CmdLine$(1) = "/H" OR CmdLine$(1) = "-?" OR CmdLine$(1) = "-H" THEN
        DoArrangeMetrics = 0
        CALL PrintHelp
    ELSE
        DoArrangeMetrics = 1
        AFMfile$ = CmdLine$(1)
        OutFile$ = CmdLine$(2)
        MEQFile$ = CmdLine$(3)
    END IF
END SUB

SUB GetUniques ()
    NumUNQ = 0
    j = 0
    FOR index = 0 TO NumMEQ
        E$ = MEQ$(index, 1)
        DO
            isRepeat = 0
            IF UNQ$(j, 0) = E$ THEN
                isRepeat = 1
                EXIT DO
            END IF
            j = j + 1
        LOOP UNTIL j >= NumUNQ
        
        IF isRepeat = 0 THEN
            NumUNQ = NumUNQ + 1
            UNQ$(NumUNQ, 0) = E$
        END IF
    NEXT index
    
END SUB

SUB PrintHelp ()
    PRINT "------------------------------------------------------------------------------"
    PRINT "METRXPRS v"; Ver$; " * Copyright (c) 1998-2015 by Adam Twardoch"
    PRINT "Published under the Apache 2 license at http://github.com/twardoch"
    PRINT "------------------------------------------------------------------------------"
    PRINT "This program corrects the 'AFM' font metric files according to special"
    PRINT "metrics equality (MEQ) tables so that the metrics of the 'child glyphs',"
    PRINT "i.e. of composite glyphs like 'Aacute' will be adjusted to fit the metrics"
    PRINT "of the 'parent glyphs', i.e. of the basic components (like 'A')."
    PRINT "Designed for 'AFM' metric files generated by FontLab 3.0. No warranty."
    PRINT "------------------------------------------------------------------------------"
    PRINT "SYNTAX:    METRXPRS.EXE <AFM-INFILE> <AFM-OUTFILE> <EQ-FILE>"
    PRINT "WHERE:     <AFM-INFILE>     is the font metric file to be corrected"
    PRINT "           <AFM-OUTFILE>    is the target font metric file"
    PRINT "           <MEQ-FILE>       is the table of equalities"
    PRINT "EXAMPLE:   METRXPRS.EXE INPUT.AFM OUTPUT.AFM ANSI.MEQ"
    PRINT "------------------------------------------------------------------------------"
    PRINT "SYNTAX OF THE MEQ EQUALITY FILE:"
    PRINT "           <child glyphname><space><parent glyphname><enter>"
    PRINT "           <child glyphname><space><parent glyphname><enter>"
    PRINT "           ..."
    PRINT "------------------------------------------------------------------------------"
END SUB

SUB PrintVisitCard ()
    PRINT "METRXPRS v"; Ver$; " * Copyright (c) 1998-2015 by Adam Twardoch"
    PRINT "Type METRXPRS /? for help"
END SUB

SUB ProcError (ErrorName$)
    PRINT "Error: "; ErrorName$
    END
END SUB

