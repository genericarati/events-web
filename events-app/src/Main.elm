module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button)
import Html.Attributes as Attribute exposing (..)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Model =
    { order : String, dealer : String }


init : ( Model, Cmd Msg )
init =
    ( { order = "12345", dealer = "dealer1" }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | RequestTrade


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestTrade ->
            ( { model | dealer = "dealer2" }, Cmd.none )

        _ ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ div [ myStyle ]
            [ text "I am dealer 1", text model.dealer ]
        , div []
            [ button [ myStyle, onClick RequestTrade ] [ text "Request trade" ]
            ]
        ]


myStyle : Html.Attribute msg
myStyle =
    style
        [ ( "margin-left", "auto" )
        , ( "margin-right", "auto" )
        , ( "margin-top", "20px" )
        , ( "width", "100px" )
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
