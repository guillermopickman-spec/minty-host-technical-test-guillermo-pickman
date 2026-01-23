# 📦 Installation Guide

### Requirements
- **PHP 8.2 or higher** with PDO SQLite extension enabled
- **Composer** - PHP dependency manager
- **Node.js 18+** - JavaScript runtime
- **npm** - Node.js package manager (comes with Node.js)
- **Windows 10 or higher** - Operating system

# 🚀 Quick Start

### Option 1: Full Automated Setup (Windows - Recommended)
For the complete automated experience on Windows:

1. Download or clone the repository
2. Double-click `full-setup.bat`
3. Wait for the setup to complete (it will open your browser automatically)

This script handles everything: dependencies, database setup, server startup, and browser launch.

### Option 2: Manual Windows Setup
If you prefer step-by-step setup:

1. Double-click `setup.bat` to install dependencies and set up the database
2. Double-click `start-dev.bat` to start the development servers

### Option 3: Terminal Setup (All Platforms)
For manual setup or other operating systems:

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd minty-host-guest-manager
   ```

2. **Install PHP dependencies**
   ```bash
   composer install --ignore-platform-reqs
   ```

3. **Install JavaScript dependencies**
   ```bash
   npm install
   ```

4. **Environment setup**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

5. **Database setup**
   ```bash
   php artisan migrate:fresh --seed --force
   npm run build
   ```

6. **Start the application**
   ```bash
   composer run dev
   ```

7. **Access the application**
   Open your browser and navigate to `http://localhost:8000`

**Note:** This project is tested and working on Windows. The automated scripts are optimized for Windows environments.

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
