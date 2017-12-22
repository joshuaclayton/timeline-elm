module Main exposing (main)

import Html
import View
import Update
import Model


main : Program Never Model.Model Update.Msg
main =
    Html.program
        { view = View.view
        , init = Update.init
        , update = Update.update
        , subscriptions = Update.subscriptions
        }
