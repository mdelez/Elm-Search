module Search2 exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String exposing (length)


main =
    Browser.sandbox
        { view = view
        , update = update
        , init = init
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , validationResult : ValidationResult
    }


init : Model
init =
    Model "" "" "" NotDone


type ValidationResult
    = NotDone
    | Error String
    | ValidationOK



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Submit


update : Msg -> Model -> Model
update action model =
    case action of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Submit ->
            { model | validationResult = validate model }


validate : Model -> ValidationResult
validate model =
    if String.length model.password < 3 then
        Error "Password length must be as least 3 chars long"

    else if model.password /= model.passwordAgain then
        Error "Passwords do not match!"

    else
        ValidationOK



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , button [ onClick Submit ] [ text "submit" ]
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( color, message ) =
            case model.validationResult of
                NotDone ->
                    ( "", "" )

                Error err ->
                    ( "red", err )

                ValidationOK ->
                    ( "green", "OK" )
    in
    div [ style "color" color ] [ text message ]
