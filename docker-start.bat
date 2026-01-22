@echo off
echo 🐳 Starting Minty Host Guest Manager with Docker
echo =================================================
echo.

:: Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed or not in PATH
    echo Please install Docker Desktop from https://www.docker.com/products/docker-desktop/
    echo Then restart this script
    pause
    exit /b 1
)

:: Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed or not in PATH
    echo Please install Docker Compose (comes with Docker Desktop)
    echo Then restart this script
    pause
    exit /b 1
)

echo ✅ Docker is installed!
echo.
echo 🚀 Starting containers...
echo 📦 This will start:
echo   - PHP/Apache server (http://localhost:8000)
echo   - MySQL database
echo   - Node.js frontend server (http://localhost:5173)
echo.
echo ⚠️  Press Ctrl+C to stop all containers
echo.

:: Start Docker containers
docker-compose up

echo.
echo 🛑 Stopping containers...
docker-compose down
