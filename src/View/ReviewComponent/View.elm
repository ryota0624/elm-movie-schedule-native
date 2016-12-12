module View.ReviewComponent.View exposing (..)

import NativeUi as Ui
import NativeUi.Elements as Elements exposing (text, slider, textInput)
import NativeUi.Events exposing (onPress, onSlidingComplete, onChangeText)
import NativeUi.Properties as Properties exposing (multiline, valueString, valueFloat)
import NativeUi.Style as Style exposing (defaultTransform)
import Model.Review exposing (Review, Describe, Point, validation)
import Update.Review as ReviewUpdate
import Update.Main as MainUpdate
import Navigation.Navigator as Navigator exposing (Msg)
import View.ReviewComponent.Model exposing (Model, Msg(SubmitReview, EditDescribe, EditPoint, NoMsg))


wrapReviewMsg : ReviewUpdate.Msg -> Navigator.Msg
wrapReviewMsg msg =
    Navigator.AppMsg <| MainUpdate.ReviewMsg <| msg


view : Model -> Ui.Node Navigator.Msg
view model =
    Elements.view
        [ Ui.style
            [ Style.paddingLeft 20
            , Style.paddingRight 20
            , Style.paddingBottom 20
            , Style.paddingTop 20
            ]
        ]
        [ reviewDescribeView model
        , reviewPointView model
        , reviewSubmitView model
        ]


reviewPointView : Model -> Ui.Node Navigator.Msg
reviewPointView model =
    Elements.view
        []
        [ slider [ valueFloat ((toFloat model.editingReview.point) / 100), onSlidingComplete (((*) 100) >> floor >> EditPoint >> Navigator.ReviewSceneMsg) ] [] ]


reviewDescribeView : Model -> Ui.Node Navigator.Msg
reviewDescribeView { editingReview } =
    Elements.view
        []
        [ textInput
            [ Ui.style
                [ Style.height 80
                , Style.backgroundColor "white"
                , Style.flexDirection "row"
                ]
            , valueString editingReview.describe
            , multiline True
            , onChangeText (EditDescribe >> Navigator.ReviewSceneMsg)
            ]
            []
        ]


reviewSubmitView : Model -> Ui.Node Navigator.Msg
reviewSubmitView { movieId, editingReview } =
    let
        storeReviewMsg =
            movieId
                |> Maybe.map (\movieId -> ReviewUpdate.StoreReview editingReview)
                |> Maybe.withDefault ReviewUpdate.NoMsg

        submitEvent =
            (Navigator.CombineMsg [ wrapReviewMsg storeReviewMsg, Navigator.Pop ])
    in
        Elements.view
            [ Ui.style
                [ Style.alignSelf "center"
                  -- , Style.backgroundColor "white"
                , Style.paddingTop 5
                , Style.paddingBottom 8
                , Style.width 60
                ]
            ]
            [ editingReview
                |> validation
                |> (\result ->
                        case result of
                            Ok review ->
                                Elements.text
                                    [ onPress submitEvent
                                    , Ui.style
                                        [ Style.textAlign "center"
                                        , Style.backgroundColor "white"
                                        ]
                                    ]
                                    [ Ui.string "submit"
                                    ]

                            Err message ->
                                Elements.text
                                    [ Ui.style
                                        [ Style.textAlign "center"
                                        , Style.backgroundColor "red"
                                        ]
                                    ]
                                    [ Ui.string message
                                    ]
                   )
            ]
