module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button)
import Html.Attributes as Attribute exposing (..)
import Html.Events exposing (onClick)
import RemoteData.Http
import Json.Decode
import RemoteData exposing (WebData, RemoteData(..))
import Json.Decode.Pipeline
import Navigation exposing (Location)


type Page
    = Dealer1
    | Dealer2


type alias Model =
    { response : WebData Order, currentPage : Page }


type alias Order =
    { ordernumber : String, dealer : String }


init : Location -> ( Model, Cmd Msg )
init location =
    ( Model NotAsked Dealer1, createGetRequest "dealer1" )


type Msg
    = NoOp
    | RequestTrade
    | TradeResponse (WebData Order)
    | UrlChange Location
    | Dealer1Page
    | Dealer2Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestTrade ->
            ( model, createGetRequest "dealer2" )

        TradeResponse response ->
            ( { model | response = response }, Cmd.none )

        Dealer1Page ->
            ( { model | currentPage = Dealer1 }, createGetRequest "dealer1" )

        Dealer2Page ->
            ( { model | currentPage = Dealer2 }, createGetRequest "dealer2" )

        NoOp ->
            ( model, Cmd.none )

        UrlChange location ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [ myStyle ]
            [ render_page model
            , render_menu model
            ]
        , div []
            [ button [ myStyle, onClick RequestTrade ]
                [ text "Request trade" ]
            ]
        ]


render_page : Model -> Html Msg
render_page model =
    let
        value =
            case model.response of
                Success data ->
                    data

                NotAsked ->
                    { ordernumber = "", dealer = "" }

                _ ->
                    { ordernumber = "", dealer = "" }

        page_content =
            case model.currentPage of
                Dealer1 ->
                    div []
                        [ div []
                            [ div [] [ text "I am dealer1" ]
                            , div [] [ text value.ordernumber ]
                            , div [] [ text value.dealer ]
                            ]
                        ]

                Dealer2 ->
                    div []
                        [ div []
                            [ div [] [ text "I am dealer2" ]
                            , div [] [ text value.ordernumber ]
                            , div [] [ text value.dealer ]
                            ]
                        ]
    in
        div [] [ page_content ]


render_menu : Model -> Html Msg
render_menu model =
    div []
        [ button [ onClick Dealer1Page ] [ text "Dealer1 Page" ]
        , button [ onClick Dealer2Page ] [ text "Dealer2 Page" ]
        ]


tradeResponseDecoder : Json.Decode.Decoder Order
tradeResponseDecoder =
    (Json.Decode.Pipeline.decode Order)
        |> Json.Decode.Pipeline.required "ordernumber" Json.Decode.string
        |> Json.Decode.Pipeline.required "dealer" Json.Decode.string


createGetRequest : String -> Cmd Msg
createGetRequest dealerId =
    RemoteData.Http.get ("http://localhost:8080/" ++ dealerId) TradeResponse tradeResponseDecoder


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
