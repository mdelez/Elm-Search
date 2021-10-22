module Search3 exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, field, int)
import Search2 exposing (ValidationResult(..))
import String exposing (length)


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , update = update
        , init = init
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { searchTerm : String
    , offset : Int
    , searchResult : SearchResult
    , count : Int
    }


type SearchResult
    = NotDone
    | Error String
    | Result Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" 0 NotDone 0, Cmd.none )



-- UPDATE


type Msg
    = SearchTerm String
    | Offset Int
    | Submit
    | GotResults (Result Http.Error Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        SearchTerm text ->
            ( { model | searchTerm = text }, Cmd.none )

        Offset num ->
            ( { model | offset = num }, Cmd.none )

        Submit ->
            ( { model | searchResult = getSearchResults model }, doSearch model.searchTerm )

        GotResults result ->
            case result of
                Ok count ->
                    ( { model | count = count }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


getSearchResults : Model -> SearchResult
getSearchResults model =
    Result model.count


doSearch : String -> Cmd Msg
doSearch term =
    Http.get
        { url = "https://api.test.dasch.swiss/v2/search/count/" ++ term ++ "?offset=0"
        , expect = Http.expectJson GotResults countDecoder
        }


countDecoder : Decoder Int
countDecoder =
    field "schema:numberOfItems" int


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Search", onInput SearchTerm ] []
        , button [ onClick Submit ] [ text "submit" ]
        , viewResults model
        ]


viewResults : Model -> Html msg
viewResults model =
    let
        x =
            Debug.log "hello"
    in
    case model.searchResult of
        NotDone ->
            div [] []

        Error _ ->
            div []
                [ text "Unable to retrieve count" ]

        Result count ->
            div []
                [ text (String.fromInt count) ]
