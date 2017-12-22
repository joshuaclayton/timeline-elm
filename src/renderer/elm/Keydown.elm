module Keydown
    exposing
        ( Event
        , decoder
        )

import Char exposing (KeyCode)
import Json.Decode as JD exposing (Decoder)


type alias Event =
    { keyCode : KeyCode
    , metaKey : Bool
    }


decoder : Decoder Event
decoder =
    JD.map2 Event (JD.field "keyCode" JD.int) (JD.field "metaKey" JD.bool)
