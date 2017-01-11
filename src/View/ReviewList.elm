module View.ReviewList exposing (view)

import NativeUi as Ui
import NativeUi.Elements as Elements exposing (text, slider, textInput)
import Update.Main as MainUpdate
import Navigation.Navigator as Navigator


view : MainUpdate.Model -> Ui.Node Navigator.Msg
view model =
    Elements.view [] []
