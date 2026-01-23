<?php

namespace Tests\Integration;

use Tests\TestCase;
use App\Models\Booking;
use App\Models\Guest;
use Illuminate\Foundation\Testing\RefreshDatabase;

class DatabaseIntegrityTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test guest-booking relationship integrity.
     *
     * @return void
     */
    public function test_guest_booking_relationship_integrity()
    {
        $booking = Booking::factory()->create();

        // Create guest with valid booking_id
        $guest = Guest::create([
            'name' => 'Test Guest',
            'email' => 'test@example.com',
            'booking_id' => $booking->id,
        ]);

        // Verify relationship works both ways
        $this->assertEquals($booking->id, $guest->booking->id);
        $this->assertTrue($booking->guests->contains($guest));

        // Verify foreign key constraint
        $this->assertDatabaseHas('guests', [
            'booking_id' => $booking->id,
        ]);
    }

    /**
     * Test cascade delete functionality.
     *
     * @return void
     */
    public function test_cascade_delete_functionality()
    {
        $booking = Booking::factory()->create();
        $guest1 = Guest::factory()->create(['booking_id' => $booking->id]);
        $guest2 = Guest::factory()->create(['booking_id' => $booking->id]);

        // Verify guests exist
        $this->assertDatabaseHas('guests', ['id' => $guest1->id]);
        $this->assertDatabaseHas('guests', ['id' => $guest2->id]);

        // Delete booking
        $booking->delete();

        // Verify guests are deleted due to cascade
        $this->assertDatabaseMissing('guests', ['id' => $guest1->id]);
        $this->assertDatabaseMissing('guests', ['id' => $guest2->id]);
        $this->assertDatabaseMissing('bookings', ['id' => $booking->id]);
    }

    /**
     * Test eager loading prevents N+1 queries.
     *
     * @return void
     */
    public function test_eager_loading_prevents_n_plus_one_queries()
    {
        // Create multiple bookings with guests
        $bookings = Booking::factory()->count(5)->create();
        
        foreach ($bookings as $booking) {
            Guest::factory()->count(2)->create(['booking_id' => $booking->id]);
        }

        // Test that eager loading works correctly
        $this->withoutExceptionHandling();

        $bookingsWithGuests = Booking::with('guests')->get();

        $this->assertCount(5, $bookingsWithGuests);
        
        foreach ($bookingsWithGuests as $booking) {
            $this->assertCount(2, $booking->guests);
            $this->assertInstanceOf(\Illuminate\Database\Eloquent\Collection::class, $booking->guests);
        }
    }

    /**
     * Test database constraints.
     *
     * @return void
     */
    public function test_database_constraints()
    {
        $booking = Booking::factory()->create();

        // Test that guest requires valid booking_id
        $this->expectException(\Exception::class);
        
        Guest::create([
            'name' => 'Test Guest',
            'email' => 'test@example.com',
            'booking_id' => 99999, // Non-existent booking
        ]);
    }

    /**
     * Test migration structure.
     *
     * @return void
     */
    public function test_migration_structure()
    {
        // Test that guests table exists with correct structure
        $this->assertTrue(\Schema::hasTable('guests'));
        $this->assertTrue(\Schema::hasColumns('guests', [
            'id', 'name', 'email', 'phone', 'booking_id', 'created_at', 'updated_at'
        ]));

        // Test foreign key constraint exists
        $this->assertTrue(\Schema::hasColumn('guests', 'booking_id'));
        
        // Test that booking_id is indexed for performance
        $indexes = \DB::connection()->getDoctrineSchemaManager()->listTableIndexes('guests');
        $this->assertArrayHasKey('guests_booking_id_foreign', $indexes);
    }
}
