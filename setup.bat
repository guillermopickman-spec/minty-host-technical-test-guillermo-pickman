@echo off
cd /d "%~dp0"
CHCP 65001 >nul

echo 🚀 Minty Host - Professional Setup
echo ===========================================

:: 1. CREATE FILES EARLY
:: Creating them at the very start gives Windows time to "unlock" them
if not exist .env copy .env.example .env >nul
if not exist database mkdir database
if exist database\database.sqlite del /f /q database\database.sqlite
type nul > database\database.sqlite

:: 2. INSTALL DEPENDENCIES (Long process gives OS time to breathe)
echo 📦 Installing dependencies...
call composer install --ignore-platform-reqs --no-scripts
call npm install

:: 3. THE SMART "DOUBLE ATTEMPT"
:: We try once, and if it fails, we wait and try again automatically.
echo 🔧 Configuring Laravel...

:ATTEMPT1
call php artisan key:generate --force >nul 2>&1
call php artisan migrate:fresh --seed --force >nul 2>&1

:: Check if migrations actually worked (looking for a table in sqlite)
php artisan db:show >nul 2>&1
if %errorlevel% neq 0 (
    echo ⏳ Finalizing system sync...
    timeout /t 3 >nul
    call php artisan config:clear >nul
    call php artisan key:generate --force
    call php artisan migrate:fresh --seed --force
)

:: 4. FINAL BUILD
echo 🏗️  Building frontend...
call npm run build

echo.
echo ===========================================
echo ✅ SETUP SUCCESSFUL!
echo ===========================================
pause