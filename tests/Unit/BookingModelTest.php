<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\Booking;
use App\Models\Guest;
use Illuminate\Foundation\Testing\RefreshDatabase;

class BookingModelTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test booking model mass assignment.
     *
     * @return void
     */
    public function test_booking_model_mass_assignment()
    {
        $booking = Booking::create([
            'checkin_at' => now()->addDays(1),
            'checkout_at' => now()->addDays(3),
            'status' => 'confirmed',
        ]);

        $this->assertInstanceOf(Booking::class, $booking);
        $this->assertEquals('confirmed', $booking->status);
        $this->assertNotNull($booking->checkin_at);
        $this->assertNotNull($booking->checkout_at);
    }

    /**
     * Test booking has many guests relationship.
     *
     * @return void
     */
    public function test_booking_has_many_guests_relationship()
    {
        $booking = Booking::factory()->create();
        $guest1 = Guest::factory()->create(['booking_id' => $booking->id]);
        $guest2 = Guest::factory()->create(['booking_id' => $booking->id]);

        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Collection::class, $booking->guests);
        $this->assertCount(2, $booking->guests);
        $this->assertTrue($booking->guests->contains($guest1));
        $this->assertTrue($booking->guests->contains($guest2));
    }

    /**
     * Test booking status enum values.
     *
     * @return void
     */
    public function test_booking_status_enum_values()
    {
        $confirmedBooking = Booking::create([
            'checkin_at' => now()->addDays(1),
            'checkout_at' => now()->addDays(3),
            'status' => 'confirmed',
        ]);

        $cancelledBooking = Booking::create([
            'checkin_at' => now()->addDays(1),
            'checkout_at' => now()->addDays(3),
            'status' => 'cancelled',
        ]);

        $this->assertEquals('confirmed', $confirmedBooking->status);
        $this->assertEquals('cancelled', $cancelledBooking->status);

        // Test that only valid enum values are accepted
        $this->expectException(\Exception::class);
        Booking::create([
            'checkin_at' => now()->addDays(1),
            'checkout_at' => now()->addDays(3),
            'status' => 'invalid_status',
        ]);
    }

    /**
     * Test booking date casting.
     *
     * @return void
     */
    public function test_booking_date_casting()
    {
        $checkinDate = now()->addDays(1);
        $checkoutDate = now()->addDays(3);

        $booking = Booking::create([
            'checkin_at' => $checkinDate,
            'checkout_at' => $checkoutDate,
            'status' => 'confirmed',
        ]);

        $this->assertInstanceOf(\Carbon\CarbonImmutable::class, $booking->checkin_at);
        $this->assertInstanceOf(\Carbon\CarbonImmutable::class, $booking->checkout_at);
        $this->assertEquals($checkinDate->format('Y-m-d H:i:s'), $booking->checkin_at->format('Y-m-d H:i:s'));
        $this->assertEquals($checkoutDate->format('Y-m-d H:i:s'), $booking->checkout_at->format('Y-m-d H:i:s'));
    }
}
