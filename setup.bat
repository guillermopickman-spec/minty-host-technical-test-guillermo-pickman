@echo off
cd /d "%~dp0"
CHCP 65001 >nul

echo 🚀 Minty Host Guest Manager - Setup Script
echo ===========================================
echo.

:: --- Verificación de Requisitos ---
echo 🔍 Checking Environment...

php --version >nul 2>&1 || (echo ❌ PHP not found. & pause & exit /b 1)
call composer --version >nul 2>&1 || (echo ❌ Composer not found. & pause & exit /b 1)
node --version >nul 2>&1 || (echo ❌ Node.js not found. & pause & exit /b 1)
call npm --version >nul 2>&1 || (echo ❌ npm not found. & pause & exit /b 1)

echo ✅ Environment OK.

:: --- Pasos de Instalación ---

echo 📦 Installing PHP dependencies...
call composer install --ignore-platform-reqs

if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
)

echo 🔑 Generating application key...
call php artisan key:generate

:: Asegurar que la carpeta database existe
if not exist database ( mkdir database )

:: Resetear base de datos SQLite
echo 🗄️ Setting up SQLite database...
copy /y nul database\database.sqlite >nul

echo 🗃️ Running migrations and seeding...
:: Usamos migrate:fresh para asegurar que la estructura sea limpia
call php artisan migrate:fresh --seed --force

echo 📦 Installing JS dependencies...
call npm install

echo 🏗️ Building frontend assets (Vite)...
:: ESTO arregla el error 404 que viste antes
call npm run build

echo.
echo ✅ Setup completed successfully!
echo.
echo 💡 Now run your start script or 'php artisan serve'
echo.
pause