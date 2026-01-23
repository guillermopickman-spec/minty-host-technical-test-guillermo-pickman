<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\Booking;
use App\Models\Guest;
use Illuminate\Foundation\Testing\RefreshDatabase;

class GuestModelTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test guest model mass assignment.
     *
     * @return void
     */
    public function test_guest_model_mass_assignment()
    {
        $booking = Booking::factory()->create();

        $guest = Guest::create([
            'name' => 'Test Guest',
            'email' => 'test@example.com',
            'phone' => '+1234567890',
            'booking_id' => $booking->id,
        ]);

        $this->assertInstanceOf(Guest::class, $guest);
        $this->assertEquals('Test Guest', $guest->name);
        $this->assertEquals('test@example.com', $guest->email);
        $this->assertEquals('+1234567890', $guest->phone);
        $this->assertEquals($booking->id, $guest->booking_id);
    }

    /**
     * Test guest belongs to booking relationship.
     *
     * @return void
     */
    public function test_guest_belongs_to_booking_relationship()
    {
        $booking = Booking::factory()->create();
        $guest = Guest::factory()->create([
            'booking_id' => $booking->id,
        ]);

        $this->assertInstanceOf(Booking::class, $guest->booking);
        $this->assertEquals($booking->id, $guest->booking->id);
    }

    /**
     * Test guest validation rules.
     *
     * @return void
     */
    public function test_guest_validation_rules()
    {
        // Test required fields
        $validator = \Illuminate\Support\Facades\Validator::make([
            'name' => '',
            'email' => 'test@example.com',
            'booking_id' => 1,
        ], Guest::rules());

        $this->assertTrue($validator->fails());
        $this->assertArrayHasKey('name', $validator->errors()->messages());

        $validator = \Illuminate\Support\Facades\Validator::make([
            'name' => 'Test Guest',
            'email' => '',
            'booking_id' => 1,
        ], Guest::rules());

        $this->assertTrue($validator->fails());
        $this->assertArrayHasKey('email', $validator->errors()->messages());

        // Test email format
        $validator = \Illuminate\Support\Facades\Validator::make([
            'name' => 'Test Guest',
            'email' => 'invalid-email',
            'booking_id' => 1,
        ], Guest::rules());

        $this->assertTrue($validator->fails());
        $this->assertArrayHasKey('email', $validator->errors()->messages());

        // Test valid data
        $booking = Booking::factory()->create();
        $validator = \Illuminate\Support\Facades\Validator::make([
            'name' => 'Test Guest',
            'email' => 'test@example.com',
            'booking_id' => $booking->id,
        ], Guest::rules());

        $this->assertFalse($validator->fails());
    }

    /**
     * Test guest phone field is optional.
     *
     * @return void
     */
    public function test_guest_phone_field_is_optional()
    {
        $booking = Booking::factory()->create();

        $guest = Guest::create([
            'name' => 'Test Guest',
            'email' => 'test@example.com',
            'booking_id' => $booking->id,
            // phone is intentionally omitted
        ]);

        $this->assertNull($guest->phone);
        $this->assertDatabaseHas('guests', [
            'name' => 'Test Guest',
            'email' => 'test@example.com',
            'booking_id' => $booking->id,
            'phone' => null,
        ]);
    }
}
