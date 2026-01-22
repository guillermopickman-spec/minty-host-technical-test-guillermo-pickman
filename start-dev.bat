@echo off
echo 🚀 Starting Minty Host Guest Manager Development Server
echo =====================================================
echo.

:: Check if PHP is installed
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP is not installed or not in PATH
    echo Please install PHP 8.2+ from https://windows.php.net/download/
    pause
    exit /b 1
)

:: Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js 18+ from https://nodejs.org/
    pause
    exit /b 1
)

:: Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed or not in PATH
    echo Please install npm (comes with Node.js)
    pause
    exit /b 1
)

echo ✅ All required tools are installed!
echo.
echo 🌐 Starting development servers...
echo 📦 This will start:
echo   - Laravel development server (http://localhost:8000)
echo   - Vite development server (http://localhost:5173)
echo   - Queue listener
echo   - Log monitor
echo.
echo ⚠️  Press Ctrl+C to stop all servers
echo.

:: Start the development environment using Laravel's built-in script
composer run dev
