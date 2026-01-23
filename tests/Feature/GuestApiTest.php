<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\Booking;
use App\Models\Guest;
use Illuminate\Foundation\Testing\RefreshDatabase;

class GuestApiTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test creating a guest with valid data.
     *
     * @return void
     */
    public function test_create_guest_with_valid_data()
    {
        // Create a booking for testing
        $booking = Booking::factory()->create();

        $guestData = [
            'name' => 'John Doe',
            'email' => 'john.doe@example.com',
            'phone' => '+1234567890',
            'booking_id' => $booking->id,
        ];

        $response = $this->postJson('/api/guests', $guestData);

        $response->assertStatus(201)
                 ->assertJson([
                     'message' => 'Guest created successfully',
                     'guest' => [
                         'name' => 'John Doe',
                         'email' => 'john.doe@example.com',
                         'phone' => '+1234567890',
                         'booking_id' => $booking->id,
                     ]
                 ]);

        // Verify guest was created in database
        $this->assertDatabaseHas('guests', [
            'name' => 'John Doe',
            'email' => 'john.doe@example.com',
            'phone' => '+1234567890',
            'booking_id' => $booking->id,
        ]);
    }

    /**
     * Test creating a guest with invalid data.
     *
     * @return void
     */
    public function test_create_guest_with_invalid_data()
    {
        $booking = Booking::factory()->create();

        // Test missing required fields
        $response = $this->postJson('/api/guests', [
            'booking_id' => $booking->id,
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['name', 'email']);

        // Test invalid email format
        $response = $this->postJson('/api/guests', [
            'name' => 'John Doe',
            'email' => 'invalid-email',
            'booking_id' => $booking->id,
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['email']);

        // Test non-existent booking
        $response = $this->postJson('/api/guests', [
            'name' => 'John Doe',
            'email' => 'john.doe@example.com',
            'booking_id' => 99999,
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['booking_id']);
    }

    /**
     * Test updating an existing guest.
     *
     * @return void
     */
    public function test_update_guest()
    {
        $booking = Booking::factory()->create();
        $guest = Guest::factory()->create([
            'booking_id' => $booking->id,
            'name' => 'Original Name',
            'email' => 'original@example.com',
        ]);

        $updateData = [
            'name' => 'Updated Name',
            'email' => 'updated@example.com',
            'phone' => '+0987654321',
        ];

        $response = $this->putJson("/api/guests/{$guest->id}", $updateData);

        $response->assertStatus(200)
                 ->assertJson([
                     'message' => 'Guest updated successfully',
                     'guest' => [
                         'name' => 'Updated Name',
                         'email' => 'updated@example.com',
                         'phone' => '+0987654321',
                     ]
                 ]);

        // Verify guest was updated in database
        $this->assertDatabaseHas('guests', [
            'id' => $guest->id,
            'name' => 'Updated Name',
            'email' => 'updated@example.com',
            'phone' => '+0987654321',
        ]);
    }

    /**
     * Test deleting a guest.
     *
     * @return void
     */
    public function test_delete_guest()
    {
        $booking = Booking::factory()->create();
        $guest = Guest::factory()->create([
            'booking_id' => $booking->id,
        ]);

        $response = $this->deleteJson("/api/guests/{$guest->id}");

        $response->assertStatus(200)
                 ->assertJson([
                     'message' => 'Guest deleted successfully',
                 ]);

        // Verify guest was deleted from database
        $this->assertDatabaseMissing('guests', [
            'id' => $guest->id,
        ]);
    }

    /**
     * Test getting bookings with guest data.
     *
     * @return void
     */
    public function test_get_bookings_with_guests()
    {
        $booking1 = Booking::factory()->create();
        $booking2 = Booking::factory()->create();

        $guest1 = Guest::factory()->create([
            'booking_id' => $booking1->id,
            'name' => 'Guest 1',
            'email' => 'guest1@example.com',
        ]);

        $guest2 = Guest::factory()->create([
            'booking_id' => $booking1->id,
            'name' => 'Guest 2',
            'email' => 'guest2@example.com',
        ]);

        // Booking 2 has no guests

        $response = $this->getJson('/api/bookings');

        $response->assertStatus(200)
                 ->assertJsonCount(2) // Should return 2 bookings
                 ->assertJsonFragment([
                     'id' => $booking1->id,
                 ])
                 ->assertJsonFragment([
                     'id' => $booking2->id,
                 ]);

        // Check that booking1 has guests
        $responseData = $response->json();
        $booking1Data = collect($responseData)->firstWhere('id', $booking1->id);
        $this->assertCount(2, $booking1Data['guests']);

        // Check that booking2 has no guests
        $booking2Data = collect($responseData)->firstWhere('id', $booking2->id);
        $this->assertCount(0, $booking2Data['guests']);
    }
}
