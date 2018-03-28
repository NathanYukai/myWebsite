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
            , button [ onClick ToggleMerge ] []
            ]
        , div [] (displayAllGif model)
        ]


displayAllGif : Model -> List (Html Msg)
displayAllGif model =
    let
        idxs =
            List.range 0 (List.length model.gifs)

        clickFunc i =
            case model.inMerging of
                True ->
                    ToggleGifSelect i

                False ->
                    ChangeGif i
    in
    List.map2
        (\u i ->
            img
                [ src u.url
                , onClick (clickFunc i)
                ]
                []
        )
        model.gifs
        idxs


type alias GIF =
    { url : String
    , topic : String
    , selected : Bool
    }


type alias Model =
    { topic : String
    , gifs : List GIF
    , waitingUrl : String
    , inMerging : Bool
    }


type Msg
    = GetNewGif
    | ReceiveNewGif String (Result Http.Error String)
    | ChangeTopic String
    | GetWaitingGif
    | ReceiveWaitingGif (Result Http.Error String)
    | ChangeGif Int
    | ReceiveChangeGif Int String (Result Http.Error String)
    | ToggleMerge
    | ToggleGifSelect Int
