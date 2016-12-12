module Navigation.ReviewScene exposing (..)

import Model.Review exposing (Review)
import Model.Movie exposing (Movie, ID)
import View.ReviewComponent.Model as ReviewComponent exposing (init)


type alias Model =
    { movie : Maybe Movie
    , review : Review
    , reviewComponent : ReviewComponent.Model
    }


initialReviewSceneModel : Model
initialReviewSceneModel =
    Model Nothing (Review "" 0 "") init


type alias Msg =
    ReviewComponent.Msg


setReview : Review -> Model -> Model
setReview review model =
    let
        reviewComponent =
            model.reviewComponent

        updatedReviewComponent =
            { reviewComponent | editingReview = review }
    in
        { model | reviewComponent = updatedReviewComponent }


setMovie : Movie -> Model -> Model
setMovie movie model =
    let
        reviewComponent =
            model.reviewComponent

        updatedReviewComponent =
            { reviewComponent | movieId = Just movie.id }
    in
        { model | movie = Just movie, reviewComponent = updatedReviewComponent }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( reviewComponent, cmd ) =
            ReviewComponent.update msg model.reviewComponent
    in
        { model | reviewComponent = reviewComponent } ! [ cmd ]
