module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button, ul, li)
import Html.Attributes as Attribute exposing (..)
import Html.Events exposing (onClick)
import RemoteData.Http
import Json.Decode
import RemoteData exposing (WebData, RemoteData(..))
import Navigation exposing (Location)
import Json.Decode.Pipeline


type Page
    = Dealer1
    | Dealer2


type alias Model =
    { response : WebData (List Order), currentPage : Page }


type alias Order =
    { ordernumber : String, dealer : String }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        page =
            case location.hash of
                "#Dealer1" ->
                    Dealer1

                "#Dealer2" ->
                    Dealer2

                _ ->
                    Dealer1

        command =
            case location.hash of
                "#Dealer1" ->
                    "dealer1"

                "#Dealer2" ->
                    "dealer2"

                _ ->
                    "dealer1"
    in
        ( Model NotAsked page, createGetRequest command )


type Msg
    = NoOp
    | RequestTrade
    | TradeResponse (WebData (List Order))
    | Dealer1Page
    | Dealer2Page
    | LinkTo String


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

        LinkTo path ->
            ( model, Navigation.newUrl path )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [ myStyle ]
            [ render_page model
            , render_menu model
            ]
        ]


getListOfOrdersFromResponse : WebData (List Order) -> List Order
getListOfOrdersFromResponse orderListWebData =
    case orderListWebData of
        Success data ->
            data

        NotAsked ->
            []

        _ ->
            []


render_Order : Order -> Html msg
render_Order order =
    let
        value =
            order.ordernumber ++ " " ++ order.dealer
    in
        li [] [ text value ]


render_page : Model -> Html Msg
render_page model =
    let
        orderList =
            getListOfOrdersFromResponse model.response

        page_content =
            case model.currentPage of
                Dealer1 ->
                    div [ myStyle ]
                        [ h1 [] [ text "I am dealer1" ]
                        , ul [] (List.map render_Order orderList)
                        ]

                Dealer2 ->
                    div [ myStyle ]
                        [ h1 [] [ text "I am dealer2" ]
                        , ul [] (List.map render_Order orderList)
                        ]
    in
        div [] [ page_content ]


render_menu : Model -> Html Msg
render_menu model =
    let
        value =
            case model.currentPage of
                Dealer1 ->
                    "#Dealer1"

                Dealer2 ->
                    "#Dealer2"
    in
        div []
            [ button [ onClick (LinkTo value) ] [ text "Request Trade" ]
            ]


orderDecoder : Json.Decode.Decoder Order
orderDecoder =
    Json.Decode.Pipeline.decode Order
        |> Json.Decode.Pipeline.required "ordernumber" Json.Decode.string
        |> Json.Decode.Pipeline.required "dealer" Json.Decode.string


tradeResponseDecoder : Json.Decode.Decoder (List Order)
tradeResponseDecoder =
    Json.Decode.list orderDecoder


createGetRequest : String -> Cmd Msg
createGetRequest dealerId =
    RemoteData.Http.get ("http://localhost:8080/" ++ dealerId) TradeResponse tradeResponseDecoder


myStyle : Html.Attribute msg
myStyle =
    style
        [ ( "margin-left", "auto" )
        , ( "margin-right", "auto" )
        , ( "margin-top", "20px" )
        , ( "width", "200px" )
        ]


main : Program Never Model Msg
main =
    Navigation.program locFor
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


locFor : Location -> Msg
locFor location =
    case location.hash of
        "#Dealer1" ->
            Dealer1Page

        "#Dealer2" ->
            Dealer2Page

        _ ->
            NoOp
