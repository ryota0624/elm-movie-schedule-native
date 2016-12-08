module Update.Main exposing (..)

import Update.Schedule as ScheduleUpdate exposing (Msg(UpdateSchedule), getSchedule)
import Update.Movie as MovieUpdate exposing (Msg(StoreMovie), getMovie)


type alias Model =
    { schedule : ScheduleUpdate.Model
    , movieList : MovieUpdate.Model
    }


type Msg
    = No
    | ScheduleMsg ScheduleUpdate.Msg
    | MovieMsg MovieUpdate.Msg


initialModel : Model
initialModel =
    Model ScheduleUpdate.initialModel MovieUpdate.initialModel


initialCmd : Cmd Msg
initialCmd =
    getSchedule |> Cmd.map ScheduleMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        No ->
            model ! []

        MovieMsg movieMsg ->
            let
                ( movieList, cmd ) =
                    MovieUpdate.update movieMsg model.movieList
            in
                { model | movieList = movieList } ! [ Cmd.map MovieMsg cmd ]

        ScheduleMsg scheduleMsg ->
            let
                ( schedule, cmd ) =
                    ScheduleUpdate.update scheduleMsg model.schedule
            in
                { model | schedule = schedule } ! [ Cmd.map ScheduleMsg cmd ]
