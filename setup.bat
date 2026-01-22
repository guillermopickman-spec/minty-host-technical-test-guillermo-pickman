@echo off
SETLOCAL EnableExtensions
CHCP 65001 >nul
:: Ensure we are in the script's directory
cd /d "%~dp0"

echo 🚀 Minty Host Guest Manager - Setup Script
echo ===========================================
echo.

:: --- Prerequisite Checks ---

echo 🔍 Checking Environment...
php --version >nul 2>&1 || (echo ❌ PHP not found. Install PHP 8.2+ & pause & exit /b 1)
composer --version >nul 2>&1 || (echo ❌ Composer not found. & pause & exit /b 1)
node --version >nul 2>&1 || (echo ❌ Node.js not found. & pause & exit /b 1)
npm --version >nul 2>&1 || (echo ❌ npm not found. & pause & exit /b 1)

echo ✅ All required tools are installed!
echo.

:: --- Installation Steps ---

echo 📦 Installing PHP dependencies...
call composer install --ignore-platform-reqs
if %errorlevel% neq 0 (echo ❌ Composer failed & pause & exit /b 1)

if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
)

echo 🔑 Generating application key...
call php artisan key:generate

if not exist database\database.sqlite (
    echo 🗄️ Creating SQLite database...
    type nul > database\database.sqlite
)

echo 🗃️ Running database migrations...
call php artisan migrate --force --no-interaction

echo 📦 Installing JavaScript dependencies...
call npm install

echo 🏗️ Building frontend assets...
call npm run build

echo.
echo ✅ Setup completed successfully!
echo 🚀 Run 'start-dev.bat' to begin.
echo.
pause
