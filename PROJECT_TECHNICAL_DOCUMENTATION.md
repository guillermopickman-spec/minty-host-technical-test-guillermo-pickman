# 📋 Minty Host Guest Manager - Technical Documentation

## 🏗️ Project Overview

**Minty Host Guest Manager** is a modern web application for managing bookings and guest data for touristic apartments. This document provides comprehensive technical details about the project architecture, technologies, and implementation.

## 📊 Project Statistics

- **Total Files**: 60+ files
- **Lines of Code**: ~2,000+ lines
- **Languages**: PHP, JavaScript, Vue.js, SQL
- **Frameworks**: Laravel 12, Vue 3, Tailwind CSS
- **Database**: SQLite (development), MySQL/PostgreSQL (production-ready)

## 🛠️ Technology Stack Deep Dive

### Backend Technologies

#### Core Framework
- **Laravel 12.47.0** - PHP web framework
  - MVC architecture
  - Eloquent ORM for database operations
  - Artisan CLI for development tasks
  - Built-in authentication and authorization
  - Service container and service providers

#### PHP Requirements
- **PHP 8.2+** - Minimum version requirement
- **Extensions Required**:
  - SQLite3 (for development database)
  - OpenSSL (for encryption)
  - PDO (for database connectivity)
  - Mbstring (for string manipulation)
  - XML (for XML processing)

#### Database Layer
- **SQLite** - Default development database
  - File-based, zero-configuration
  - Perfect for development and testing
  - Production-ready with MySQL/PostgreSQL support
- **Eloquent ORM** - Object-relational mapping
  - Active Record pattern implementation
  - Query builder integration
  - Model relationships (hasMany, belongsTo)
  - Database migrations and seeding

#### API Development
- **RESTful API Design** - Standard HTTP methods
- **JSON Response Format** - Consistent API responses
- **Error Handling** - Structured error responses
- **Validation** - Built-in Laravel validation system
- **Logging** - Monolog integration for debugging

### Frontend Technologies

#### Core Framework
- **Vue 3.5.13** - Progressive JavaScript framework
  - Composition API for better code organization
  - Reactive data binding
  - Component-based architecture
  - Virtual DOM for performance

#### State Management
- **Pinia 3.0.4** - Vue's official state management
  - TypeScript support
  - Modular store structure
  - DevTools integration
  - Persistence plugins available

#### Build Tools
- **Vite 7.0.4** - Next-generation build tool
  - Lightning-fast development server
  - Hot Module Replacement (HMR)
  - Optimized production builds
  - ES modules support

#### Styling & UI
- **Tailwind CSS 4.1.1** - Utility-first CSS framework
  - JIT compilation for performance
  - Responsive design utilities
  - Customizable design system
  - PurgeCSS integration

#### Development Tools
- **ESLint 9.17.0** - JavaScript/TypeScript linting
- **Prettier 3.4.2** - Code formatting
- **Concurrently 9.0.1** - Parallel command execution

### Integration Technologies

#### Server-Side Rendering (SSR)
- **Inertia.js 2.3.7** - Modern SPA framework
  - No client-side routing required
  - Server-side rendering support
  - Seamless page transitions
  - Laravel integration

#### Development Environment
- **Laravel Sail** - Docker development environment
- **Laravel Pint** - PHP code style fixer
- **Laravel Wayfinder** - Development tools
- **Laravel Tinker** - Interactive shell

## 📁 Project Structure Analysis

### Backend Structure (`app/`)

```
app/
├── Console/                    # Artisan commands
│   └── Commands/
│       └── InitializeBookings.php  # Database seeding command
├── Enums/                      # PHP enums
│   └── BookingStatus.php       # Booking status definitions
├── Http/                       # HTTP layer
│   ├── Controllers/           # API controllers
│   │   ├── Controller.php     # Base controller
│   │   └── MintyTestController.php  # Main API controller
│   └── Middleware/            # HTTP middleware
│       └── HandleInertiaRequests.php  # Inertia integration
├── Models/                    # Eloquent models
│   ├── Booking.php           # Booking model
│   ├── Guest.php             # Guest model
│   └── User.php              # User model (Laravel default)
└── Providers/                 # Service providers
    └── AppServiceProvider.php # Application service provider
```

### Frontend Structure (`resources/js/`)

```
resources/js/
├── app.js                     # Main application entry
├── i18n.js                    # Internationalization
├── ssr.js                     # Server-side rendering
├── components/               # Vue components
│   └── GuestForm.vue         # Guest management form
├── pages/                    # Page components
│   └── Welcome.vue           # Main application page
└── stores/                   # Pinia stores
    └── minty-test.js         # Application state
```

### Database Structure (`database/`)

