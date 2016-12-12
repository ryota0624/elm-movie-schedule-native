module View.MovieDetail exposing (view)

import NativeUi as Ui
import NativeUi.Elements as Elements exposing (text)
import Model.Movie exposing (Movie)
import Model.Review exposing (Review)
import Model.Schedule exposing (MovieValueObject)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Properties as Properties
import NativeUi.Events exposing (onPress)
import Navigation.Navigator as Navigator exposing (Msg)


view : Maybe Review -> Maybe Movie -> Ui.Node Msg
view review detail =
    detail
        |> Maybe.map (viewMovie review)
        |> Maybe.withDefault
            (Elements.view []
                [ Elements.text []
                    [ Ui.string "loading..." ]
                ]
            )


viewMovie : Maybe Review -> Movie -> Ui.Node Msg
viewMovie review detail =
    let
        onPressEvent =
            Navigator.PushReviewScene detail

        reviewButton =
            review
                |> Maybe.map (\n -> "レビュー ✔︎")
                |> Maybe.withDefault ("レビュー")
                |> button onPressEvent "#d33"
    in
        Elements.view
            [ Ui.style
                [ Style.paddingLeft 20
                , Style.paddingRight 20
                , Style.paddingBottom 20
                , Style.paddingTop 20
                ]
            ]
            [ Elements.text []
                [ Ui.string detail.title ]
            , detail.base |> Maybe.map movieImage |> Maybe.withDefault (Elements.text [] [])
            , Elements.view
                [ Ui.style
                    [ Style.width 80
                    , Style.flexDirection "row"
                    , Style.justifyContent "space-between"
                    ]
                ]
                [ reviewButton
                ]
            , Elements.text
                []
                [ Ui.string detail.story
                ]
            ]


movieImage : MovieValueObject -> Ui.Node Msg
movieImage movie =
    Elements.image
        [ Ui.style
            [ Style.height 64
            , Style.width 64
            , Style.marginBottom 30
            ]
        , Properties.source <| "http://www.aeoncinema.com" ++ movie.thumbnaiUrl
        ]
        []


button : a -> String -> String -> Ui.Node a
button msg color content =
    text
        [ Ui.style
            [ Style.color "white"
            , Style.textAlign "center"
            , Style.backgroundColor color
            , Style.paddingTop 5
            , Style.paddingBottom 5
            , Style.width 100
            ]
        , onPress msg
        ]
        [ Ui.string content ]
