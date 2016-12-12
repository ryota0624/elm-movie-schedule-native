module Navigation.Navigator exposing (initialModel, Model, Msg(..), update, Msgs)

import NativeUi.NavigationExperimental as NE
import Model.Movie as Movie
import NativeApi.NavigationStateUtil exposing (jumpTo, pop, push)
import Model.Schedule exposing (MovieValueObject)
import Update.Main as Main exposing (Msg(MovieMsg))
import Navigation.ReviewScene as ReviewScene
import Dict


type alias Model =
    { navigator : NE.NavigationState
    , appModel : Main.Model
    , movieSceneModel : Maybe String
    , reviewSceneModel : ReviewScene.Model
    }


initialModel : Model
initialModel =
    { navigator =
        { index = 0
        , routes =
            [ { key = "schedule", title = Nothing }
              -- , { key = "reviewedList", title = Nothing }
              -- , { key = "review", title = Nothing }
            ]
        }
    , appModel = Main.initialModel
    , movieSceneModel = Nothing
    , reviewSceneModel = ReviewScene.initialReviewSceneModel
    }


type alias Msgs =
    List Msg


type Msg
    = Exit
    | Jump String
    | PushReviewedList
    | None
    | Pop
    | PushReviewScene Movie.Movie
    | PushMovieDetail MovieValueObject
    | AppMsg Main.Msg
    | CombineMsg Msgs
    | ReviewSceneMsg ReviewScene.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Jump key ->
            { model | navigator = jumpTo key model.navigator } ! []

        Pop ->
            { model | navigator = pop model.navigator } ! []

        PushReviewedList ->
            let
                route =
                    { key = "reviewed", title = Just "reviews" }
            in
                { model | navigator = push route model.navigator } ! []

        PushMovieDetail movie ->
            let
                route =
                    { key = "movie", title = Just movie.title }
            in
                { model | navigator = push route model.navigator, movieSceneModel = Just movie.id } ! []

        PushReviewScene movie ->
            let
                route =
                    { key = "review", title = Just movie.title }

                updatedReviewSceneModel =
                    ReviewScene.initialReviewSceneModel
                        |> ReviewScene.setMovie movie
                        |> \sceneModel ->
                            model.appModel.reviews
                                |> Dict.get movie.id
                                |> Maybe.map (\review -> ReviewScene.setReview review sceneModel)
                                |> Maybe.withDefault sceneModel
            in
                { model | navigator = push route model.navigator, reviewSceneModel = updatedReviewSceneModel } ! []

        AppMsg subMsg ->
            let
                ( appModel, cmd ) =
                    model.appModel |> Main.update subMsg
            in
                { model | appModel = appModel } ! [ cmd |> Cmd.map AppMsg ]

        CombineMsg messages ->
            let
                reduceMsg : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
                reduceMsg msg ( model, cmd ) =
                    let
                        ( nextModel, appendCmd ) =
                            update msg model
                    in
                        nextModel ! ([ appendCmd ] ++ [ cmd ])
            in
                messages |> List.foldr reduceMsg ( model, Cmd.none )

        ReviewSceneMsg sceneMsg ->
            let
                ( sceneModel, cmd ) =
                    ReviewScene.update sceneMsg model.reviewSceneModel
            in
                ( { model | reviewSceneModel = sceneModel }, cmd |> Cmd.map ReviewSceneMsg )

        _ ->
            model ! []
