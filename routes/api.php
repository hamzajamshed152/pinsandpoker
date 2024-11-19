<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::prefix('v1')->group(function () {
    Route::get('check', function () { return 'ACCESS GRANTED'; }); // Testing API

    Route::controller('AuthController')->prefix('auth')->group(function () {    
        Route::post('login', 'login');

        Route::prefix('moderator')->group(function () {
            Route::post('login', 'moderatorLogin');
        });

        Route::middleware('auth:sanctum')->group(function () {
            Route::controller('ProfileController')->prefix('profile')->group(function () {
                Route::post('update', 'update');
            });
            
            Route::post('connect', 'connectWithSocial');
            Route::post('logout', 'logout');
        });
    });
    
    // AUTHENTICATED API'S
    Route::middleware('auth:sanctum')->group(function () {
        Route::controller('ProfileController')->prefix('profile')->group(function () {
            Route::delete('delete-account', 'delete');
        });

        // FOR BOTH MOD AND USER
        Route::prefix('game')->group(function () {
            Route::controller('ParticipantController')->prefix('participants')->group(function () {
                Route::get('/', 'get_game_participants');
            });

            Route::controller('ScoreController')->prefix('score')->group(function () {
                Route::get('/', 'get_game_scores');
                Route::post('update', 'createOrUpdate');
            });
        });

        Route::controller('DisputeController')->prefix('dispute')->group( function() {
            Route::get('/', 'getDisputes');
            Route::post('create', 'create');
        });

        // USERS ROUTES
        Route::namespace('User')->middleware('role:user')->prefix('user')->group(function () {
            Route::controller('SearchController')->prefix('search')->group(function () {
                Route::get('/', 'leagues_and_games');
            });

            Route::controller('LeagueController')->prefix('league')->group(function () {
                Route::get('/', 'user_leagues');
                Route::get('all', 'get_all_leagues');
                Route::post('join', 'join');
                Route::post('cancel', 'cancel');
            });

            Route::controller('GameController')->prefix('game')->group(function () {
                Route::get('/', 'get_league_games');
                Route::post('join', 'join');
                Route::post('cancel', 'cancel');
            });
        });

        // MODERATOR ROUTES
        Route::namespace('Moderator')->middleware('role:moderator')->prefix('moderator')->group(function () {
            
            Route::controller('LeagueController')->group(function () {
                Route::get('rules', 'get_rules');
            });

            Route::controller('LeagueController')->prefix('league')->group(function () {
                Route::get('/', 'get_leagues_data');
                Route::get('requests', 'get_leagues_requests');
                Route::post('create', 'create');
                Route::post('update', 'update');
                Route::post('manage-request', 'manage_requests');
            });

            Route::controller('GameController')->prefix('game')->group(function () {
                Route::get('/', 'get_games_data');
                Route::get('requests', 'get_game_requests');
                Route::post('status', 'manage_game_status');
                Route::post('create', 'create');
                // Route::post('update', 'update'); // CURRENTLY NOT IN USE
                Route::post('manage-request', 'manage_requests');
            });

            Route::controller('DisputeController')->prefix('dispute')->group( function() {
                Route::post('status', 'changeStatus');
            });
        });
    });
});
