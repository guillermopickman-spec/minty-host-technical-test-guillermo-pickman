<?php

test('returns a successful response', function () {
    $response = $this->getJson('/api/bookings');

    $response->assertStatus(200);
});
