@echo off
SETLOCAL EnableExtensions
CHCP 65001 >nul
cd /d "%~dp0"

echo 🚀 Minty Host Guest Manager - Development Server Launcher
echo ===========================================================
echo.

:: Prerequisites Check
echo 🔍 Checking prerequisites...

:: Check PHP
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP is not installed or not in PATH
    echo    Please install PHP 8.2+ and add it to your system PATH
    pause & exit /b 1
) else (
    for /f "tokens=2" %%i in ('php --version ^| findstr /C:"PHP"') do echo ✅ PHP: %%i
)

:: Check Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo    Please install Node.js 18+ and add it to your system PATH
    pause & exit /b 1
) else (
    for /f "tokens=1" %%i in ('node --version') do echo ✅ Node.js: %%i
)

:: Check npm
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed
    pause & exit /b 1
) else (
    for /f "tokens=1" %%i in ('npm --version') do echo ✅ npm: %%i
)

:: Check if .env exists
if not exist .env (
    echo ❌ .env file not found
    echo    Please run setup.bat first or copy .env.example to .env
    pause & exit /b 1
) else (
    echo ✅ Environment file found
)

echo.
echo 🌐 Starting development environment...
echo 📋 Services that will start:
echo    • Laravel development server (http://localhost:8000)
echo    • Vite development server (hot reload)
echo    • Queue worker (for background jobs)
echo.
echo ⚠️  IMPORTANT: Close the command window to stop all servers
echo.

:: Start the development environment
start "🚀 Minty Host Dev Server" cmd /k "cd /d "%~dp0" && echo 🟢 Starting development environment... && echo. && composer run dev"

echo 🎉 Development server started!
echo 📱 Open your browser to: http://localhost:8000
echo.

pause
