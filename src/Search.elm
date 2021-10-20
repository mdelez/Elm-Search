module Search exposing (..)

import Html exposing (Html, button, div, h2, input, text)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, field, int)


type Model
    = Loading
    | Success Int
    | Failure


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , getSearchResults
    )


type Msg
    = Submit
    | GotResults (Result Http.Error Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            ( Loading, getSearchResults )

        GotResults result ->
            case result of
                Ok count ->
                    ( Success count, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Resource Count" ]
        , viewCount model
        ]


viewCount : Model -> Html Msg
viewCount model =
    case model of
        Failure ->
            div []
                [ text "Unable to retrieve count"
                , button [ onClick Submit ] [ text "Try Again" ]
                ]

        Loading ->
            text "Loading..."

        Success count ->
            div []
                [ button [ onClick Submit ] [ text "Get Count" ]
                , text (String.fromInt count)
                ]


getSearchResults : Cmd Msg
getSearchResults =
    Http.get
        { url = "https://api.test.dasch.swiss/v2/search/count/test?offset=0"
        , expect = Http.expectJson GotResults countDecoder
        }


countDecoder : Decoder Int
countDecoder =
    field "schema:numberOfItems" int
