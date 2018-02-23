module Model exposing (..)

import RemoteData exposing (WebData, RemoteData(..))
import Material


type Page
    = Dealer1
    | Dealer2


type alias Model =
    { response : WebData (List Order)
    , currentPage : Page
    , selectedOrder : Order
    , mdl : Material.Model
    , webSocketResponse : String
    }


type alias Order =
    { ordernumber : String, dealer : String }
