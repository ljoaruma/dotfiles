WINVAR="WSLENV"

Set oShell = WScript.CreateObject("WScript.Shell")
Set fso = WScript.CreateObject("Scripting.FileSystemObject")
Set stdout = fso.GetStandardStream (1)

stdout.WriteLine("-- oShell.Environment")
' stdout.WriteLine(oShell.Environment)
For each e in oShell.Environment
  stdout.WriteLine(e)
Next

stdout.WriteLine("-- User Environment")
Set oEnv=oShell.Environment("User")
For each e in oEnv
  stdout.WriteLine(e)
Next

stdout.WriteLine("-- Process Environment")
Set oEnv=oShell.Environment("Process")
For each e in oEnv
  stdout.WriteLine(e)
Next

stdout.WriteLine("-- Volarile Environment")
Set oEnv=oShell.Environment("Volatile")
For each e in oEnv
  stdout.WriteLine(e)
Next


stdout.WriteLine("-- System Environment")
Set sEnv=oShell.Environment("System")
For each e in oEnv
  stdout.WriteLine(e)
Next

' stdout.WriteLine(oShell.ExpandEnvironmentStrings( var ))

