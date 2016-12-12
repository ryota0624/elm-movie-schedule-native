module App exposing (..)

import Navigation.Navigator as Navigator
import Update.Main as MainApp
import NativeUi
import View exposing (view)
import Navigation.Navigator exposing (update, Model, Msg(AppMsg))


main : Program Never Model Msg
main =
    NativeUi.program
        { init = Navigator.initialModel ! [ MainApp.initialCmd |> Cmd.map AppMsg ]
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
