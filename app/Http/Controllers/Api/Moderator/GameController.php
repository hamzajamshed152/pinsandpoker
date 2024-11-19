<?php

namespace App\Http\Controllers\Api\Moderator;

use App\Constants\Status;
use App\Http\Controllers\Controller;
use App\Http\Requests\Game\{CreateRequest, UpdateRequest};
use App\Models\{Game, League, User};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GameController extends Controller
{
    public final function create(CreateRequest $request)
    {
        $authUser = auth()->user();
        
        try {
            DB::beginTransaction();
            $league = League::whereId($request->league_id)->first();
            if (empty($league)) {
                return $this->errorResponse('League not found.', 404);
            }

            if ($league->user_id !== $authUser->id) {
                return $this->errorResponse('You are not authorized to manage this league.', 403);
            }

            $game = Game::create([
                'user_id'    => $authUser->id,
                'league_id'  => $league->id,
                'name'       => $request->name,
                'lane'       => $request->lane,
                'start_time' => $request->start_time
            ]);

            $data = ['id' => $game->id];

            DB::commit();
            return $this->successDataResponse($data, 'The game has been successfully created.');
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->errorResponse('Oops! Something went wrong. Please try again later.', 500);
        }
    }

    public final function update(UpdateRequest $request)
    {
        $authUser = auth()->user();
        
        try {
            DB::beginTransaction();
            
            $game = Game::whereId($request->game_id)
            ->where('league_id', $request->league_id)
            ->first();

            if (empty($game)) {
                return $this->errorResponse('Game not Found', 404);
            }

            if ($game->user_id !== $authUser->id) {
                return $this->errorResponse('You are not authorized to manage this league game.', 403);
            }

            $game->update([
                'name' => $request->name,
                'lane' => $request->lane
            ]);

            DB::commit();
            return $this->successResponse('The game has been successfully updated.');
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->errorResponse('Oops! Something went wrong. Please try again later.', 500);
        }
    }

    public final function get_games_data(Request $request)
    {
        $this->validate($request, [
            'league_id' => 'required|numeric|digits_between:1,20|exists:leagues,id'
        ], [
            'league_id.exists' => 'The league id does not exist in our records.'
        ]);

        $authUser = auth()->user();

        try {
            $games = Game::where('user_id', $authUser->id)
            ->where('league_id', $request->league_id)
            ->get()
            ->map(function ($game) {
                return [
                    'id'            => $game->id,
                    'player_id'     => $game->user->player_id,
                    'name'          => $game->name,
                    'lane'          => $game->lane,
                    'start_time'    => $game->start_time,
                    'participants'  => $game->participants,
                    'created_at'    => format_date($game->created_at)
                ];
            })
            ->toArray();
            
            if (empty($games)) {
                return $this->errorResponse('Game not found', 404);
            }

            return $this->successDataResponse($games, 'Your games have been successfully fetched.');
        } catch (\Exception $e) {
            return $this->errorResponse('Oops! Something went wrong. Please try again later.', 500);
        }
    }

    public final function get_game_requests(Request $request)
    {
        $this->validate($request, [
            'league_id' => 'required|numeric|digits_between:1,20|exists:leagues,id',
            'game_id'   => 'required|numeric|digits_between:1,20|exists:games,id'
        ], [
            'league_id.exists' => 'The league id does not exist in our records.',
            'game_id.exists' => 'The game id does not exist in our records.'
        ]);

        $authUser = auth()->user();

        try {
            $league = League::whereId($request->league_id)->where('user_id', $authUser->id)->first();
            if (empty($league)) {
                return $this->errorResponse('You are not authorized to manage this league.', 403);
            }

            $games = $league->games()->whereId($request->game_id)->where('league_id', $request->league_id)->first();
            if (empty($games)) {
                return $this->errorResponse('The game not found in the league.', 404);
            }

            if ($games->user_id !== $authUser->id) {
                return $this->errorResponse('You are not authorized to manage this league games.', 403);
            }

            $request = $games->pending_game_requests->map(function ($request) {
                return [
                    'status'        => $request->status,
                    'assigned_lane' => $request->assigned_lane,
                    'created_at'    => format_date($request->created_at),
                    'user'          => [
                        'player_id' => $request->user->player_id,
                        'username'  => $request->user->username,
                        'image'     => $request->user->avatar_image,
                    ]
                ];
            })->toArray();
            
            if (empty($request)) {
                return $this->errorResponse('Game Requests not found', 404);
            }

            return $this->successDataResponse($request, 'Your game requests have been successfully fetched.');
        } catch (\Exception $e) {
            return $this->errorResponse('Oops! Something went wrong. Please try again later.', 500);
        }
    }

    public final function manage_requests(Request $request)
    {
        $this->validate($request, [ 
            'league_id'     => 'required|numeric|digits_between:1,20|exists:leagues,id',
            'game_id'       => 'required|numeric|digits_between:1,20|exists:games,id',
            'player_id'     => 'required|numeric|digits_between:10,12|exists:users,player_id',
            'assigned_lane' => 'required|numeric|digits_between:1,20',
            'status'        => 'required|in:accepted,declined'
        ], [
            'league_id.exists' => 'The league id does not exist in our records.',
            'game_id.exists'   => 'The game id does not exist in our records.',
            'player_id.exists' => 'The player id does not exist in our records.'
        ]);

        $authUser = auth()->user();

        try {
            DB::beginTransaction();

            // If Player Not Joined in the League.
            $league = League::whereId($request->league_id)->first();
            if (empty($league)) { return $this->errorResponse('League Not Found.', 404); }
            
            if ($league->user_id !== $authUser->id) {
                return $this->errorResponse('You are not authorized to manage this league.', 403);
            }

            $user = User::where('player_id', $request->player_id)->first();
            if (empty($user)) { return $this->errorResponse('Player not found', 404); }
            
            $isParticipant = $league->whereHas('league_requests', function ($q) use ($user) {
                $q->where('user_id', $user->id)->where('status', Status::ACCEPTED);
            })->first();
            
            if (empty($isParticipant)) {
                return $this->errorResponse("You are not a participant in this league.", 403);
            }
            
            $game = Game::whereId($request->game_id)->where('league_id', $request->league_id)->first();
            if (empty($game)) {
                return $this->errorResponse("The requested game does not exist in the given league.", 404);
            }

            if ($game->user_id !== $authUser->id) {
                return $this->errorResponse('You are not authorized to manage this league.', 403);
            }

            $game_request = $game->game_requests()->where('user_id', $user->id)->first();
            if (empty($game_request)) {
                return $this->errorResponse('Game request not found', 404);
            }

            if ($game_request->status == Status::ACCEPTED) {
                return $this->errorResponse('The league game request has already been accepted.', 409);
            }

            if ($request->status === Status::ACCEPTED) {
                $game_request->update(['assigned_lane' => $request->assigned_lane, 'status' => Status::ACCEPTED]);
                $game->increment('participants');
                $message = "You've accepted the league game request.";
            } else {
                $game_request->delete();
                $message = "You've rejected the league game request.";
            }

            DB::commit();
            return $this->successResponse($message);
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->errorResponse('Oops! Something went wrong. Please try again later.', 500);
        }
    }

    public final function manage_game_status(Request $request)
    {
        $this->validate($request, [
            'game_id' => 'required|numeric|digits_between:1,20|exists:games,id',
            'status'  => 'required|in:started,ended'
        ], [
            'game_id.exists' => 'The game id does not exist in our records.'
        ]);
        
        $authUser = auth()->user();

        $game = Game::whereId($request->game_id)->first();
        if ($game->user_id != $authUser->id) return $this->errorResponse('Unauthorized.', 403);

        if ($request->status === Status::GAME_STARTED) {
            if ($game->status === Status::GAME_ENDED) return $this->errorResponse('This game has already ended and cannot be restarted.');
            if ($game->status === Status::GAME_STARTED) return $this->errorResponse('This game has already been started.');
            
            $game->status = $request->status;
            $game->save();

            $message = 'The game has been started.';
        } else {
            if ($game->status === Status::GAME_ENDED) return $this->errorResponse('The game has already been ended.');
            
            $game->status = $request->status;
            $game->save();

            $message = 'The game has been ended.';
        }

        $data = ['status' => $game->status];

        return $this->successDataResponse($data, $message);
    }
}