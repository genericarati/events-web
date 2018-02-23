module ViewHelpers exposing (..)

import Model exposing (..)
import Html exposing (Html, text, div, h1, img, button, ul, li)
import Html.Attributes as Attributes exposing (..)
import Msg exposing (..)
import GetOrders exposing (..)
import Material.Table as Table exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)


myStyle : Html.Attribute msg
myStyle =
    Attributes.style
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
                [ Table.th [] [ Html.text "Order" ]
                , Table.th [] [ Html.text "Dealer" ]
                , Table.th [] [ Html.text "Action" ]
                ]
            ]
        , Table.tbody []
            (orderList
                |> List.map
                    (\order ->
                        Table.tr []
                            [ Table.td [] [ Html.text order.ordernumber ]
                            , Table.td [ Table.numeric ] [ Html.text order.dealer ]
                            , Table.td [ Table.numeric ]
                                [ Html.button
                                    -- [ Html.Events.onClick (RequestTrade order) ]
                                    [ Html.Events.onClick (Trade) ]
                                    [ Html.text "Request Trade" ]
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
                        [ h1 [] [ Html.text "I am dealer1" ]
                        , notificationIcon
                        , render_order_table orderList model
                        , Html.text model.webSocketResponse
                        ]

                Dealer2 ->
                    Html.div [ myStyle ]
                        [ h1 [] [ Html.text "I am dealer2" ]
                        , notificationIcon
                        , render_order_table orderList model
                        , Html.text model.webSocketResponse
                        ]
    in
        Html.div [] [ page_content ]


notificationIcon : Html.Html msg
notificationIcon =
    svg
        [ Svg.Attributes.width "24"
        , Svg.Attributes.height "24"
        , viewBox "0 0 24 24"
        , Svg.Attributes.fill "#000000"
        ]
        [ Svg.path
            [ d "M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z" ]
            []
        ]
