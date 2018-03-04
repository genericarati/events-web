module GetOrders exposing (getListOfOrdersFromResponse, getOrdersForDealer)

import RemoteData exposing (WebData, RemoteData(..))
import Json.Decode
import Model exposing (..)
import Json.Decode.Pipeline
import Msg exposing (..)
import RemoteData.Http


getListOfOrdersFromResponse : WebData (List Model.TradeResponse) -> List Model.Order
getListOfOrdersFromResponse tradeResponses =
    case tradeResponses of
        Success data ->
            List.map (\tradeResponse -> tradeResponse.order) data

        NotAsked ->
            []

        _ ->
            []


tradeResponseDecoder : Json.Decode.Decoder Model.TradeResponse
tradeResponseDecoder =
    Json.Decode.Pipeline.decode Model.TradeResponse
        |> Json.Decode.Pipeline.required "order" orderDecoder
        |> Json.Decode.Pipeline.required "requestor" Json.Decode.string


orderDecoder : Json.Decode.Decoder Model.Order
orderDecoder =
    Json.Decode.Pipeline.decode Order
        |> Json.Decode.Pipeline.required "ordernumber" Json.Decode.string
        |> Json.Decode.Pipeline.required "dealer" Json.Decode.string


getOrdersByDealerResponseDecoder : Json.Decode.Decoder (List Model.TradeResponse)
getOrdersByDealerResponseDecoder =
    Json.Decode.list tradeResponseDecoder


getOrdersForDealer : String -> Cmd Msg
getOrdersForDealer dealerId =
    RemoteData.Http.get
        ("http://localhost:8080/" ++ dealerId)
        GetOrdersByDealerResponse
        getOrdersByDealerResponseDecoder
