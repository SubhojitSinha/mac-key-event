@echo off
setlocal EnableDelayedExpansion

set "filename=%~1"

if not defined filename (
  echo Error: source filename not provided
  exit /b 1
)

if not exist "%filename%" (
  echo Error: source file not found
  exit /b 1
)

for /F "delims=" %%a in ('type "%filename%"') do (
  set "line=%%a"
  call :simulateLine
  cscript //nologo //E:JScript "%~f0" "{ENTER}"
)

exit /b

:simulateLine
set "line=!line:"=\"!"
for %%C in (!line!) do (
   set /a "random_sleep=!random! %% 3 + 1"
   timeout /t %random_sleep% >nul
   csript //nologo //E:JScript "%%~C".charCodeAt(0)

)
exit /b
