module ViewHelpers exposing (..)

import Model exposing (..)
import Html exposing (Html, text, div, h1, img, button, ul, li)
import Html.Attributes as Attribute exposing (..)
import Html.Events exposing (onClick)
import Msg exposing (..)
import GetOrders exposing (..)


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
            [ button [ onClick RequestTrade ] [ text "Request Trade" ]
            ]


myStyle : Html.Attribute msg
myStyle =
    style
        [ ( "margin-left", "auto" )
        , ( "margin-right", "auto" )
        , ( "margin-top", "20px" )
        , ( "width", "200px" )
        ]


render_Order : Model.Order -> Html msg
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
