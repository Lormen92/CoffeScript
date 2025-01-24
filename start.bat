@echo off
REM Get the batch file's directory path
set BAT_DIR=%~dp0

REM Start PowerShell, set the execution policy, run the PowerShell script, and exit
powershell -NoExit -ExecutionPolicy Bypass -Command "& '%BAT_DIR%coffee_script.ps1'"
