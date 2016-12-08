module Navigation.Navigator exposing (initialModel, Model, Msg(..), update)

import Navigation.Scene as Scene


type alias Model =
    { page : Scene.Scene
    , history : List Scene.Scene
    }


initialModel : Model
initialModel =
    { page = Scene.SchedulePage
    , history = []
    }


type Msg
    = Back
    | Scene Scene.Scene


update : Msg -> Model -> Model
update msg model =
    case msg of
        Back ->
            model.history
                |> List.head
                |> Maybe.map (\scene -> Model scene (model.history |> List.drop 1))
                |> Maybe.withDefault model

        Scene navigationMsg ->
            { model | page = navigationMsg, history = [ model.page ] ++ model.history }
