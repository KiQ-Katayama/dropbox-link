@echo off

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run as Administrator.
    pause
    exit /b 1
)

echo [1/3] Deploying scripts ...
if not exist "C:\Tools\DropboxLocalLink" mkdir "C:\Tools\DropboxLocalLink"
copy /Y "%~dp0open-dropbox-path.ps1"  "C:\Tools\DropboxLocalLink\" >nul
copy /Y "%~dp0copy-dropbox-link.ps1"  "C:\Tools\DropboxLocalLink\" >nul
echo       Done.

echo [2/3] Registering context menu and URI handler ...
reg import "%~dp0register-dropbox-uri.reg" >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Registry import failed.
    pause
    exit /b 1
)
echo       Done.

echo [3/3] Checking Windows version ...
for /f "tokens=6 delims=. " %%b in ('ver') do set BUILD=%%b
set BUILD=%BUILD:]=%

if %BUILD% GEQ 22000 (
    echo       Windows 11 detected.
    echo       Restoring classic right-click menu ...
    reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
    echo       Done. Explorer will restart now.
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
) else (
    echo       Windows 10 - no changes needed.
)

echo.
echo ============================================================
echo   Setup complete!
echo.
echo   Usage:
echo     1. Right-click a Dropbox folder
echo        -> "Dropbox link copy"
echo     2. Paste the link in Slack
echo     3. Click the link -> opens in Explorer
echo ============================================================
pause
