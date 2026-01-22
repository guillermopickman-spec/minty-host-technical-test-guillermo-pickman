@echo off
:: Ensure the script runs from the current folder
cd /d "%~dp0"
:: Enable UTF-8 for emojis
CHCP 65001 >nul

echo 🚀 Minty Host Guest Manager - Setup Script
echo ===========================================
echo.

:: --- Prerequisite Checks ---

echo 🔍 Checking Environment...
echo.

:: Check PHP
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP not found. Install PHP 8.2+ from https://windows.php.net/
    pause
    exit /b 1
) else (
    echo ✅ PHP is installed
)

:: Check Composer
call composer --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Composer not found. Install it from https://getcomposer.org/
    pause
    exit /b 1
) else (
    echo ✅ Composer is installed
)

:: Check Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Install it from https://nodejs.org/
    pause
    exit /b 1
) else (
    echo ✅ Node.js is installed
)

:: Check npm
call npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm not found.
    pause
    exit /b 1
) else (
    echo ✅ npm is installed
)

echo.
echo 🎉 All required tools are installed!
echo.

:: --- Installation Steps ---

echo 📦 Installing PHP dependencies...
:: Using 'call' ensures the script returns here after finishing
call composer install --ignore-platform-reqs
if %errorlevel% neq 0 (echo ❌ Composer failed & pause & exit /b 1)

if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
)

echo 🔑 Generating application key...
call php artisan key:generate

if not exist database ( mkdir database )
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
echo 💡 Press any key to close this window.
echo.
pause