<?php

namespace App\Constants;

class Status {
    const NOT_SOCIAL = '0';
    const SOCIAL = '1';
    
    const NOT_DELETED = '0';
    const DELETED = '1';

    const BLOCKED = '1';
    const NOT_BLOCKED = '0';

    // LEAGUE REQUEST STATUS
    const PENDING = 'pending';
    const ACCEPTED = 'accepted';

    // GAME STATUS
    const PENDING_GAME = 'pending';
    const GAME_STARTED = 'started';
    const GAME_ENDED = 'ended';

    // DISPUTE STATUS
    const PENDING_DISPUTE = 'pending';
    const RESOLVED = 'resolved';
}