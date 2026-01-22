@echo off
:: Ensure the script runs from the project root
cd /d "%~dp0"
:: Enable UTF-8 for clear logging and emojis
CHCP 65001 >nul

echo 🚀 Minty Host - Professional Setup
echo ===========================================

:: 1. EARLY SYSTEM PREPARATION
:: Create files immediately to give Windows time to release locks
if not exist .env copy .env.example .env >nul

if not exist database mkdir database
if exist database\database.sqlite del /f /q database\database.sqlite
:: Using 'type nul' ensures a clean SQLite file is ready
type nul > database\database.sqlite

:: 2. DEPENDENCY INSTALLATION
echo 📦 Installing PHP dependencies...
:: --no-scripts prevents Laravel from crashing before the environment is ready
call composer install --ignore-platform-reqs --no-scripts

echo 📦 Installing JavaScript dependencies...
call npm install

:: 3. THE "FORCE DISCOVERY" PHASE
:: This tells Laravel to manually register all packages and clear old states
echo 🔧 Initializing Laravel Framework...
call php artisan package:discover --ansi
call php artisan config:clear >nul 2>&1

:: 4. AUTOMATED SETUP RETRY LOGIC
:: First attempt to generate key and migrate
echo 🗃️ Setting up Database...
call php artisan key:generate --force
call php artisan migrate:fresh --seed --force

:: Verification: If the database is still locked/missing, we wait and retry
php artisan db:show >nul 2>&1
if %errorlevel% neq 0 (
    echo ⏳ System busy, retrying synchronization...
    timeout /t 3 >nul
    call php artisan migrate:fresh --seed --force
)

:: 5. VITE PRE-OPTIMIZATION & FINAL BUILD
:: This is the "Secret Sauce": It forces Vite to stabilize hashes before the build
echo ⚡ Stabilizing frontend assets...
call npx vite optimize --force >nul 2>&1

echo 🏗️  Building frontend (Production Mode)...
call npm run build

:: 6. CLEANUP
call php artisan config:cache >nul 2>&1

echo.
echo ===========================================
echo ✅ SETUP COMPLETED SUCCESSFULLY!
echo ===========================================
echo.
echo 🚀 Next step: Run 'start-dev.bat' or 'php artisan serve'
echo.
pause