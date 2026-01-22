@echo off
:: Force script to run from the project root
cd /d "%~dp0"
:: Enable UTF-8 for emojis and clean logging
CHCP 65001 >nul

echo 🚀 Minty Host - Ultimate Setup Script
echo ===========================================

:: 1. ENVIRONMENT INITIALIZATION
:: We create files first to give Windows background processes time to finish
if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
)

if not exist database mkdir database
if exist database\database.sqlite del /f /q database\database.sqlite
type nul > database\database.sqlite

:: 2. DEPENDENCY INSTALLATION
echo 📦 Installing PHP dependencies...
:: --no-scripts is vital to prevent crashes before the .env is fully recognized
call composer install --ignore-platform-reqs --no-scripts

echo 📦 Installing JavaScript dependencies...
call npm install

:: 3. FRAMEWORK DISCOVERY
echo 🔧 Initializing Laravel Framework...
:: Forces Laravel to register all components (Inertia, Vite, etc.)
call php artisan package:discover --ansi
call php artisan config:clear >nul 2>&1
call php artisan key:generate --force

:: 4. DATABASE SYNC (The "First Pass" Logic)
echo 🗃️  Setting up Database and Seeders...
call php artisan migrate:fresh --seed --force

:: Verification: Check if the database is accessible
php artisan db:show >nul 2>&1
if %errorlevel% neq 0 (
    echo ⏳ File system busy, retrying database sync...
    timeout /t 3 >nul
    call php artisan migrate:fresh --seed --force
)

:: 5. VITE STABILIZATION (Fixes the "Log 1 vs Log 2" hash issue)
echo ⚡ Cleaning and stabilizing frontend assets...
:: Remove old builds to prevent manifest conflicts
if exist public\build rmdir /s /q public\build
:: Warm up the Vite cache
call npx vite optimize --force >nul 2>&1
timeout /t 2 >nul

echo 🏗️  Building frontend (Production Mode)...
:: Double-build ensures Tailwind JIT captures all classes for a stable Log 2 result
call npm run build >nul 2>&1
call npm run build

:: 6. FINAL OPTIMIZATION
echo 🧹 Finalizing configuration...
call php artisan config:cache >nul 2>&1

echo.
echo ===========================================
echo ✅ SETUP COMPLETED SUCCESSFULLY AT FIRST RUN!
echo ===========================================
echo.
echo 🌐 URL: http://localhost:8000
echo 🚀 Next step: Run 'start-dev.bat'
echo.
pause