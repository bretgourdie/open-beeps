USING Music.*.

DEF VAR lBeeps AS Beep NO-UNDO EXTENT 10.
DEF VAR lBeeper AS Beeper NO-UNDO.
lBeeper = NEW Beeper().

ASSIGN
  lBeeps[1] = NEW Beep("E5", 300)
  lBeeps[2] = NEW Beep("E5", 600)
  lBeeps[3] = NEW Beep("E5", 300)
  lBeeps[4] = NEW Silence(300)
  lBeeps[5] = NEW Beep("C5", 300)
  lBeeps[6] = NEW Beep("E5", 600)
  lBeeps[7] = NEW Beep("G5", 300)
  lBeeps[8] = NEW Silence(900)
  lBeeps[9] = NEW Beep("G4", 300)
  lBeeps[10] = NEW Silence(900).

lBeeper:Play(lBeeps).