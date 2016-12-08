module Msg exposing (..)

import Update.Main as MainApp
import Navigation.Navigator as Navigator


type Msg
    = NavigatorMsg Navigator.Msg
    | AppMsg MainApp.Msg
    | None
