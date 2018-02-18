module Model exposing (..)

import RemoteData exposing (WebData, RemoteData(..))


type Page
    = Dealer1
    | Dealer2


type alias Model =
    { response : WebData (List Order), currentPage : Page }


type alias Order =
    { ordernumber : String, dealer : String }
