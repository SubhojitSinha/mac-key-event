@if (@CodeSection == @Batch) @then
@echo off
set SendKeys=CScript //nologo //E:JScript "%~F0"
set /a num=1
::set list=[ABCDabc]
::echo list[%3]
:while
(
   set /a "ran = %random% * 26 / 32768 + 1"
   %SendKeys% %ran%
   set /a num=%random% %%3 +0
   timeout /t %num% >nul
   goto :while
)
@end
var WshShell = WScript.CreateObject("WScript.Shell");
WshShell.SendKeys(WScript.Arguments(0));