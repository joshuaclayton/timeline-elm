module View.Chart exposing (view)

import Html exposing (..)
import Svg.Attributes
import Html.Attributes exposing (id)
import Color exposing (Color)
import Date exposing (Date)
import Date.Extra as Date
import Plot exposing (defaultSeriesPlotCustomizations)
import Model exposing (..)
import Update exposing (Msg(NoOp))
import View.Colors as Colors


view : Model -> Html Msg
view model =
    let
        options =
            plotConfig (always NoOp) model
    in
        div [ id "chart" ]
            [ Plot.viewSeriesCustom
                { options | width = model.windowWidth }
                (List.map2 graphToSeries Colors.graphColors model.graphs)
                []
            ]


graphToSeries : Color -> Graph -> Plot.Series a b
graphToSeries color =
    renderLine color << graphToPoints


graphToPoints : Graph -> List (Plot.DataPoint a)
graphToPoints graph =
    graphToValues graph
        |> withIndex
        |> List.map (\( i, v ) -> Plot.clear (toFloat i) v)


renderLine : Color -> List (Plot.DataPoint a) -> Plot.Series b a
renderLine color points =
    { axis = Plot.axisAtMin
    , interpolation = Plot.Monotone Nothing [ Svg.Attributes.stroke <| Colors.toString color ]
    , toDataPoints = always points
    }


withIndex : List a -> List ( Int, a )
withIndex xs =
    List.map2 (,) (List.range 0 <| List.length xs - 1) xs


plotConfig : (Maybe Plot.Point -> a) -> Model -> Plot.PlotCustomizations a
plotConfig hoverMsg model =
    { defaultSeriesPlotCustomizations
        | onHover = Just hoverMsg
        , horizontalAxis = horizontalAxis model
        , toRangeLowest = always (modelDomain model).min
        , toRangeHighest = always (modelDomain model).max
    }


horizontalAxis : Model -> Plot.Axis
horizontalAxis model =
    let
        convertToDate pos =
            domainOffset model (round pos)
    in
        Plot.customAxis <|
            \summary ->
                { position = Plot.closestToZero
                , axisLine = Just <| Plot.simpleLine summary
                , ticks = List.map Plot.simpleTick <| Plot.decentPositions summary
                , labels = List.map (dateLabel model << convertToDate) <| Plot.decentPositions summary
                , flipAnchor = False
                }


stringifiedDate : Date -> String
stringifiedDate =
    Date.toFormattedString "YYYY-MM-dd"


dateLabel : Model -> Date -> Plot.LabelCustomizations
dateLabel model date =
    let
        dateToPosition =
            toFloat <| domainReverseOffset model date

        domainOffset =
            date
    in
        { position = dateToPosition
        , view = Plot.viewLabel [] (stringifiedDate domainOffset)
        }
