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
        , div [] (displayAllGif model.gifs)
        ]


displayAllGif : List GIF -> List (Html Msg)
displayAllGif gifs =
    let
        idxs =
            List.range 0 (List.length gifs)
    in
    List.map2
        (\u i ->
            img
                [ src u.url
                , onClick (ChangeGif i)
                ]
                []
        )
        gifs
        idxs


type alias GIF =
    { url : String
    , topic : String
    }


type alias Model =
    { topic : String
    , gifs : List GIF
    , waitingUrl : String
    }


type Msg
    = GetNewGif
    | ReceiveNewGif String (Result Http.Error String)
    | ChangeTopic String
    | GetWaitingGif
    | ReceiveWaitingGif (Result Http.Error String)
    | ChangeGif Int
    | ReceiveChangeGif Int String (Result Http.Error String)
