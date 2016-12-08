module View.Schedule exposing (..)

import Update.Main as MainUpdate
import Msg exposing (Msg)
import NativeUi as Ui
import NativeUi.Elements as Elements
import NativeUi.Style as Style
import NativeUi.Properties as Properties
import NativeUi.Events as Events
import Model.Schedule as Schedule
import Navigation.Scene as Scene
import Navigation.Navigator as Navigator
import Json.Encode


view : MainUpdate.Model -> Ui.Node Msg
view model =
    let
        schedule =
            model.schedule
                |> Maybe.map scheduleView
                |> Maybe.withDefault loadingView
    in
        Elements.view [] [ schedule ]


scheduleView : Schedule.Schedule -> Ui.Node Msg
scheduleView schedule =
    Elements.scrollView [] (schedule.movies |> List.map (movieView >> row))


movieView : Schedule.MovieValueObject -> Ui.Node Msg
movieView movie =
    let
        { title, thumbnaiUrl, id } =
            movie

        onPressEvent =
            -- ScheduleMsg <| ScheduleUpdate.MovieDetail movie
            Msg.NavigatorMsg <| Navigator.Scene <| Scene.MovieDetailPage id <| movie
    in
        Elements.view
            [-- Ui.style
             -- [ Style.height 64 ]
            ]
            [ Elements.text
                [ Ui.style [ Style.textAlign "center" ]
                , Events.onPress onPressEvent
                ]
                [ Ui.string movie.title ]
            , Elements.image
                [ Ui.style
                    [ Style.height 54
                    , Style.width 54
                    ]
                , Properties.source <| "http://www.aeoncinema.com" ++ thumbnaiUrl
                ]
                []
            ]


loadingView : Ui.Node Msg
loadingView =
    Elements.view []
        [ Elements.text [] [ Ui.string "loading..." ] ]


underlayColor : String -> Ui.Property msg
underlayColor val =
    Ui.property "underlayColor" (Json.Encode.string val)


row : Ui.Node msg -> Ui.Node msg
row children =
    Elements.touchableHighlight
        [ Ui.style styleRow
        , underlayColor "#D0D0D0"
        ]
        [ children ]


styleRow : List Style.Style
styleRow =
    [ Style.padding 1
    , Style.backgroundColor "white"
    , Style.borderBottomWidth 1
    , Style.borderBottomColor "#CDCDCD"
    ]
