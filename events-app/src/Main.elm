module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button, ul, li)
import RemoteData exposing (WebData, RemoteData(..))
import Navigation exposing (Location)
import GetOrders exposing (getListOfOrdersFromResponse, getOrdersForDealer)
import Model exposing (Model, Order, Page(..))
import Msg exposing (..)
import ViewHelpers exposing (..)
import RequestTrade exposing (requestTrade)
import Material


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
        ( Model NotAsked page (Order "" "") Material.model, getOrdersForDealer command )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestTrade order ->
            let
                _ =
                    Debug.log "test"
            in
                ( { model | selectedOrder = order }, requestTrade model )

        GetOrdersByDealerResponse response ->
            ( { model | response = response }, Cmd.none )

        Dealer1Page ->
            ( { model | currentPage = Dealer1 }, getOrdersForDealer "dealer1" )

        Dealer2Page ->
            ( { model | currentPage = Dealer2 }, getOrdersForDealer "dealer2" )

        LinkTo path ->
            ( model, Navigation.newUrl path )

        NoOp ->
            ( model, Cmd.none )

        TradeResponse response ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div []
        [ div [ myStyle ]
            [ render_page model
            ]
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
