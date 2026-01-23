<?php

use App\Http\Controllers\MintyTestController;
use Illuminate\Support\Facades\Route;

Route::get('/bookings', [MintyTestController::class, 'getBookings']);
Route::post('/guests', [MintyTestController::class, 'createGuest']);
Route::put('/guests/{id}', [MintyTestController::class, 'updateGuest']);
Route::delete('/guests/{id}', [MintyTestController::class, 'deleteGuest']);
