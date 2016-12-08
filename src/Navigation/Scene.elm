module Navigation.Scene exposing (..)

import Model.Schedule as Schedule exposing (MovieValueObjectID, MovieValueObject)
import Model.Movie exposing (Movie)


type Scene
    = SchedulePage
    | MovieDetailPage MovieValueObjectID MovieValueObject
    | ReviewPage Movie
