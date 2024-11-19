<?php

namespace App\Http\Requests\Game;

use Illuminate\Foundation\Http\FormRequest;

class CreateRequest extends FormRequest
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
            'league_id.exists' => 'The league id does not exist in our records.'
        ];
    }
}