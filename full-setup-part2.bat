@echo off
:: Full Setup Part 2: Final setup and server start
:: This runs after Part 1 completes

:: Check for administrator privileges and request elevation if needed
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges for Part 2...
    powershell "start-process '%~f0' -verb runas"
    exit /b
)

cd /d "%~dp0"
CHCP 65001 >nul

echo 🚀 Minty Host - Full Setup Part 2
echo ================================
echo Final setup and server startup phase
echo.

echo 🧹 Final cleanup...
call stop-dev.bat
taskkill /fi "WINDOWTITLE eq Setup*" /t /f >nul 2>&1
echo Cleanup complete.
echo.

echo 📋 Step 1: Final setup (new window)...
echo -------------------------------------
if exist setup_complete.flag del setup_complete.flag
start "Setup-Final" cmd /c "cd /d "%~dp0" && setup.bat"
echo Waiting for final setup to complete...
:wait_setup
timeout /t 2 >nul
if not exist setup_complete.flag goto wait_setup
del setup_complete.flag
echo Final setup completed successfully!
echo.

echo 📋 Step 2: Starting production development server...
echo ---------------------------------------------------
start "Minty Host Dev Server" cmd /k "cd /d "%~dp0" && echo 🟢 Minty Host Development Server && echo. && echo Server: http://localhost:8000 && echo Vite: http://localhost:5173 && echo. && echo Press Ctrl+C to stop && echo. && composer run dev"

echo Waiting 10 seconds for server to start...
timeout /t 10 >nul

echo 📋 Step 3: Warming up application...
echo -----------------------------------
echo Making initial request to warm up the application...
curl -s -o nul http://localhost:8000 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Application warmed up successfully!
) else (
    echo ⚠️  Warm-up request failed, but continuing...
)
echo.

echo 📋 Step 4: Opening browser...
echo ---------------------------
start http://localhost:8000

echo.
echo ===========================================
echo ✅ FULL SETUP COMPLETE!
echo ===========================================
echo.
echo 🌐 Application is running at:
echo    http://localhost:8000
echo.
echo 🚀 Development server is running in background.
echo    Close the "Minty Host Dev Server" window to stop.
echo.
echo 📝 Use stop-dev.bat if you need to stop manually.
echo.
pause