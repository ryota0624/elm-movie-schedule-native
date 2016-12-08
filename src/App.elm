module App exposing (..)

import View.Schedule as ScheduleView
import View.MovieDetail as MovieView
import NativeUi
import Navigation.Navigator as Navigator
import Navigation.Scene as Scene
import NativeUi.Elements as Elements
import Msg exposing (Msg)
import Update.Main as MainApp
import NativeUi.Events as Events
import NativeUi.Style as Style
import Update.Movie as UpdateMovie
import Dict


type alias Model =
    { navigator : Navigator.Model
    , appModel : MainApp.Model
    }


initialModel : Model
initialModel =
    Model Navigator.initialModel MainApp.initialModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.NavigatorMsg subMsg ->
            let
                navigator =
                    Navigator.update subMsg model.navigator

                cmd =
                    case navigator.page of
                        Scene.MovieDetailPage id movie ->
                            UpdateMovie.getMovie id (Just movie) |> Cmd.map (MainApp.MovieMsg >> Msg.AppMsg)

                        _ ->
                            Cmd.none
            in
                { model | navigator = navigator } ! [ cmd ]

        Msg.AppMsg subMsg ->
            let
                ( appModel, cmd ) =
                    MainApp.update subMsg model.appModel
            in
                { model | appModel = appModel } ! [ cmd |> Cmd.map Msg.AppMsg ]

        Msg.None ->
            model ! []


view : Model -> NativeUi.Node Msg
view model =
    let
        sceneView =
            case model.navigator.page of
                Scene.SchedulePage ->
                    ScheduleView.view model.appModel

                Scene.MovieDetailPage id movieValueObject ->
                    let
                        movieDetail =
                            model.appModel.movieList |> Dict.get id
                    in
                        MovieView.view movieValueObject movieDetail

                Scene.ReviewPage movie ->
                    Elements.text [] [ NativeUi.string movie.title ]
    in
        Elements.view []
            [ Elements.view
                [ NativeUi.style
                    [ Style.height 32 ]
                ]
                []
            , header model
            , sceneView
            ]


header : Model -> NativeUi.Node Msg
header model =
    Elements.view []
        [ Elements.text
            [ Events.onPress <| Msg.NavigatorMsg <| Navigator.Back ]
            [ NativeUi.string "もどる" ]
        ]


main : Program Never Model Msg
main =
    NativeUi.program
        { init = initialModel ! [ MainApp.initialCmd |> Cmd.map Msg.AppMsg ]
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
