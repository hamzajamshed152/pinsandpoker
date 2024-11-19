<?php

namespace App\Http\Controllers\Api\Moderator;

use App\Constants\Status;
use App\Http\Controllers\Controller;
use App\Http\Resources\DisputeResource;
use App\Models\Dispute;
use Illuminate\Http\Request;

class DisputeController extends Controller
{
    public function changeStatus(Request $request)
    {
        $this->validate($request,[
            'game_id' => 'required|numeric|digits_between:1,20|exists:games,id',
            'status'  => 'required|in:resolved'
        ], [
            'game_id.exists' => 'The game id does not exist in our records.'
        ]);

        $authUser = auth()->user();

        $dispute = Dispute::where('moderator_id', $authUser->player_id)
        ->where('game_id', $request->game_id)
        ->first();

        if ($dispute->moderator_id !== $authUser->player_id)
        return $this->errorResponse('Unauthorized.', 403);

    
        if(empty($dispute)) return $this->errorResponse('Dispute Not Found.', 404);

        if($dispute->status === Status::RESOLVED) return $this->errorResponse('This dispute has already been resolved.');

        $dispute->status = $request->status;
        $dispute->save();

        return $this->successDataResponse(new DisputeResource($dispute), 'Status Changed Successfully.');
    }
}
