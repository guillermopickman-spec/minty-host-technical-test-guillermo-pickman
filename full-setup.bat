@echo off
:: Full setup script that handles the double-setup workaround with new windows

:: Check for administrator privileges and request elevation if needed
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell "start-process '%~f0' -verb runas"
    exit /b
)

cd /d "%~dp0"
CHCP 65001 >nul

echo 🚀 Minty Host Guest Manager - Full Automated Setup
echo ===================================================
echo This script runs the setup process twice with proper window management
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
if exist setup_complete.flag (
    echo ✅ Setup completion flag detected!
    del setup_complete.flag
    goto setup1_done
)
goto wait_setup1
:setup1_done
echo First setup completed.
echo.

echo 📋 Step 2: First development server attempt (new window)...
echo --------------------------------------------------------
start "DevServerAttempt1" cmd /k "cd /d "%~dp0" && echo 🟢 Starting dev server (first attempt)... && echo. && composer run dev"
echo Waiting 15 seconds for server startup attempt...
timeout /t 15 >nul

echo Refreshing browser page to initialize application...
powershell -Command "$ie = New-Object -ComObject 'InternetExplorer.Application'; $ie.Navigate('http://localhost:8000'); $ie.Visible = $false; Start-Sleep 2; $ie.Refresh(); Start-Sleep 5; $ie.Quit()" >nul 2>&1
echo Browser refresh completed.
echo.

echo Stopping first dev server...
call stop-dev.bat
echo First dev server stopped.
echo.

echo 📋 Step 3: Second setup attempt (new window)...
echo ---------------------------------------------
if exist setup_complete.flag del setup_complete.flag
start "Setup-Attempt-2" cmd /c "cd /d "%~dp0" && setup.bat"
echo Waiting for second setup to complete...
:wait_setup2
timeout /t 2 >nul
if not exist setup_complete.flag goto wait_setup2
del setup_complete.flag
echo Second setup completed.
echo.

echo 📋 Step 4: Final development server start (new window)...
echo -----------------------------------------------------
start "Minty Host Dev Server - Final" cmd /k "cd /d "%~dp0" && echo 🟢 Starting dev server (final)... && echo. && echo Server should be available at: http://localhost:8000 && echo. && composer run dev"

echo Waiting 10 seconds for final server to start...
timeout /t 10 >nul

echo 📋 Step 5: Warming up application...
echo -----------------------------------
echo Making initial request to warm up the application...
curl -s -o nul http://localhost:8000 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Application warmed up successfully!
) else (
    echo ⚠️  Warm-up request failed, but continuing...
)
echo.

echo  Step 6: Opening browser...
echo ---------------------------
start http://localhost:8000
echo.
echo 📝 If you need to restart later, just run start-dev.bat
echo.
pause
