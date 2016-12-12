module Update.Review exposing (initialModel, update, Msg(..), Model)

import Model.Review exposing (Review)
import Dict


type Msg
    = StoreReview Review
    | NoMsg


type alias Model =
    Dict.Dict String Review


initialModel : Dict.Dict String Review
initialModel =
    Dict.empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StoreReview review ->
            model
                |> Dict.insert review.movieId review
                |> (\model -> model ! [])
                |> Debug.log "update review"

        NoMsg ->
            model ! []
