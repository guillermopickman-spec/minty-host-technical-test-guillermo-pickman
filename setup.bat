@echo off
cd /d "%~dp0"
CHCP 65001 >nul

echo 🚀 Minty Host Guest Manager - Setup Script
echo ===========================================
echo.

:: --- 1. Verificación de Requisitos ---
echo 🔍 Checking Environment...
php --version >nul 2>&1 || (echo ❌ PHP not found. & pause & exit /b 1)
call composer --version >nul 2>&1 || (echo ❌ Composer not found. & pause & exit /b 1)
node --version >nul 2>&1 || (echo ❌ Node.js not found. & pause & exit /b 1)
echo ✅ Environment OK.
echo.

:: --- 2. Instalación de Dependencias ---
echo 📦 Installing PHP dependencies...
call composer install --ignore-platform-reqs

:: --- 3. Configuración del Entorno ---
if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
    timeout /t 1 >nul
)

echo 🔑 Generating application key...
call php artisan key:generate --force

:: --- 4. Base de Datos (SQLite) ---
if not exist database ( mkdir database )
echo 🗄️ Initializing SQLite database...
:: El comando 'del' asegura que si hay una DB corrupta, la borramos para empezar de cero
if exist database\database.sqlite del /f /q database\database.sqlite
copy /y nul database\database.sqlite >nul

:: PAUSA CRÍTICA: Esperar a que Windows libere el archivo .sqlite
timeout /t 2 >nul

echo 🗃️ Running migrations and seeding test data...
call php artisan migrate:fresh --seed --force

:: --- 5. Frontend (Vite) ---
echo 📦 Installing JavaScript dependencies...
call npm install

echo 🏗️ Building frontend assets (Vite)...
call npm run build

echo.
echo ===========================================
echo ✅ SETUP COMPLETED SUCCESSFULLY!
echo ===========================================
echo.
echo 🌐 URL: http://localhost:8000
echo 🚀 Next step: Run 'php artisan serve'
echo.
pause