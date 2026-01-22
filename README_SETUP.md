# 🚀 Quick Start Guide

## One-Click Setup (Windows)

If you're on Windows, you can get up and running in seconds with our automated setup scripts:

### 1. Initial Setup
Double-click `setup.bat` to automatically:
- ✅ Check if PHP, Composer, Node.js, and npm are installed
- ✅ Install PHP dependencies with Composer
- ✅ Create `.env` file and generate application key
- ✅ Create SQLite database
- ✅ Run database migrations
- ✅ Install JavaScript dependencies with npm
- ✅ Build frontend assets

### 2. Start Development
Double-click `start-dev.bat` to automatically:
- ✅ Check if required tools are installed
- ✅ Start all development servers (Laravel, Vite, Queue, Logs)
- ✅ Open the application in your browser

## Manual Setup (All Platforms)

If you prefer manual setup or are on macOS/Linux:

### Prerequisites
- **PHP 8.2+** - [Download PHP](https://windows.php.net/download/)
- **Composer** - [Download Composer](https://getcomposer.org/download/)
- **Node.js 18+** - [Download Node.js](https://nodejs.org/)
- **npm** (comes with Node.js)

### Installation Steps

```bash
# 1. Clone or download the project
git clone <repository-url>
cd minty-host-guest-manager

# 2. Install PHP dependencies
composer install

# 3. Create environment file
cp .env.example .env

# 4. Generate application key
php artisan key:generate

# 5. Create SQLite database
touch database/database.sqlite

# 6. Run database migrations
php artisan migrate --force

# 7. Install JavaScript dependencies
npm install

# 8. Build frontend assets
npm run build
```

### Start Development Server

```bash
# Start all development servers
composer run dev
```

## What Gets Started

The development environment includes:
- **Laravel Server**: http://localhost:8000
- **Vite Dev Server**: http://localhost:5173
- **Queue Listener**: Background job processing
- **Log Monitor**: Real-time error tracking

## Troubleshooting

### PHP Not Found
If you get "PHP is not recognized", add PHP to your system PATH:
1. Find your PHP installation directory (e.g., `C:\php`)
2. Add it to your system PATH environment variable
3. Restart your command prompt

### Composer Not Found
If you get "Composer is not recognized":
1. Download and install Composer from [getcomposer.org](https://getcomposer.org/download/)
2. Restart your command prompt

### Node.js/npm Not Found
If you get "Node.js is not recognized":
1. Download and install Node.js from [nodejs.org](https://nodejs.org/)
2. Restart your command prompt

## Production Deployment

For production deployment, use the manual setup steps above, then:

```bash
# Build for production
npm run build

# Clear caches
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start production server
php artisan serve --host=0.0.0.0 --port=8000
```

## Support

If you encounter issues:
1. Check that all prerequisites are installed
2. Ensure you're running the scripts from the project root directory
3. Check the troubleshooting section above
4. Review the main [README.md](README.md) for additional information
