<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Dispute extends Model
{
    use HasFactory;

    protected $fillable = [
        'moderator_id',
        'game_id',
        'disputer_id',
        'disputed_against_id',
        'cell_index',
        'status',
        'dispute_group_id'
    ];
}
