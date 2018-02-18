module GetOrders exposing (getListOfOrdersFromResponse, getOrdersForDealer)

import RemoteData exposing (WebData, RemoteData(..))
import Json.Decode
import Model exposing (..)
import Json.Decode.Pipeline
import Msg exposing (..)
import RemoteData.Http


getListOfOrdersFromResponse : WebData (List Model.Order) -> List Model.Order
getListOfOrdersFromResponse orderListWebData =
    case orderListWebData of
        Success data ->
            data

        NotAsked ->
            []

        _ ->
            []


orderDecoder : Json.Decode.Decoder Model.Order
orderDecoder =
    Json.Decode.Pipeline.decode Order
        |> Json.Decode.Pipeline.required "ordernumber" Json.Decode.string
        |> Json.Decode.Pipeline.required "dealer" Json.Decode.string


getOrdersByDealerResponseDecoder : Json.Decode.Decoder (List Model.Order)
getOrdersByDealerResponseDecoder =
    Json.Decode.list orderDecoder


getOrdersForDealer : String -> Cmd Msg
getOrdersForDealer dealerId =
    RemoteData.Http.get
        ("http://localhost:8080/" ++ dealerId)
        GetOrdersByDealerResponse
        getOrdersByDealerResponseDecoder
