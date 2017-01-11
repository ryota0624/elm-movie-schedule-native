module View.ReviewComponent exposing (..)

import Model.Review exposing (Review, Describe, Point)
import Model.Movie exposing (Movie, ID)
import NativeUi as Ui
import NativeUi.Elements as Elements exposing (text, slider, textInput)
import NativeUi.Events exposing (onPress, onSlidingComplete, onChangeText)
import NativeUi.Properties as Properties exposing (multiline, valueString, valueFloat)
import NativeUi.Style as Style exposing (defaultTransform)
import Model.Review exposing (Review, Describe, Point, validation)


type alias Validation =
    Maybe String


type alias Model =
    { movieId : Maybe ID
    , editingReview : Review
    , valid : Validation
    }


type Msg
    = EditDescribe Describe
    | EditPoint Point
    | SubmitReview ID Review
    | NoMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditDescribe describe ->
            model.movieId
                |> Maybe.map (\movieId -> { model | editingReview = Review movieId model.editingReview.point describe })
                |> Maybe.withDefault model
                |> (\model -> model ! [])
                |> Debug.log "desc"

        EditPoint point ->
            model.movieId
                |> Maybe.map (\movieId -> { model | editingReview = Review movieId point model.editingReview.describe })
                |> Maybe.withDefault model
                |> (\model -> model ! [])

        SubmitReview id review ->
            model ! []

        _ ->
            model ! []


initialModel : ID -> Model
initialModel id =
    Model (Just id) (Review id 0 "") Nothing


init : Model
init =
    Model Nothing (Review "" 0 "") Nothing


view : Model -> Ui.Node Msg
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


reviewPointView : Model -> Ui.Node Msg
reviewPointView model =
    Elements.view
        []
        [ slider [ valueFloat ((toFloat model.editingReview.point) / 100), onSlidingComplete (((*) 100) >> floor >> EditPoint) ] [] ]


reviewDescribeView : Model -> Ui.Node Msg
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
            , onChangeText (EditDescribe)
            ]
            []
        ]


reviewSubmitView : Model -> Ui.Node Msg
reviewSubmitView { movieId, editingReview } =
    let
        submitEvent =
            movieId
                |> Maybe.map (\movieId -> SubmitReview movieId editingReview)
                |> Maybe.withDefault NoMsg
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
                                    [ Ui.string "保存"
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
