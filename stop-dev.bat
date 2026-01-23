@echo off
:: Stop development server processes
echo Stopping development server...

:: Kill specific dev server windows (this will terminate the processes inside)
echo Killing dev server windows...
taskkill /fi "WINDOWTITLE eq DevServerAttempt1*" /t /f >nul 2>&1
taskkill /fi "WINDOWTITLE eq Dev Server*" /t /f >nul 2>&1
taskkill /fi "WINDOWTITLE eq Minty Host Dev Server*" /t /f >nul 2>&1
taskkill /fi "WINDOWTITLE eq DevServerTest*" /t /f >nul 2>&1

:: Kill any remaining cmd windows with dev-related titles
taskkill /fi "IMAGENAME eq cmd.exe" /fi "WINDOWTITLE eq *DevServer*" /t /f >nul 2>&1
taskkill /fi "IMAGENAME eq cmd.exe" /fi "WINDOWTITLE eq *Minty*" /t /f >nul 2>&1
taskkill /fi "IMAGENAME eq cmd.exe" /fi "WINDOWTITLE eq *DevServerTest*" /t /f >nul 2>&1

:: Kill any remaining dev server processes (PHP and Node.js)
:: Note: This may affect VS Code if it's running, you may need to restart it
echo Killing PHP processes...
taskkill /im php.exe /f >nul 2>&1
echo Killing Node.js processes...
taskkill /im node.exe /f >nul 2>&1

echo Development server stopped.
