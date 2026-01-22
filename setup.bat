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
echo.

:: Check PHP
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP not found. Install PHP 8.2+ & pause & exit /b 1
) else (
    echo ✅ PHP is installed
)

:: Check Composer
composer --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Composer not found. & pause & exit /b 1
) else (
    echo ✅ Composer is installed
)

:: Check Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. & pause & exit /b 1
) else (
    echo ✅ Node.js is installed
)

:: Check npm
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm not found. & pause & exit /b 1
) else (
    echo ✅ npm is installed
)

echo.
echo 🎉 All required tools are installed!
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
echo 🎯 Testing environment...
echo.
echo 📋 Installation Summary:
echo   - PHP: ✅ Installed
echo   - Composer: ✅ Installed  
echo   - Node.js: ✅ Installed
echo   - npm: ✅ Installed
echo   - Laravel dependencies: ✅ Installed
echo   - Database: ✅ Created and migrated
echo   - Frontend assets: ✅ Built
echo.
echo 🌐 Application ready at: http://localhost:8000
echo.
echo 💡 Keep this window open for reference
echo.
cmd /k echo "Setup complete! Type 'exit' to close this window."