```
database/
├── migrations/               # Database schema
│   ├── 0001_01_01_000000_create_users_table.php
│   ├── 0001_01_01_000001_create_cache_table.php
│   ├── 0001_01_01_000002_create_jobs_table.php
│   ├── 2026_01_20_084214_create_bookings_table.php
│   └── 2026_01_21_190250_create_guests_table.php
├── factories/                # Model factories
│   ├── BookingFactory.php    # Booking test data
│   └── GuestFactory.php      # Guest test data
└── seeders/                  # Database seeders
    └── DatabaseSeeder.php    # Main seeder
```

### Testing Structure (`tests/`)

```
tests/
├── Feature/                  # Feature tests
│   ├── ExampleTest.php       # Basic feature test
│   └── GuestApiTest.php      # API endpoint tests
├── Integration/              # Integration tests
│   ├── ApiIntegrationTest.php    # API integration
│   └── DatabaseIntegrityTest.php # Database tests
├── Unit/                     # Unit tests
│   ├── BookingModelTest.php  # Booking model tests
│   └── GuestModelTest.php    # Guest model tests
└── Browser/                  # Browser tests
    └── GuestManagementTest.php # E2E tests
```

## 🔧 Configuration Files

### PHP Configuration
- **`composer.json`** - PHP dependencies and scripts
- **`phpunit.xml`** - PHPUnit testing configuration
- **`config/`** - Laravel configuration files
  - `app.php` - Application settings
  - `database.php` - Database configuration
  - `cache.php` - Caching configuration
  - `queue.php` - Queue configuration

### JavaScript Configuration
- **`package.json`** - NPM dependencies and scripts
- **`vite.config.js`** - Vite build configuration
- **`eslint.config.js`** - ESLint configuration
- **`tailwind.config.js`** - Tailwind CSS configuration

### Development Configuration
- **`.env`** - Environment variables
- **`.env.example`** - Environment template
- **`.gitignore`** - Git ignore rules
- **`.editorconfig`** - Editor configuration
- **`pint.json`** - PHP code style rules

## 🗃️ Database Schema

### Tables

#### `bookings` Table
```sql
CREATE TABLE bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    checkin_at DATETIME NOT NULL,
    checkout_at DATETIME NOT NULL,
    status VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### `guests` Table
```sql
CREATE TABLE guests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    booking_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
```

#### `users` Table (Laravel default)
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    remember_token VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Model Relationships

#### Booking Model
```php
class Booking extends Model
{
    public function guests()
    {
        return $this->hasMany(Guest::class);
    }
}
```

#### Guest Model
```php
class Guest extends Model
{
    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }
}
```

## 🌐 API Endpoints

### Booking Endpoints

#### GET /api/bookings
- **Purpose**: Retrieve all bookings with associated guests
- **Response**: JSON array of bookings
- **Includes**: Guest data for each booking
- **Status**: 200 OK

#### POST /api/bookings
- **Purpose**: Create a new booking
- **Request Body**: Booking data (checkin_at, checkout_at, status)
- **Validation**: Required fields validation
- **Response**: Created booking data
- **Status**: 201 Created

#### PUT /api/bookings/{id}
- **Purpose**: Update existing booking
- **Request Body**: Updated booking data
- **Validation**: Model existence and data validation
- **Response**: Updated booking data
- **Status**: 200 OK

#### DELETE /api/bookings/{id}
- **Purpose**: Delete a booking
- **Validation**: Model existence
- **Response**: Success message
- **Status**: 200 OK

### Guest Endpoints

#### GET /api/guests
- **Purpose**: Retrieve all guests
- **Response**: JSON array of guests
- **Includes**: Associated booking data
- **Status**: 200 OK

#### POST /api/guests
- **Purpose**: Create a new guest
- **Request Body**: Guest data (name, email, phone, booking_id)
- **Validation**: Required fields and email format
- **Response**: Created guest data
- **Status**: 201 Created

#### PUT /api/guests/{id}
- **Purpose**: Update existing guest
- **Request Body**: Updated guest data
- **Validation**: Model existence and data validation
- **Response**: Updated guest data
- **Status**: 200 OK

#### DELETE /api/guests/{id}
- **Purpose**: Delete a guest
- **Validation**: Model existence
- **Response**: Success message
- **Status**: 200 OK

## 🧪 Testing Strategy

### Unit Tests
- **Model Tests**: Test Eloquent model functionality
- **Validation Tests**: Test input validation rules
- **Relationship Tests**: Test model relationships

### Feature Tests
- **API Tests**: Test API endpoints and responses
- **Controller Tests**: Test controller logic
- **Middleware Tests**: Test HTTP middleware

### Integration Tests
- **Database Tests**: Test database operations
- **API Integration**: Test API with real data
- **Cross-component Tests**: Test component interactions

### Browser Tests
- **E2E Tests**: Full user journey testing
- **UI Tests**: Test user interface interactions
- **Form Tests**: Test form submissions and validation

## 🚀 Development Workflow

### Local Development Setup
```bash
# 1. Clone repository
git clone <repository-url>
cd minty-host-guest-manager

