module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date.Extra as Date
import Json.Decode as JD exposing (Decoder)
import Keydown
import View.Chart as Chart
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ Chart.view model
        , submissionForm model
        , dateSelector model
        , periodIntervalSelector model
        ]


dateSelector : Model -> Html Msg
dateSelector model =
    let
        stringifiedDate =
            Date.toFormattedString "YYYY-MM-dd" model.startDate
    in
        input
            [ type_ "date"
            , onInput UpdateStartDate
            , value stringifiedDate
            ]
            []


periodIntervalSelector : Model -> Html Msg
periodIntervalSelector model =
    select [ on "change" <| JD.map UpdatePeriodInterval targetValue ]
        [ option [ value "Day" ] [ text "Day" ]
        , option [ value "Week" ] [ text "Week" ]
        , option [ value "Month" ] [ text "Month" ]
        ]


submissionForm : Model -> Html Msg
submissionForm model =
    Html.form [ id "inputs" ]
        [ errors
        , parserTextarea model
        ]


errors : Html a
errors =
    p [ class "error" ] []


parserTextarea : Model -> Html Msg
parserTextarea model =
    textarea [ captureKeyboardInput, onInput ProcessInput ]
        [ text model.inputText
        ]


captureKeyboardInput : Attribute Msg
captureKeyboardInput =
    on "keydown" (JD.map HandleKeyboardInput Keydown.decoder)
