<?php

namespace App\Http\Controllers\Api;

use App\Constants\{RoleType, Status};
use App\Http\Controllers\Controller;
use App\Http\Requests\Game\Score\UpdateRequest;
use App\Http\Resources\GameScoreResource;
use App\Http\Resources\RuleResource;
use App\Models\{Card, Game, GameScore, League, Rule, User};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ScoreController extends Controller
{
    public final function createOrUpdate(UpdateRequest $request)
    {
        $authUser = auth()->user();
    
        try {
            DB::beginTransaction();
        
            // Fetch user, validate authorization
            $user = User::where('player_id', $request->player_id)->first();
            if ($user->user_type !== RoleType::PLAYER)
            return $this->errorResponse('This player id is not authorized to make changes.', 403);
             // If the authenticated user is a PLAYER, ensure they're modifying their own data
            if ($authUser->user_type === RoleType::PLAYER && $request->player_id != $authUser->player_id)
            return $this->errorResponse('Unauthenticated.', 403);

            // Fetch the league and game, ensuring both exist
            $league = League::whereId($request->league_id)->first();
            if (empty($league)) return $this->errorResponse('League Not Found.', 404);

            $game = Game::whereId($request->game_id)->where('league_id', $request->league_id)->first();
            if (empty($game)) return $this->errorResponse('The requested game does not exist in the given league.', 404);

            // -------- Check eligibilities --------
            
            // Check eligibility based on user role (MODERATOR or PLAYER)
            $userEligibility = $this->checkUserEligibility($user, $league, $game);
            if ($userEligibility) return $userEligibility;

            // --------- Validating rolls ----------

            $rolls = json_decode($request->rolls, true);

            $rollValidation = $this->validateRolls($rolls);
            if ($rollValidation) return $rollValidation;

            // ------- Cell Score Logic Begins -------

            $cell_scores = [];
            $accumulated_score = 0; // previous cell scores sum

            for ($i = 0; $i < count($rolls) - 1; $i += 2) {
                $sum = $rolls[$i] + $rolls[$i + 1];  // Sum the current roll and the next roll
                $accumulated_score += $sum;          // Update accumulated score with the current sum
                $cell_scores[] = $accumulated_score; // Add the accumulated score to cell_scores
            }

            // ------- Assign Card Logic Begins -------

            $assigned_cards = []; // Array to keep track of assigned cards

            for ($i = 0; $i < count($rolls); $i += 2) {
                $roll_one = $rolls[$i];
                $roll_two = isset($rolls[$i + 1]) ? $rolls[$i + 1] : 0;

                $sum = $roll_one + $roll_two;

                /**
                 * Condition 1 : Strike Rule
                 * 
                 * If the rule strike (means score 10) is checked then Assign a card.
                 * 
                */

                if ($roll_one == 10 || $roll_two == 10) {
                    $assigned_cards[] = $this->assignCard($game->id, $user->id, $rolls);
                }

                /**
                 * Condition 2 : Spare Rule
                 * 
                 * If Spare (means the sum of 2 turns) is checked then Assign a card.
                 * Assign card if the sum is 10, but not for the pair [0, 10] or [10, 0]
                */
                
                if ($sum == 10 && ($roll_one != 0 || $roll_two != 10) && ($roll_one != 10 || $roll_two != 0)) {
                    $assigned_cards[] = $this->assignCard($game->id, $user->id, $rolls);
                }

                /**
                 * Condition 3 : Card Management
                 * 
                 * If Spare (means the sum of 2 turns) is checked then Assign a card.
                 * 
                */
                
                /**
                 * Condition 4 : Joker (Wild Card)
                 * 
                 * If Spare (means the sum of 2 turns) is checked then Assign a card.
                 * 
                */
                
                /**
                 * Condition 5 : Split Rule
                 * 
                 * If Spare (means the sum of 2 turns) is checked then Assign a card.
                 * 
                */
            }

            // return [
            //     "rolls" => $request->rolls,
            //     "cell_scores" => json_encode($cell_scores),
            //     "cards" => json_encode($assigned_cards)
            // ];

            // ------- Creating Game Score -------
            
            // Exchange Cards
            $exchange_cards = (count($assigned_cards) > 5) ? 1 : 0;

            GameScore::updateOrCreate([
                'game_id' => $game->id,
                'user_id' => $user->id,
            ], [
                'rolls'       => $request->rolls,              // Convert array to JSON
                'cell_scores' => json_encode($cell_scores),    // Convert array to JSON
                'cards'       => json_encode($assigned_cards), // Convert array to JSON
                'exchange_cards' => $exchange_cards
            ]);

            $finalScore = GameScore::where('game_id', $game->id)->get();
            if (empty($finalScore) || $finalScore->isEmpty()) return $this->errorResponse('Game Score Not Found.', 404);

            $data = [
                'status' => $game->status,
                'score'  => GameScoreResource::collection($finalScore)
            ];

            $message = "Game Score Updated Successfully.";
            DB::commit();
            return $this->successDataResponse($data, $message);

        } catch (\Exception $e) {
            DB::rollBack();
            return $this->errorResponse("Error: {$e->getMessage()}", 500);
            // return $this->errorResponse('Oops! Something went wrong. Please try again later.', 500);
        }
    }

    private final function checkUserEligibility($user, $league, $game)
    {
        if ($user->user_type === RoleType::MODERATOR) {
            // Moderator checks: They must manage their own leagues and games
            if ($league->user_id !== $user->id)
            return $this->errorResponse('You are not authorized to manage this league.', 403);

            if ($game->user_id !== $user->id)
            return $this->errorResponse('You are not authorized to manage this league game.', 403);

        } else {
            // Player checks: They must be a member of the league and game
            $hasJoinedLeague = $league->league_requests()->where('user_id', $user->id)->where('status', Status::ACCEPTED)->exists();
            $hasJoinedGame = $game->game_requests()->where('user_id', $user->id)->where('status', Status::ACCEPTED)->exists();
            
            if (empty($hasJoinedLeague))
            return $this->errorResponse("You're not a participant in this league or your request has not been accepted.");

            if (empty($hasJoinedGame))
            return $this->errorResponse("You're not a participant in this league game or your request has not been accepted.");
        }

        return null; // Return null if eligibility is valid
    }

    private final function validateRolls($rolls)
    {
        // Check if the decoded data is an array
        if (!is_array($rolls))
        return $this->errorResponse('Invalid rolls format. Please provide an array.', 422);
        
        // Check if the array is empty
        if (empty(($rolls)))
        return $this->errorResponse('The provided array is empty. Please provide valid data.', 422);
        
        // Check the array has not greater than 20 values
        if (count($rolls) > 20)
        return $this->errorResponse('The array must contain 20 values or less.', 422);
        
        // Check if the array value is integer
        foreach ($rolls as $roll) {
            if (!is_int($roll))
            return $this->errorResponse("The roll value '{$roll}' must be an integer.", 422);
            
            if ($roll < 0 || $roll > 10)
            return $this->errorResponse("The roll value '{$roll}' must be between 0 and 10.", 422);
        }

        return null; // return null if validated
    }

    public final function get_game_scores(Request $request)
    {
        $this->validate($request, [
            'league_id' => 'required|numeric|digits_between:1,20|exists:leagues,id',
            'game_id'   => 'required|numeric|digits_between:1,20|exists:games,id'
        ], [
            'league_id.exists' => 'The league id does not exist in our records.',
            'game_id.exists'   => 'The game id does not exist in our records.'
        ]);

        $authUser = auth()->user();

        try {
            $league = League::whereId($request->league_id)->first();
            if (empty($league)) return $this->errorResponse('League Not Found.', 404);

            $game = Game::whereId($request->game_id)->where('league_id', $request->league_id)->first();
            if (empty($game)) return $this->errorResponse('The requested game does not exist in the given league.', 404);

            // Check eligibility based on user role (MODERATOR or PLAYER)
            $userEligibility = $this->checkUserEligibility($authUser, $league, $game);
            if ($userEligibility) return $userEligibility;

            $score = GameScore::where('game_id', $game->id)->get();
            if (empty($score) || $score->isEmpty()) { 
                return $this->errorResponse('Game Score Not Found.', 404);
            }
            
            $data = [
                'status' => $game->status,
                'score'  => GameScoreResource::collection($score)
            ];

            $message = "Game Score Fetched Successfully.";
            return $this->successDataResponse($data, $message);

            // $message = "Game Score Fetched Successfully.";
            // return $this->successDataResponse(GameScoreResource::collection($score), $message);

        } catch (\Exception $e) {
            return $this->errorResponse('Oops! Something went wrong. Please try again later.', 500);
        }
    }

    private final function assignCard($game_id, $user_id)
    {
        // Get the user's score record
        $score = GameScore::where('game_id', $game_id)->where('user_id', $user_id)->first();

        // Get available cards (excluding those already assigned)
        $availableCards = Card::whereNotIn('id', json_decode($score->cards))->get();
        
        // If there are available cards to assign, pick a random one
        if ($availableCards->isNotEmpty()) {
            $randomCard = $availableCards->random();  // Pick a random card

            return $randomCard->id; // Return the assigned card
        }

        return null;
    }
}