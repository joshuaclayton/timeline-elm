module Decoder
    exposing
        ( graphsDecoder
        )

import Json.Decode as JD exposing (Decoder)
import Model exposing (Graph(..), GraphName(..))


graphsDecoder : Decoder (List Graph)
graphsDecoder =
    JD.field "graphs" <| JD.list graphDecoder


graphDecoder : Decoder Graph
graphDecoder =
    JD.field "_type" JD.string
        |> JD.andThen graphTypeDecoder


graphTypeDecoder : String -> Decoder Graph
graphTypeDecoder graphType =
    case graphType of
        "line" ->
            JD.map2
                LineGraph
                (JD.field "name" graphNameDecoder)
                (JD.field "points" pointsDecoder)

        unknownGraphType ->
            JD.fail <| "Unknown graph type: " ++ unknownGraphType


pointsDecoder : Decoder (List Float)
pointsDecoder =
    JD.list JD.float


graphNameDecoder : Decoder GraphName
graphNameDecoder =
    JD.oneOf
        [ JD.null UnnamedGraph
        , JD.map GraphName JD.string
        ]
