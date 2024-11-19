<?php

namespace App\Http\Requests\Game;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'league_id'  => 'required|numeric|digits_between:1,20|exists:leagues,id',
            'game_id'    => 'required|numeric|digits_between:1,20|exists:games,id',
            'name'       => 'required|string|min:3|max:255|unique:games,name',
            'lane'       => 'required|numeric|digits_between:1,10',
            'start_time' => 'required|string|min:4|max:255'
        ];
    }

    /**
     * Get the custom error messages for the validator.
     *
     * @return array
     */
    public function messages()
    {
        return [
            'league_id.exists' => 'The league id does not exist in our records.',
            'game_id.exists'   => 'The game id does not exist in our records.'
        ];
    }
}
