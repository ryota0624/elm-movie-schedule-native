module Update.Schedule exposing (Msg(..), update, getSchedule, Model, initialModel)

import Model.Schedule exposing (ScheduleModel, Schedule, decodeModelDTO, decodeSchedule, MovieValueObject)
import Http


type Msg
    = UpdateSchedule (Result Http.Error Schedule)


type alias Model =
    Maybe Schedule


initialModel : Model
initialModel =
    Maybe.Nothing


update : Msg -> Model -> ( ScheduleModel, Cmd Msg )
update msg model =
    case msg of
        UpdateSchedule result ->
            case result of
                Ok schedule ->
                    Maybe.Just schedule ! []

                Err err ->
                    model ! []


getSchedule : Cmd Msg
getSchedule =
    let
        url =
            "http://localhost:8080/schedule"
    in
        Http.send UpdateSchedule (Http.get url decodeSchedule)
