port module Update
    exposing
        ( Msg(..)
        , subscriptions
        , update
        , init
        )

import Date
import Http
import Json.Decode exposing (Decoder)
import RemoteData
import Model exposing (..)
import Decoder exposing (graphsDecoder)
import Keydown


port windowResize : (Int -> a) -> Sub a


type Msg
    = ProcessInput String
    | HandleKeyboardInput Keydown.Event
    | UpdateStartDate String
    | HandleResponse (RemoteData.WebData (List Graph))
    | UpdatePeriodInterval String
    | NoOp
    | ResizeWindow Int


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ProcessInput s ->
            { model | inputText = s } ! []

        HandleKeyboardInput i ->
            if i.keyCode == 13 && i.metaKey then
                model
                    ! [ (requestChartResult model.inputText graphsDecoder)
                            |> RemoteData.sendRequest
                            |> Cmd.map HandleResponse
                      ]
            else
                model ! []

        HandleResponse e ->
            case e of
                RemoteData.Success d ->
                    { model | graphs = d } ! []

                _ ->
                    model ! []

        UpdateStartDate startDate ->
            case Date.fromString startDate of
                Ok parsedDate ->
                    { model | startDate = parsedDate } ! []

                _ ->
                    model ! []

        UpdatePeriodInterval periodInterval ->
            case parsePeriodInterval periodInterval of
                Just result ->
                    { model | periodInterval = result } ! []

                _ ->
                    model ! []

        ResizeWindow width ->
            { model | windowWidth = width } ! []


subscriptions : Model -> Sub Msg
subscriptions =
    always <| windowResize ResizeWindow


endpointUrl : String
endpointUrl =
    "http://localhost:5515/"


requestChartResult : String -> Decoder a -> Http.Request a
requestChartResult stringBody decoder =
    let
        body =
            Http.stringBody "text/plain" stringBody
    in
        Http.request
            { method = "POST"
            , headers = []
            , url = endpointUrl
            , body = body
            , expect = Http.expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }
