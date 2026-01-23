<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\Booking;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Booking>
 */
class BookingFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $checkinDate = now()->addDays(rand(1, 30));
        $checkoutDate = $checkinDate->copy()->addDays(rand(1, 7));

        return [
            'checkin_at' => $checkinDate,
            'checkout_at' => $checkoutDate,
            'status' => $this->faker->randomElement(['confirmed', 'cancelled']),
        ];
    }
}
