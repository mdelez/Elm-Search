module Main exposing (..)

import Browser
import Search


main : Program () Search.Model Search.Msg
main =
    Browser.element
        { init = Search.init
        , view = Search.view
        , update = Search.update
        , subscriptions = Search.subscriptions
        }
