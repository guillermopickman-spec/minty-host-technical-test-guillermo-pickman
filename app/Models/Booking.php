<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use App\Enums\BookingStatus;

class Booking extends Model
{
    use HasFactory;
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'checkin_at',
        'checkout_at',
        'status',
    ];

    /**
     * Get the guests for the booking.
     */
    public function guests()
    {
        return $this->hasMany(Guest::class);
    }

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'checkin_at' => 'immutable_datetime',
            'checkout_at' => 'immutable_datetime',
        ];
    }
}
