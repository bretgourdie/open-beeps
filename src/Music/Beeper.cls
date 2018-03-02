ROUTINE-LEVEL ON ERROR UNDO, THROW.
USING Music.Beep.
USING Music.Pitch2Frequency.

CLASS Music.Beeper:

  DEF VAR Pitch2Frequency AS Pitch2Frequency NO-UNDO.

  CONSTRUCTOR PUBLIC Beeper():
    THIS-OBJECT(NEW Pitch2Frequency()).
  END METHOD.

  CONSTRUCTOR PUBLIC Beeper(pPitch2Frequency AS Pitch2Frequency):
    ASSIGN
      THIS-OBJECT:Pitch2Frequency = pPitch2Frequency.
  END CONSTRUCTOR.

  METHOD PUBLIC LOG Play(pBeep AS Beep):
    DEF VAR lFrequency AS INT NO-UNDO.
    ASSIGN lFrequency = getFrequency(pBeep).

    DEF VAR lDuration AS INT NO-UNDO.
    ASSIGN lDuration = getDuration(pBeep).

    DEF VAR lPassthroughResult AS INT64 NO-UNDO.
    lPassthroughResult = beepPassthrough(lFrequency, lDuration).

    DEF VAR lResult AS LOG NO-UNDO.
    ASSIGN lResult = lPassthroughResult EQ 1.
    
    RETURN lResult.
  END METHOD.

  METHOD PUBLIC LOG Play(pBeeps AS Beep EXTENT):
    DEF VAR lBeepIndex AS INT NO-UNDO.
    DEF VAR lResult AS LOG NO-UNDO INITIAL TRUE.

    DO lBeepIndex = 1 TO EXTENT(pBeeps):
      lResult = lResult AND Play(pBeeps[lBeepIndex]).
    END.

    RETURN lResult.
  END METHOD.

  METHOD PROTECTED INT getFrequency(pBeep AS Beep):
    IF NOT pBeep:IsSilence() THEN
    DO:
      RETURN THIS-OBJECT:Pitch2Frequency:GetFrequency(pBeep:Note).
    END.
    ELSE
    DO:
      RETURN 0.
    END.
  END METHOD.

  METHOD PROTECTED INT getDuration(pBeep AS Beep):
    RETURN pBeep:Duration.
  END METHOD.

  METHOD PROTECTED INT BEEPPASSTHROUGH(pFreq AS INT, pDuration AS INT):
    DEF VAR lResult AS INT NO-UNDO.
    RUN Beep(pFreq, pDuration, OUTPUT lResult).
    RETURN lResult.
  END METHOD.

  PROCEDURE Beep EXTERNAL "Kernel32.dll" :
    DEFINE INPUT PARAMETER  dwFreq     AS LONG.
    DEFINE INPUT PARAMETER  dwDuration AS LONG.
    DEFINE RETURN PARAMETER ReturnValue AS LONG.
  END PROCEDURE.
END CLASS.
