module Search exposing (..)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)


type alias SearchParams =
    { text : String
    }


init : () -> ( SearchParams, Cmd Msg )
init _ =
    ( SearchParams ""
    , Cmd.none
    )


type Msg
    = Change String
    | Submit


update : Msg -> SearchParams -> ( SearchParams, Cmd Msg )
update msg searchParams =
    case msg of
        Change searchTerm ->
            ( { searchParams | text = searchTerm }, Cmd.none )

        Submit ->
            ( { searchParams
                | text =
                    searchParams.text
                        |> Debug.log searchParams.text
              }
            , Cmd.none
            )


subscriptions : SearchParams -> Sub Msg
subscriptions model =
    Sub.none


view : SearchParams -> Html Msg
view searchParams =
    div [ class "main-div" ]
        [ div [ class "search" ]
            [ input [ placeholder "Search...", value searchParams.text, onInput Change ] []
            , button [ onClick Submit ] [ text "Search" ]
            ]
        , div [ class "results" ] []
        ]
