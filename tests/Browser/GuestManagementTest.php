<?php

namespace Tests\Browser;

use Tests\DuskTestCase;
use App\Models\Booking;
use App\Models\Guest;
use Laravel\Dusk\Browser;
use Illuminate\Foundation\Testing\DatabaseMigrations;

class GuestManagementTest extends DuskTestCase
{
    use DatabaseMigrations;

    /**
     * Test guest management workflow in browser.
     *
     * @return void
     */
    public function test_guest_management_workflow()
    {
        // Create test data
        $booking = Booking::factory()->create([
            'checkin_at' => now()->addDays(1),
            'checkout_at' => now()->addDays(3),
            'status' => 'confirmed',
        ]);

        $guest = Guest::factory()->create([
            'booking_id' => $booking->id,
            'name' => 'Existing Guest',
            'email' => 'existing@example.com',
        ]);

        $this->browse(function (Browser $browser) use ($booking, $guest) {
            $browser->visit('/')
                   ->assertSee('Minty Host')
                   ->assertSee('Guest Management System')
                   ->assertSee('Booking #' . $booking->id)
                   ->assertSee('Existing Guest')
                   ->assertSee('existing@example.com');

            // Test adding a new guest
            $browser->click('@add-guest-button')
                   ->assertSee('Add New Guest')
                   ->type('@guest-name-input', 'New Guest')
                   ->type('@guest-email-input', 'new@example.com')
                   ->type('@guest-phone-input', '+1234567890')
                   ->click('@save-guest-button')
                   ->waitForText('Guest created successfully')
                   ->assertSee('New Guest')
                   ->assertSee('new@example.com');

            // Test editing a guest
            $browser->click('@edit-guest-button')
                   ->assertSee('Edit Guest')
                   ->type('@guest-name-input', 'Updated Guest Name')
                   ->click('@save-guest-button')
                   ->waitForText('Guest updated successfully')
                   ->assertSee('Updated Guest Name');

            // Test deleting a guest
            $browser->click('@delete-guest-button')
                   ->acceptDialog()
                   ->waitForText('Guest deleted successfully')
                   ->assertDontSee('Updated Guest Name');
        });
    }

    /**
     * Test search functionality.
     *
     * @return void
     */
    public function test_search_functionality()
    {
        $booking1 = Booking::factory()->create();
        $booking2 = Booking::factory()->create();

        Guest::factory()->create([
            'booking_id' => $booking1->id,
            'name' => 'John Doe',
            'email' => 'john.doe@example.com',
        ]);

        Guest::factory()->create([
            'booking_id' => $booking2->id,
            'name' => 'Jane Smith',
            'email' => 'jane.smith@example.com',
        ]);

        $this->browse(function (Browser $browser) {
            $browser->visit('/')
                   ->assertSee('John Doe')
                   ->assertSee('Jane Smith');

            // Test search by name
            $browser->type('@search-input', 'John')
                   ->assertSee('John Doe')
                   ->assertDontSee('Jane Smith');

            // Test search by email
            $browser->clear('@search-input')
                   ->type('@search-input', 'jane.smith')
                   ->assertDontSee('John Doe')
                   ->assertSee('Jane Smith');

            // Test clearing search
            $browser->clear('@search-input')
                   ->assertSee('John Doe')
                   ->assertSee('Jane Smith');
        });
    }

    /**
     * Test responsive design.
     *
     * @return void
     */
    public function test_responsive_design()
    {
        $booking = Booking::factory()->create();
        Guest::factory()->create(['booking_id' => $booking->id]);

        $this->browse(function (Browser $browser) {
            // Test mobile view
            $browser->resize(375, 812) // iPhone X dimensions
                   ->visit('/')
                   ->assertSee('Minty Host')
                   ->assertResponsiveElementsVisible();

            // Test tablet view
            $browser->resize(768, 1024) // iPad dimensions
                   ->assertSee('Minty Host')
                   ->assertResponsiveElementsVisible();

            // Test desktop view
            $browser->resize(1200, 800)
                   ->assertSee('Minty Host')
                   ->assertResponsiveElementsVisible();
        });
    }

    /**
     * Test form validation in browser.
     *
     * @return void
     */
    public function test_form_validation()
    {
        $booking = Booking::factory()->create();

        $this->browse(function (Browser $browser) use ($booking) {
            $browser->visit('/')
                   ->click('@add-guest-button')
                   ->assertSee('Add New Guest');

            // Test empty name validation
            $browser->type('@guest-email-input', 'test@example.com')
                   ->click('@save-guest-button')
                   ->assertSee('Name is required');

            // Test invalid email validation
            $browser->type('@guest-name-input', 'Test Guest')
                   ->type('@guest-email-input', 'invalid-email')
                   ->click('@save-guest-button')
                   ->assertSee('Please enter a valid email address');

            // Test valid form submission
            $browser->type('@guest-email-input', 'valid@example.com')
                   ->click('@save-guest-button')
                   ->waitForText('Guest created successfully')
                   ->assertSee('Test Guest');
        });
    }
}
