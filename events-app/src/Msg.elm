module Msg exposing (..)

import RemoteData exposing (WebData)
import Model exposing (..)
import Material exposing (Msg)


type Msg
    = NoOp
    | RequestTrade Model.Order
    | GetOrdersByDealerResponse (WebData (List Model.Order))
    | Dealer1Page
    | Dealer2Page
    | LinkTo String
    | TradeResponse (WebData Int)
    | Mdl (Material.Msg Msg)
    | Trade Model.Order
    | OrderTransferred String
