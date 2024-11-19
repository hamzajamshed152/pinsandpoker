<?php

namespace App\Http\Controllers\Api;

use App\Constants\Status;
use App\Http\Controllers\Controller;
use App\Http\Requests\Dispute\CreateDisputeRequest;
use App\Http\Resources\DisputeResource;
use App\Models\{Dispute, Game};
use Illuminate\Http\Request;

class DisputeController extends Controller
{
    public function create(CreateDisputeRequest $request)
    {
        $game = Game::where('id', $request->game_id)->first();

        $dispute_group_id = 'group'.'_'. $game->user->player_id;

        $created_dispute = Dispute::create([
            'moderator_id'          => $game->user->player_id,
            'game_id'               => $request->game_id,
            'disputer_id'           => $request->disputer_id,
            'disputed_against_id'   => $request->disputed_against_id,
            'cell_index'            => $request->cell_index,
            'dispute_group_id'      => $dispute_group_id
        ]);

        $message = 'Dispute request successfully submitted.';
        return $this->successDataResponse(new DisputeResource($created_dispute), $message);
    }

    public function getDisputes()
    {
        $authUser = auth()->user();

        $dispute = Dispute::where('moderator_id', $authUser->player_id)
            ->orWhere('disputer_id', $authUser->player_id)
            ->orWhere('disputed_against_id', $authUser->player_id)
            ->get();

        if($dispute->isEmpty()) return $this->errorResponse('Disputes not found.', 404);

        return $this->successDataResponse(DisputeResource::collection($dispute), 'All Disputes Fetched.');
    }
}
