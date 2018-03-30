module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Style exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ h2 [] [ text model.topic ]
            , button [ onClick GetNewGif ] [ text "get new gif" ]
            , input [ onInput ChangeTopic ] []
            , button [ onClick ToggleMerge ] [ text (toggleButtonMsg model) ]
            ]
        , div [] (displayAllGif model)
        ]


toggleButtonMsg : Model -> String
toggleButtonMsg model =
    case model.inMerging of
        True ->
            "merge them!"

        False ->
            "merge mode"


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
            div [ style [ display inlineBlock ] ]
                [ img
                    [ src u.url
                    , onClick (clickFunc i)
                    ]
                    []
                , div [] [ text u.topic ]
                ]
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