# 2. Install dependencies
composer install
npm install

# 3. Environment setup
cp .env.example .env
php artisan key:generate

# 4. Database setup
php artisan migrate
php artisan db:seed

# 5. Start development servers
composer run dev
```

### Development Commands
```bash
# PHP Artisan commands
php artisan serve                    # Start development server
php artisan migrate                  # Run migrations
php artisan db:seed                  # Seed database
php artisan test                     # Run tests
php artisan lint                     # Code linting

# NPM commands
npm run dev                          # Start Vite dev server
npm run build                        # Build for production
npm run lint                         # Lint JavaScript
npm run format                       # Format code
```

### Production Deployment
```bash
# 1. Install production dependencies
composer install --optimize-autoloader --no-dev
npm ci --only=production

# 2. Build frontend assets
npm run build

# 3. Run migrations
php artisan migrate --force

# 4. Clear caches
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## 🔒 Security Considerations

### Input Validation
- **Server-side validation** using Laravel's validation system
- **Client-side validation** for better UX
- **Sanitization** of user inputs

### Authentication
- **Laravel Sanctum** for API authentication
- **CSRF protection** for web requests
- **Password hashing** using bcrypt

### Database Security
- **Parameterized queries** to prevent SQL injection
- **Model validation** for data integrity
- **Foreign key constraints** for referential integrity

### Error Handling
- **Structured error responses** for API
- **Logging** of errors for debugging
- **No sensitive information** in error messages

## 📈 Performance Optimization

### Backend Optimization
- **Eager loading** to prevent N+1 queries
- **Database indexing** for frequently queried fields
- **Caching** for frequently accessed data
- **Queue processing** for background tasks

### Frontend Optimization
- **Code splitting** with Vite
- **Lazy loading** of components
- **Image optimization** for faster loading
- **Bundle analysis** for size optimization

### Database Optimization
- **Indexing** on search fields
- **Query optimization** with Eloquent
- **Connection pooling** for production
- **Database migrations** for schema changes

## 🔄 CI/CD Pipeline

### Development Workflow
1. **Feature Branch** - Create feature branches
2. **Code Review** - Pull request reviews
3. **Automated Testing** - Run test suites
4. **Code Quality** - Linting and formatting
5. **Deployment** - Automated deployment

### Testing Pipeline
```yaml
# Example GitHub Actions workflow
- name: Run PHP tests
  run: php artisan test

- name: Run JavaScript tests
  run: npm test

- name: Code quality checks
  run: |
    npm run lint
    npm run format:check
```

## 📊 Monitoring & Logging

### Application Logging
- **Monolog integration** for structured logging
- **Multiple log channels** (single, daily, syslog)
- **Error tracking** for production issues

### Performance Monitoring
- **Query logging** for database optimization
- **Request timing** for performance analysis
- **Memory usage** monitoring

### Error Tracking
- **Exception handling** with detailed error messages
- **Log aggregation** for centralized monitoring
- **Alerting** for critical issues

## 🎨 UI/UX Architecture

### Component Structure
- **Atomic Design** principles
- **Reusable components** for consistency
- **Responsive design** for all devices
- **Accessibility** compliance (WCAG)

### State Management
- **Pinia stores** for global state
- **Local component state** for UI interactions
- **Reactive data** for real-time updates

### Styling Architecture
- **Tailwind CSS** utility classes
- **Component-specific styles**
- **Responsive breakpoints**
- **Design tokens** for consistency

## 🔧 Troubleshooting Guide

### Common Issues

#### Database Connection
```bash
# Check database configuration
php artisan tinker
>>> DB::connection()->getPdo();
```

#### Frontend Build Issues
```bash
# Clear Vite cache
rm -rf node_modules/.vite

# Rebuild assets
npm run build
```

#### API Issues
```bash
# Check API routes
php artisan route:list

# Test API endpoints
curl http://localhost:8000/api/bookings
```

### Debugging Tools
- **Laravel Telescope** for development debugging
- **Vue DevTools** for frontend debugging
- **Browser Developer Tools** for client-side issues
- **Laravel Log Viewer** for server-side issues

## 📚 Additional Resources

### Documentation Links
- [Laravel Documentation](https://laravel.com/docs)
- [Vue.js Documentation](https://vuejs.org/guide/introduction.html)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Vite Documentation](https://vitejs.dev/guide/)

### Development Tools
- **Laravel Valet** - Local development environment
- **Laravel Mix** - Webpack wrapper
- **Laravel Dusk** - Browser testing
- **Laravel Horizon** - Queue monitoring

### Community Resources
- **Laravel News** - Latest Laravel updates
- **Vue.js Forum** - Community support
- **Tailwind CSS Discord** - Real-time help
- **GitHub Issues** - Bug reports and feature requests

---

**Last Updated**: January 22, 2026  
**Version**: 1.0.0  
**Maintainer**: Guillermo Pickman  
**License**: MIT
