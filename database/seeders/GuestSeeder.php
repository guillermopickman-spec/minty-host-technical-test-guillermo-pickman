<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Guest;

class GuestSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $guests = [
            ['John Doe', 'john.doe@example.com', '+1-555-0123', '123 Main St, Anytown, USA'],
            ['Jane Smith', 'jane.smith@example.com', '+1-555-0124', '456 Oak Ave, Somewhere, USA'],
            ['Bob Johnson', 'bob.johnson@example.com', '+1-555-0125', '789 Pine Rd, Nowhere, USA'],
            ['Alice Brown', 'alice.brown@example.com', '+1-555-0126', '321 Elm St, Anytown, USA'],
            ['Charlie Wilson', 'charlie.wilson@example.com', '+1-555-0127', '654 Maple Dr, Somewhere, USA'],
            ['Diana Davis', 'diana.davis@example.com', '+1-555-0128', '987 Cedar Ln, Nowhere, USA'],
            ['Eve Miller', 'eve.miller@example.com', '+1-555-0129', '147 Birch St, Anytown, USA'],
            ['Frank Moore', 'frank.moore@example.com', '+1-555-0130', '258 Spruce Ave, Somewhere, USA'],
            ['Grace Taylor', 'grace.taylor@example.com', '+1-555-0131', '369 Willow Rd, Nowhere, USA'],
            ['Henry Anderson', 'henry.anderson@example.com', '+1-555-0132', '741 Ash St, Anytown, USA'],
        ];

        // Get all booking IDs to associate guests with bookings
        $bookingIds = \App\Models\Booking::pluck('id')->toArray();
        
        foreach ($guests as $index => $guestData) {
            Guest::create([
                'name' => $guestData[0],
                'email' => $guestData[1],
                'phone' => $guestData[2],
                'booking_id' => $bookingIds[$index % count($bookingIds)], // Cycle through bookings
                'created_at' => '2026-01-21 23:28:51',
                'updated_at' => '2026-01-21 23:28:51',
            ]);
        }
    }
}
