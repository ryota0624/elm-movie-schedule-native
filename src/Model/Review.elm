module Model.Review exposing (setId, Review, Describe, Point, validation)

import Model.Movie exposing (ID)


type alias Point =
    Int


type alias Describe =
    String


type alias Review =
    { movieId : ID
    , point : Point
    , describe : Describe
    }


setId : ID -> Review -> Review
setId id review =
    { review | movieId = id }


pointValidation : Review -> Result String Review
pointValidation review =
    if review.point > 0 then
        Ok review
    else
        Err "point err"


descriveValidation : Review -> Result String Review
descriveValidation review =
    if (review.describe |> String.length) > 0 then
        Ok review
    else
        Err "describe err"


validation : Review -> Result String Review
validation review =
    pointValidation review |> Result.andThen descriveValidation
