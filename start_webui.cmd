@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start_webui.ps1" -PauseOnError
if errorlevel 1 (
  echo.
  echo Start failed. See error above.
  pause
)
