# Minty Host – Practical Case

This project represents a web application for a company that manages bookings for touristic apartments. The application is built with **Laravel** on the backend and **Vue** on the frontend.

The core booking data model and related functionality are already implemented. The goal of this practical case is to extend the existing system by introducing a new feature that allows the company to manage **guest data associated with bookings**.

As part of this exercise, you will design and implement the necessary backend and frontend changes to link guests to bookings, expose the required data through the API, and display and manage relevant information in the user interface.

## 🎯 Objectives

- Complete the case in approximately **2 hours**.  
- Follow **Laravel and Vue conventions**, ensuring clean, readable, and well-structured code.  
- Demonstrate autonomy in providing a **user-friendly interface**, including responsive design and helpful user feedback.  
- **Showcase end-to-end implementation skills:** Ability to build features that integrate frontend and backend seamlessly.  
- **Use the provided stack:** Stylize with Tailwind CSS, use Vue 3 Composition API, Pinia, and Laravel Eloquent ORM.

## 🚀 Project Setup

### Prerequisites
- PHP 8.2+ with the SQLite extension enabled  
- Composer  
- Node.js + npm  

### Getting Started
1. **Install dependencies:**  
   ```bash
   composer install
   npm install
   ```
2. **Environment setup:**  
   The `.env` file is already provided. If you prefer to regenerate it:  
   ```bash
   cp .env.example .env
   ```
3. **Run the application:**  
   ```bash
   composer run dev
   ```
   Access through `localhost:8000`

## 📋 Project Context

The project includes a minimal setup to help you focus on the exercise:

### Laravel Backend
- Configured to use **SQLite** (`database/database.sqlite` is committed) with dummy booking entries already included.  
- Core **Booking model** and functionality are already implemented.  
- The `getBookings` method in `MintyTestController` is exposed via `api.php` for fetching booking data.  

### Frontend (Vue + Pinia)
- `minty-test.js` Pinia store is provided and includes a method to fetch bookings from the API.  
- `Welcome.vue` serves as the main container for the frontend exercise and is already tied to the Pinia store. This is where you will implement the UI to display bookings and manage guest data.

## 🛠️ Instructions

| Task | Description | Status |
|------|------------|--------|
| **Implement new Guest data model** | Add a new `create_guests_table.php` migration (`php artisan make:migration create_guests_table`) and implement the relevant `Guest` model. Add relationships to link guests to bookings. | ⏳ Pending |
| **Display Bookings** | Using the Pinia store, display the bookings in a **grid layout**. Ensure all relevant fields are shown and use **Tailwind CSS** to style the booking cards. | ⏳ Pending |
| **Implement Guest Functionality** | Extend the application to allow complete management of guest data. Users should be able to **create, read, update, and delete** guest entries directly linked to individual bookings. | ⏳ Pending |
| **Guest Interface** | Implement the guest functionality so that it is accessible **within each booking card**. You are free to choose the approach and layout that provides the best UX for managing guests. | ⏳ Pending |
| **Extra Improvements (Optional)** | If you still have extra time, consider adding polishing features such as a dynamic search to filter bookings by guest name and pagination for the bookings list. Focus on improving user experience. | ⏳ Pending |

## 📝 Other

You can use `php artisan initialize-bookings` to generate new dummy entries in the booking tables if necessary. 

## 🍀 Good luck!

---

