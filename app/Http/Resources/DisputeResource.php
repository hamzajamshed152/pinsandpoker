<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class DisputeResource extends JsonResource
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
            'moderator_id'        => $this->moderator_id,
            'game_id'             => $this->game_id,
            'disputer_id'         => $this->disputer_id,
            'disputed_against_id' => $this->disputed_against_id,
            'cell_index'          => $this->cell_index,
            'status'              => $this->status,
            'created_at'          => format_date($this->created_at)
        ];
    }
}
