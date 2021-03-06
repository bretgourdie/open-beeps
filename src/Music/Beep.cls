ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS Music.Beep:

  DEF PUBLIC PROPERTY Note AS CHAR NO-UNDO
    GET.
    PROTECTED SET.

  DEF PUBLIC PROPERTY Duration AS INT NO-UNDO
    GET.
    PROTECTED SET.

  CONSTRUCTOR PUBLIC Beep(pNote AS CHAR, pDuration AS INT):
    ASSIGN
      THIS-OBJECT:Note = pNote
      THIS-OBJECT:Duration = pDuration.
  END CONSTRUCTOR.

  METHOD PUBLIC LOG IsSilence():
    RETURN FALSE.
  END METHOD.

END CLASS.
