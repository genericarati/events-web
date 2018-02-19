module ViewHelpers exposing (..)

import Model exposing (..)
import Html exposing (Html, text, div, h1, img, button, ul, li)
import Html.Attributes as Attributes exposing (..)
import Msg exposing (..)
import GetOrders exposing (..)
import Material.Table as Table exposing (..)
import Html.Events exposing (onClick)


myStyle : Html.Attribute msg
myStyle =
    style
        [ ( "margin-left", "auto" )
        , ( "margin-right", "auto" )
        , ( "margin-top", "20px" )
        , ( "width", "400px" )
        ]


render_order_table : List Model.Order -> Model.Model -> Html Msg.Msg
render_order_table orderList model =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "Order" ]
                , Table.th [] [ text "Dealer" ]
                , Table.th [] [ text "Action" ]
                ]
            ]
        , Table.tbody []
            (orderList
                |> List.map
                    (\order ->
                        Table.tr []
                            [ Table.td [] [ text order.ordernumber ]
                            , Table.td [ Table.numeric ] [ text order.dealer ]
                            , Table.td [ Table.numeric ]
                                [ Html.button
                                    [ Html.Events.onClick (RequestTrade order) ]
                                    [ text "Request Trade" ]
                                ]
                            ]
                    )
            )
        ]


render_page : Model.Model -> Html Msg.Msg
render_page model =
    let
        orderList =
            getListOfOrdersFromResponse model.response

        page_content =
            case model.currentPage of
                Dealer1 ->
                    Html.div [ myStyle ]
                        [ h1 [] [ text "I am dealer1" ]
                        , render_order_table orderList model
                        ]

                Dealer2 ->
                    Html.div [ myStyle ]
                        [ h1 [] [ text "I am dealer2" ]
                        , render_order_table orderList model
                        ]
    in
        Html.div [] [ page_content ]
