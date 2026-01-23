@echo off
SETLOCAL EnableExtensions
CHCP 65001 >nul
cd /d "%~dp0"

echo 🚀 Starting Minty Host Guest Manager Development Server
echo =====================================================
echo.

:: Quick validation
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP missing & pause & exit /b 1
)

echo 🌐 Starting development environment...
echo ⚠️  Close the new window to stop the servers.
echo.

:: Start the dev process in a new titled window
start "Minty Host Dev Server" cmd /k "cd /d "%~dp0" && echo 🟢 Booting Laravel + Vite... && echo. && echo To stop servers: Press Ctrl+C && echo. && composer run dev"

exit
