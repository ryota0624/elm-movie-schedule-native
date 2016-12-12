module View.Header exposing (..)

import NativeUi
import NativeUi.NavigationExperimental as NE
import NativeUi exposing (Node)
import NativeUi as Ui
import NativeUi.Elements as Elements
import Navigation.Navigator exposing (Msg)
import NativeUi.Events as Events
import Navigation.Navigator exposing (Msg(Pop))


view : NE.NavigationSceneRenderer -> NativeUi.Node Msg
view props =
    let
        rendererProps =
            NE.navigationSceneRendererToPropertyList props

        headerProps =
            [ NE.renderTitleComponent viewTitle
            , Events.onNavigateBack Pop
            ]
    in
        Elements.navigationHeader
            (rendererProps ++ headerProps)
            []


viewTitle : NE.NavigationSceneRenderer -> Node Msg
viewTitle props =
    Elements.navigationHeaderTitle
        []
        [ Ui.string <| Maybe.withDefault props.scene.route.key props.scene.route.title ]
