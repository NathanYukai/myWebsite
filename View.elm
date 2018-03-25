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
    let
        idxs =
            List.range 0 (List.length urls)
    in
    List.map2
        (\u i ->
            img
                [ src u
                , onClick (ChangeGif i)
                ]
                []
        )
        urls
        idxs


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
    | ChangeGif Int
    | ReceiveChangeGif Int (Result Http.Error String)
