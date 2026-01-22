@echo off
:: Asegura que el script se ejecute en la carpeta del proyecto
cd /d "%~dp0"
:: Forzar UTF-8 para evitar errores de caracteres y emojis
CHCP 65001 >nul

echo 🚀 Minty Host Guest Manager - Setup Script
echo ===========================================
echo.

:: --- 1. Verificación de Requisitos ---
echo 🔍 Checking Environment...

php --version >nul 2>&1 || (echo ❌ PHP not found. & pause & exit /b 1)
call composer --version >nul 2>&1 || (echo ❌ Composer not found. & pause & exit /b 1)
node --version >nul 2>&1 || (echo ❌ Node.js not found. & pause & exit /b 1)
call npm --version >nul 2>&1 || (echo ❌ npm not found. & pause & exit /b 1)

echo ✅ Environment OK.
echo.

:: --- 2. Instalación de Dependencias ---
echo 📦 Installing PHP dependencies...
:: --ignore-platform-reqs evita que el script se detenga por versiones de PHP o extensiones faltantes
call composer install --ignore-platform-reqs
if %errorlevel% neq 0 (echo ❌ Composer failed. & pause & exit /b 1)

:: --- 3. Configuración del Entorno ---
if not exist .env (
    echo 📝 Creating .env file from .example...
    copy .env.example .env >nul
    :: Pequeña pausa para que Windows registre el nuevo archivo antes de que Artisan lo use
    timeout /t 2 >nul
)

:: Limpieza de caché previa por si el usuario está reinstalando
echo 🧹 Cleaning Laravel cache...
call php artisan config:clear >nul 2>&1
call php artisan cache:clear >nul 2>&1

echo 🔑 Generating application key...
call php artisan key:generate

:: --- 4. Base de Datos (SQLite) ---
if not exist database ( mkdir database )

echo 🗄️ Initializing SQLite database...
:: Usamos copy /y nul para asegurar que el archivo existe y está limpio
copy /y nul database\database.sqlite >nul

echo 🗃️ Running migrations and seeding test data...
:: migrate:fresh es ideal para pruebas técnicas porque garantiza una base limpia
call php artisan migrate:fresh --seed --force
if %errorlevel% neq 0 (echo ❌ Database setup failed. & pause & exit /b 1)

:: --- 5. Frontend (Vite) ---
echo 📦 Installing JavaScript dependencies...
call npm install

echo 🏗️ Building frontend assets (Vite)...
:: Genera los archivos en /public/build para evitar errores 404
call npm run build

echo.
echo ===========================================
echo ✅ SETUP COMPLETED SUCCESSFULLY!
echo ===========================================
echo.
echo 🌐 URL: http://localhost:8000
echo 🚀 Next step: Run 'php artisan serve' or your start script.
echo.
pause