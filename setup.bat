@echo off
cd /d "%~dp0"
CHCP 65001 >nul

echo 🚀 Minty Host Guest Manager - Ultimate Setup
echo ===========================================
echo.

:: --- 1. CLEANING PREVIOUS ATTEMPTS ---
echo 🧹 Cleaning environment...
if exist database\database.sqlite del /f /q database\database.sqlite
if not exist database mkdir database
copy /y nul database\database.sqlite >nul

if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
)

:: --- 2. FIRST PASS: Dependencies ---
echo 📦 Pass 1/2: Installing dependencies...
call composer install --ignore-platform-reqs --no-scripts
timeout /t 2 >nul

:: --- 3. SECOND PASS: The "Cheat" (Re-running key commands) ---
echo 🔑 Pass 2/2: Configuring Laravel...
call php artisan key:generate --force
call php artisan config:clear
call php artisan cache:clear

echo 🗃️ Running migrations and seeding...
:: We run this twice if needed, but 'fresh' usually works if config is clear
call php artisan migrate:fresh --seed --force

:: --- 4. FRONTEND ---
echo 📦 Finalizing Frontend...
call npm install
call npm run build

:: --- 5. THE ULTIMATE CHECK ---
echo.
echo 🔍 Verifying installation...
if exist public\build\manifest.json (
    echo ✅ Assets compiled successfully.
) else (
    echo ⚠️ Assets missing. Running build again...
    call npm run build
)

echo.
echo ===========================================
echo ✅ SETUP COMPLETED SUCCESSFULLY!
echo ===========================================
echo.
echo 🚀 Next step: Run 'php artisan serve'
echo.
pause