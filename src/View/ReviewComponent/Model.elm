module View.ReviewComponent.Model exposing (..)

import Model.Review exposing (Review, Describe, Point, validation, setId)
import Model.Movie exposing (Movie, ID)


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

        EditPoint point ->
            model.movieId
                |> Maybe.map (\movieId -> { model | editingReview = Review movieId point model.editingReview.describe })
                |> Maybe.withDefault model
                |> (\model -> model ! [])

        SubmitReview id review ->
            model ! []

        NoMsg ->
            model ! []


initialModel : ID -> Model
initialModel id =
    Model (Just id) (Review id 0 "") Nothing


init : Model
init =
    Model Nothing (Review "" 0 "") Nothing
