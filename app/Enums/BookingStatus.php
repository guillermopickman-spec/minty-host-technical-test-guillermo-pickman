<?php

namespace App\Enums;

enum BookingStatus: string
{
    case PENDING = 'pending';
    case CONFIRMED = 'confirmed';
    case CANCELLED = 'cancelled';
    case CHECKED_IN = 'checked_in';
    case CHECKED_OUT = 'checked_out';
}
