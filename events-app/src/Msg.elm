module Msg exposing (..)

import RemoteData exposing (WebData)
import Model exposing (..)


type Msg
    = NoOp
    | RequestTrade
    | GetOrdersByDealerResponse (WebData (List Model.Order))
    | Dealer1Page
    | Dealer2Page
    | LinkTo String
    | TradeResponse (WebData Int)
