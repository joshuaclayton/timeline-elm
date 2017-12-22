module View.Colors
    exposing
        ( graphColors
        , toString
        )

import Color exposing (Color)
import Color.Convert as Color


toString : Color -> String
toString =
    Color.colorToCssRgba


graphColors : List Color
graphColors =
    [ skyBlue
    , leafGreen
    , purple
    , gold
    , redOrange
    , lightBlue
    , fungusGreen
    , brightPurple
    , raspberry
    , blush
    ]


skyBlue : Color
skyBlue =
    Color.rgb 92 192 255


leafGreen : Color
leafGreen =
    Color.rgb 124 179 66


purple : Color
purple =
    Color.rgb 176 115 200


gold : Color
gold =
    Color.rgb 251 211 35


redOrange : Color
redOrange =
    Color.rgb 255 128 88


lightBlue : Color
lightBlue =
    Color.rgb 189 230 255


fungusGreen : Color
fungusGreen =
    Color.rgb 198 225 166


brightPurple : Color
brightPurple =
    Color.rgb 233 176 255


raspberry : Color
raspberry =
    Color.rgb 254 83 99


blush : Color
blush =
    Color.rgb 255 190 170


toFadedCssRgba : Color -> String
toFadedCssRgba =
    Color.colorToCssRgba
