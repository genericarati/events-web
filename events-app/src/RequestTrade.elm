module RequestTrade exposing (..)

import RemoteData.Http exposing (post)
import Msg exposing (..)
import Json.Encode
import Json.Decode
import Model exposing (..)


requestTrade : Model -> Cmd Msg
requestTrade model =
    post "localhost:8080/requestTrade"
        TradeResponse
        tradeResponseDecoder
        (encodeOrder model)


tradeResponseDecoder : Json.Decode.Decoder Int
tradeResponseDecoder =
    Json.Decode.int


encodeTradeRequest : Model -> String
encodeTradeRequest model =
    Json.Encode.encode 0 (encodeOrder model)


encodeOrder : Model -> Json.Encode.Value
encodeOrder model =
    Json.Encode.object
        [ ( "ordernumber", Json.Encode.string model.selectedOrder.ordernumber )
        , ( "dealer", Json.Encode.string model.selectedOrder.dealer )
        ]
