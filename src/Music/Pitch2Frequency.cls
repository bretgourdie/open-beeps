ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS Music.Pitch2Frequency:
  
  CONSTRUCTOR PUBLIC Pitch2Frequency():

  END CONSTRUCTOR.

  METHOD PUBLIC INT GetFrequency(pNotation AS CHAR):
    DEF VAR lNote AS INT NO-UNDO.
    DEF VAR lOctave AS INT NO-UNDO INITIAL 4.
    DEF VAR lAccidental AS INT NO-UNDO.
    DEF VAR lNotePosition AS INT NO-UNDO INITIAL 1.
    DEF VAR lOctavePosition AS INT NO-UNDO INITIAL 2.

    /* Parse note name */
    IF LENGTH(pNotation) < lNotePosition THEN
      UNDO, THROW NEW PROGRESS.Lang.AppError("pNotation is blank", 1).

    DEF VAR lNotePart AS CHAR NO-UNDO.
    ASSIGN lNotePart = SUBSTRING(pNotation, lNotePosition, 1).
    ASSIGN lNote = name2Num(UPPER(lNotePart)).
    IF lNote < 0 THEN
    DO:
      RETURN lNote.
    END.

    /* Parse accidental */
    IF LENGTH(pNotation) >= lOctavePosition THEN
    DO:
      DEF VAR lPotentialAccidentalPart AS CHAR NO-UNDO.
      ASSIGN lPotentialAccidentalPart = SUBSTRING(pNotation, lOctavePosition, 1).

      DEF VAR lIsNumber AS LOG NO-UNDO.
      INTEGER(lPotentialAccidentalPart) NO-ERROR.
      ASSIGN lIsNumber = NOT ERROR-STATUS:ERROR.

      IF NOT lIsNumber THEN
      DO:
        ASSIGN lAccidental = accidental2Num(lPotentialAccidentalPart).
        IF lAccidental EQ ? THEN
          UNDO, THROW NEW PROGRESS.Lang.AppError("pNotation has wrong accidental", 2).

        ASSIGN 
          lNote = lNote + lAccidental
          lOctavePosition = lOctavePosition + 1.
      END.
    END.

    /* Parse octave */
    IF LENGTH(pNotation) EQ lOctavePosition THEN
    DO:
      DEF VAR lOctavePart AS CHAR NO-UNDO.
      ASSIGN lOctavePart = SUBSTRING(pNotation, lOctavePosition, 1).

      ASSIGN lOctave = INTEGER(lOctavePart) NO-ERROR.
    END.

    DEF VAR lMidiNoteNumber AS INT NO-UNDO.
    ASSIGN lMidiNoteNumber = note2num(lOctave, lNote).

    DEF VAR lFrequency AS INT NO-UNDO.
    ASSIGN lFrequency = num2freq(lMidiNoteNumber).

    RETURN lFrequency.
  END METHOD.

  METHOD PROTECTED INT num2freq(pNoteNumber AS INT):
    DEF VAR lExponent AS DECIMAL NO-UNDO.
    ASSIGN lExponent = (pNoteNumber - 69) / 12.

    RETURN INTEGER(440 * EXP(2, lExponent)).
  END METHOD.

  METHOD PROTECTED INT name2Num(pName AS CHAR):
    CASE pName:
      WHEN "C" THEN RETURN 0.
      WHEN "D" THEN RETURN 2.
      WHEN "E" THEN RETURN 4.
      WHEN "F" THEN RETURN 5.
      WHEN "G" THEN RETURN 7.
      WHEN "A" THEN RETURN 9.
      WHEN "B" THEN RETURN 11.
      OTHERWISE RETURN -1.
    END CASE.
  END METHOD.

  METHOD PROTECTED INT note2num(pOctave AS INT, pNote AS INT):
    RETURN (pOctave + 1) * 12 + pNote.
  END METHOD.

  METHOD PROTECTED INT accidental2Num(pAccidental AS CHAR):
    CASE pAccidental:
      WHEN "b" THEN RETURN -1.
      WHEN "#" THEN RETURN 1.
      OTHERWISE RETURN ?.
    END CASE.
  END METHOD.
END CLASS.
