@echo off
REM Ottieni il percorso del file batch
set BAT_DIR=%~dp0

REM Avvia PowerShell, imposta la policy di esecuzione, esegui lo script PowerShell e termina
powershell -NoExit -ExecutionPolicy Bypass -Command "& '%BAT_DIR%coffee_script.ps1'"
