@echo off
:: Stop development server processes
echo Stopping development server...

:: Kill all PHP processes (Laravel server, queue worker)
echo Killing PHP processes...
taskkill /im php.exe /f >nul 2>&1

:: Kill all Node.js processes (Vite dev server)
echo Killing Node.js processes...
taskkill /im node.exe /f >nul 2>&1

:: Kill specific dev server windows
echo Killing dev server windows...
taskkill /fi "WINDOWTITLE eq DevServerAttempt1*" /t /f >nul 2>&1
taskkill /fi "WINDOWTITLE eq Dev Server*" /t /f >nul 2>&1
taskkill /fi "WINDOWTITLE eq Minty Host Dev Server*" /t /f >nul 2>&1

:: Kill any remaining cmd windows with dev-related titles
taskkill /fi "IMAGENAME eq cmd.exe" /fi "WINDOWTITLE eq *DevServer*" /t /f >nul 2>&1
taskkill /fi "IMAGENAME eq cmd.exe" /fi "WINDOWTITLE eq *Minty*" /t /f >nul 2>&1

echo Development server stopped.