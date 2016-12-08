module View.MovieDetail exposing (view)

import NativeUi as Ui
import NativeUi.Elements as Elements exposing (text)
import Model.Movie exposing (Movie)
import Model.Schedule exposing (MovieValueObject)
import Msg
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Properties as Properties
import NativeUi.Events exposing (onPress)
import Navigation.Scene as Scene
import Navigation.Navigator as Navigator


view : MovieValueObject -> Maybe Movie -> Ui.Node Msg.Msg
view vo detail =
    let
        onPressEvent =
            detail
                |> Maybe.map (Scene.ReviewPage >> Navigator.Scene >> Msg.NavigatorMsg)
                |> Maybe.withDefault Msg.None
    in
        Elements.scrollView []
            [ Elements.text []
                [ Ui.string vo.title ]
            , Elements.image
                [ Ui.style
                    [ Style.height 64
                    , Style.width 64
                    , Style.marginBottom 30
                    ]
                , Properties.source <| "http://www.aeoncinema.com" ++ vo.thumbnaiUrl
                ]
                []
            , Elements.view
                [ Ui.style
                    [ Style.width 80
                    , Style.flexDirection "row"
                    , Style.justifyContent "space-between"
                    ]
                ]
                [ button onPressEvent "#d33" "レビュー"
                ]
            , Elements.text
                []
                [ Ui.string (detail |> Maybe.map (\{ story } -> story) |> Maybe.withDefault "")
                ]
            ]


button : a -> String -> String -> Ui.Node a
button msg color content =
    text
        [ Ui.style
            [ Style.color "white"
            , Style.textAlign "center"
            , Style.backgroundColor color
            , Style.paddingTop 5
            , Style.paddingBottom 5
            , Style.width 60
            ]
        , onPress msg
        ]
        [ Ui.string content ]
