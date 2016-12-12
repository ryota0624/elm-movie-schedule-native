module View exposing (..)

import NativeUi
import Dict
import View.Header as Header
import NativeUi.NavigationExperimental as NE
import NativeUi.Elements as Elements
import View.Schedule as ScheduleView
import View.MovieDetail as MovieView
import NativeUi.Style as Style
import NativeUi as Ui
import Navigation.Navigator exposing (Model, Msg(ReviewSceneMsg))
import View.ReviewComponent.View as ReviewComponent


-- import NativeUi.Properties as Properties


view : Model -> NativeUi.Node Msg
view model =
    Elements.view [ Ui.style [ Style.flex 1 ] ]
        [ Elements.navigationCardStack
            [ Ui.style
                [ Style.flex 20 ]
            , NE.navigationState model.navigator
            , NE.renderHeader Header.view
            , NE.renderScene (model |> contentsView)
            ]
            []
        ]


contentsView : Model -> NE.NavigationSceneRenderer -> NativeUi.Node Msg
contentsView model { scene } =
    case scene.key of
        "scene_schedule" ->
            ScheduleView.view model.appModel

        "scene_movie" ->
            let
                movieView id =
                    MovieView.view
                        (model.appModel.reviews |> Dict.get id)
            in
                model.movieSceneModel
                    |> Maybe.map ((\id -> model.appModel.movieList |> Dict.get id |> movieView id))
                    |> Maybe.withDefault (Elements.text [] [ NativeUi.string "loading" ])

        "scene_review" ->
            model.reviewSceneModel.movie
                |> Maybe.map
                    (\movie -> (ReviewComponent.view model.reviewSceneModel.reviewComponent))
                |> Maybe.withDefault (Elements.text [] [ NativeUi.string "loading" ])

        _ ->
            Elements.text [] [ NativeUi.string scene.key ]
