@echo off
echo 🚀 Minty Host Guest Manager - Setup Script
echo ===========================================
echo.

:: Check if PHP is installed
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP is not installed or not in PATH
    echo Please install PHP 8.2+ from https://windows.php.net/download/
    echo Then restart this script
    pause
    exit /b 1
)

:: Check if Composer is installed
composer --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Composer is not installed or not in PATH
    echo Please install Composer from https://getcomposer.org/download/
    echo Then restart this script
    pause
    exit /b 1
)

:: Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js 18+ from https://nodejs.org/
    echo Then restart this script
    pause
    exit /b 1
)

:: Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed or not in PATH
    echo Please install npm (comes with Node.js)
    echo Then restart this script
    pause
    exit /b 1
)

echo ✅ All required tools are installed!
echo.

:: Install PHP dependencies
echo 📦 Installing PHP dependencies...
composer install
if %errorlevel% neq 0 (
    echo ❌ Failed to install PHP dependencies
    pause
    exit /b 1
)

:: Create .env file if it doesn't exist
if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
)

:: Generate application key
echo 🔑 Generating application key...
php artisan key:generate
if %errorlevel% neq 0 (
    echo ❌ Failed to generate application key
    pause
    exit /b 1
)

:: Create SQLite database if it doesn't exist
if not exist database\database.sqlite (
    echo 🗄️ Creating SQLite database...
    echo. > database\database.sqlite
)

:: Run migrations
echo 🗃️ Running database migrations...
php artisan migrate --force
if %errorlevel% neq 0 (
    echo ❌ Failed to run migrations
    pause
    exit /b 1
)

:: Install JavaScript dependencies
echo 📦 Installing JavaScript dependencies...
npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install JavaScript dependencies
    pause
    exit /b 1
)

:: Build frontend assets
echo 🏗️ Building frontend assets...
npm run build
if %errorlevel% neq 0 (
    echo ❌ Failed to build frontend assets
    pause
    exit /b 1
)

echo.
echo ✅ Setup completed successfully!
echo.
echo 🚀 To start the development server, run:
echo    composer run dev
echo.
echo 🌐 The application will be available at:
echo    http://localhost:8000
echo.
echo 📚 For more information, see README.md
echo.
pause
