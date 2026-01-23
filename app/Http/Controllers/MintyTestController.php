<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\Guest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class MintyTestController extends Controller
{
    public function getBookings()
    {
        try {
            $bookings = Booking::with('guests')->select('id', 'checkin_at', 'checkout_at', 'status')->get();

            return response()->json($bookings);
        } catch (\Exception $e) {
            Log::error('Error fetching bookings: ' . $e->getMessage());
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function createGuest(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|max:255',
                'phone' => 'nullable|string|max:20',
                'booking_id' => 'required|exists:bookings,id',
            ]);

            $guest = Guest::create($validated);

            return response()->json([
                'message' => 'Guest created successfully',
                'guest' => $guest->load('booking')
            ], 201);
        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            Log::error('Error creating guest: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to create guest'], 500);
        }
    }

    public function updateGuest(Request $request, $id)
    {
        try {
            $guest = Guest::findOrFail($id);

            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|max:255',
                'phone' => 'nullable|string|max:20',
            ]);

            $guest->update($validated);

            return response()->json([
                'message' => 'Guest updated successfully',
                'guest' => $guest->load('booking')
            ]);
        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            Log::error('Error updating guest: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to update guest'], 500);
        }
    }

    public function deleteGuest($id)
    {
        try {
            $guest = Guest::findOrFail($id);
            $guest->delete();

            return response()->json([
                'message' => 'Guest deleted successfully'
            ]);
        } catch (\Exception $e) {
            Log::error('Error deleting guest: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to delete guest'], 500);
        }
    }
}
