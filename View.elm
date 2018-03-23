module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ h2 [] [ text model.topic ]
            , button [ onClick GetNewGif ] [ text "get new gif" ]
            , input [ onInput ChangeTopic ] []
            ]
        , div [] (displayAllGif model.gifUrl)
        ]


displayAllGif : List String -> List (Html Msg)
displayAllGif urls =
    List.map (\u -> img [ src u ] []) urls


type alias Model =
    { topic : String
    , gifUrl : List String
    , waitingUrl : String
    }

type Msg
    = GetNewGif
    | ReceiveNewGif (Result Http.Error String)
    | ChangeTopic String
    | GetWaitingGif
    | ReceiveWaitingGif (Result Http.Error String)

