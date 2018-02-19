module RequestTrade exposing (..)

import RemoteData.Http exposing (post)
import Msg exposing (..)
import Json.Encode
import Json.Decode
import Model exposing (..)


requestTrade : Model.Order -> Cmd Msg
requestTrade order =
    post "http://localhost:8080/requestTrade"
        TradeResponse
        tradeResponseDecoder
        (encodeOrder order)


tradeResponseDecoder : Json.Decode.Decoder Int
tradeResponseDecoder =
    Json.Decode.int


encodeOrder : Model.Order -> Json.Encode.Value
encodeOrder order =
    Json.Encode.object
        [ ( "ordernumber", Json.Encode.string order.ordernumber )
        , ( "dealer", Json.Encode.string order.dealer )
        ]
