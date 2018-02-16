module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button)
import Html.Attributes as Attribute exposing (..)
import Html.Events exposing (onClick)
import RemoteData.Http
import Json.Decode
import RemoteData exposing (WebData, RemoteData(..))
import Json.Decode.Pipeline
import Navigation exposing (Location)


type alias Model =
    { response : WebData Order }


type alias Order =
    { ordernumber : String, dealer : String }


init : Location -> ( Model, Cmd Msg )
init location =
    ( { response = NotAsked }, Cmd.none )


type Msg
    = NoOp
    | RequestTrade
    | TradeResponse (WebData Order)
    | UrlChange Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestTrade ->
            ( model, createGetRequest )

        TradeResponse response ->
            ( { model | response = response }, Cmd.none )

        _ ->
            let
                _ =
                    Debug.log "all other cases"
            in
                ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        value =
            case model.response of
                Success data ->
                    data

                NotAsked ->
                    { ordernumber = "", dealer = "" }

                _ ->
                    { ordernumber = "", dealer = "" }
    in
        div []
            [ div [ myStyle ]
                [ text value.dealer ]
            , div []
                [ button [ myStyle, onClick RequestTrade ] [ text "Request trade" ]
                ]
            ]


tradeResponseDecoder : Json.Decode.Decoder Order
tradeResponseDecoder =
    (Json.Decode.Pipeline.decode Order)
        |> Json.Decode.Pipeline.required "ordernumber" Json.Decode.string
        |> Json.Decode.Pipeline.required "dealer" Json.Decode.string


createGetRequest : Cmd Msg
createGetRequest =
    RemoteData.Http.get "http://localhost:8080/" TradeResponse tradeResponseDecoder


myStyle : Html.Attribute msg
myStyle =
    style
        [ ( "margin-left", "auto" )
        , ( "margin-right", "auto" )
        , ( "margin-top", "20px" )
        , ( "width", "100px" )
        ]


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
