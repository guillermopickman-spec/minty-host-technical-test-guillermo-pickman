@echo off
:: Full Setup Part 1: Initial setup and server test
:: This runs first, then automatically launches Part 2

:: Check for administrator privileges and request elevation if needed
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges for Part 1...
    powershell "start-process '%~f0' -verb runas"
    exit /b
)

cd /d "%~dp0"
CHCP 65001 >nul

echo 🚀 Minty Host - Full Setup Part 1
echo ================================
echo Initial setup and server testing phase
echo.

echo 🧹 Cleaning up old processes...
call stop-dev.bat
taskkill /fi "WINDOWTITLE eq Setup*" /t /f >nul 2>&1
echo Cleanup complete.
echo.

echo 📋 Step 1: First setup attempt (new window)...
echo ---------------------------------------------
if exist setup_complete.flag del setup_complete.flag
start "Setup-Attempt-1" cmd /c "cd /d "%~dp0" && setup.bat"
echo Waiting for first setup to complete...
:wait_setup1
timeout /t 2 >nul
if not exist setup_complete.flag goto wait_setup1
del setup_complete.flag
echo First setup completed.
echo.

echo 📋 Step 2: Development server test (15 seconds)...
echo -------------------------------------------------
start "DevServerTest" cmd /k "cd /d "%~dp0" && echo 🟢 Testing dev server (will be killed in 15s)... && echo. && composer run dev"
echo Waiting 15 seconds for server startup test...
timeout /t 15 >nul
echo Stopping test server...
call stop-dev.bat
echo Test server stopped.
echo.

echo ✅ Part 1 Complete!
echo ===================
echo.
echo 🚀 Automatically launching Part 2 in a new window...
start "Full Setup Part 2" cmd /c "cd /d "%~dp0" && full-setup-part2.bat"
echo.
echo Part 1 exiting. Part 2 will handle the final setup.
echo.
pause