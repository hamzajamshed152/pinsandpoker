<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class GameScoreResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'player_id'   => $this->user->player_id,
            'username'    => $this->user->username,
            'rolls'       => json_decode($this->rolls),
            'cell_scores' => json_decode($this->cell_scores),
            'cards'       => json_decode($this->cards),
            'exchange_cards' => ($this->exchange_cards === '1') ? true : false
        ];
    }
}
