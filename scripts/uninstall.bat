@echo off

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run as Administrator.
    pause
    exit /b 1
)

echo Removing registry entries ...
reg delete "HKCR\dropbox" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shell\CopyDropboxLink" /f >nul 2>&1
reg delete "HKCR\Directory\shell\CopyDropboxLink" /f >nul 2>&1
echo Done.

echo Removing scripts ...
if exist "C:\Tools\DropboxLocalLink" rmdir /S /Q "C:\Tools\DropboxLocalLink"
echo Done.

for /f "tokens=6 delims=. " %%b in ('ver') do set BUILD=%%b
set BUILD=%BUILD:]=%
if %BUILD% GEQ 22000 (
    echo Restoring Windows 11 modern right-click menu ...
    reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
    echo Done. Explorer will restart.
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
)

echo.
echo Uninstall complete.
pause
