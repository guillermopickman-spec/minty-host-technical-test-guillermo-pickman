<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Run our custom seeders to populate the database with test data
        $this->call([
            UserSeeder::class,
            BookingSeeder::class,
            GuestSeeder::class,
        ]);
    }
}
