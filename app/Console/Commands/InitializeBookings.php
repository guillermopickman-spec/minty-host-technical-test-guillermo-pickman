<?php

namespace App\Console\Commands;

use App\Models\Booking;
use Illuminate\Console\Command;

class InitializeBookings extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'initialize-bookings';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Delete all existing bookings and create 50 random ones for testing';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Deleting all existing bookings...');

        $deletedCount = Booking::count();
        Booking::truncate();

        $this->info("Deleted {$deletedCount} booking(s).");
        $this->newLine();

        $this->info('Creating 50 random bookings...');

        $statuses = ['confirmed', 'cancelled'];

        for ($i = 0; $i < 50; $i++) {
            $checkinDaysFromNow = rand(-30, 90);  // Between 30 days ago and 90 days in the future
            $checkinAt = now()->addDays($checkinDaysFromNow);

            $stayDuration = rand(1, 14);  // Stay between 1 and 14 days
            $checkoutAt = $checkinAt->copy()->addDays($stayDuration);

            Booking::create([
                'checkin_at' => $checkinAt,
                'checkout_at' => $checkoutAt,
                'status' => $statuses[array_rand($statuses)],
            ]);
        }

        $this->info('Successfully created 50 random bookings!');
        $this->newLine();

        $confirmedCount = Booking::where('status', 'confirmed')->count();
        $cancelledCount = Booking::where('status', 'cancelled')->count();

        $this->table(
            ['Status', 'Count'],
            [
                ['Confirmed', $confirmedCount],
                ['Cancelled', $cancelledCount],
            ]
        );

        return Command::SUCCESS;
    }
}
