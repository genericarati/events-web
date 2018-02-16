module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button)
import Html.Attributes as Attribute exposing (..)
import Html.Events exposing (onClick)
import RemoteData.Http
import Json.Decode
import RemoteData exposing (WebData, RemoteData(..))
import Json.Decode.Pipeline


type alias Model =
    { order : String, dealer : String, response : WebData Order }


type alias Order =
    { message : String }


init : ( Model, Cmd Msg )
init =
    ( { order = "12345", dealer = "dealer1", response = NotAsked }, Cmd.none )


type Msg
    = NoOp
    | RequestTrade
    | TradeResponse (WebData Order)


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
                    { message = "Initial value" }

                _ ->
                    { message = "Problem" }
    in
        div []
            [ div [ myStyle ]
                [ text "I am dealer 1-", text value.message ]
            , div []
                [ button [ myStyle, onClick RequestTrade ] [ text "Request trade" ]
                ]
            ]


tradeResponseDecoder : Json.Decode.Decoder Order
tradeResponseDecoder =
    Json.Decode.Pipeline.required
        "message"
        Json.Decode.string
        (Json.Decode.Pipeline.decode Order)


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
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
