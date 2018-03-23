module App exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Decode
import View exposing (..)


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic [] ""
    , getWaitingGif
    )


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNewGif ->
            ( { model | gifUrl = model.waitingUrl :: model.gifUrl }, getRandomGif model.topic )

        GetWaitingGif ->
            ( model, getWaitingGif )

        ReceiveNewGif (Ok newUrl) ->
            ( { model | gifUrl = addNewGifToList newUrl  model.gifUrl }, Cmd.none )

        ReceiveNewGif (Err _) ->
            ( model, Cmd.none )

        ReceiveWaitingGif (Ok newUrl) ->
            ( { model | waitingUrl = newUrl }, Cmd.none )

        ReceiveWaitingGif (Err _) ->
            ( model, Cmd.none )

        ChangeTopic str ->
            ( { model | topic = str }, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            giphyUrl ++ "random?" ++ apiKey ++ "&tag=" ++ topic
    in
    Http.send ReceiveNewGif (Http.get url decodeGifUrl)

addNewGifToList : String -> List String -> List String
addNewGifToList s lst =
    case lst of
        [] -> []
        (l :: rest) -> s :: rest


getWaitingGif : Cmd Msg
getWaitingGif =
    let
        url =
            waitingUrl
    in
        Http.send ReceiveWaitingGif (Http.get url decodeGifUrl)

giphyUrl : String
giphyUrl =
    "https://api.giphy.com/v1/gifs/"


apiKey : String
apiKey =
    "api_key=LhH2kxvrnOiFtgADwGFwI3LwhiEzfab8"


waitingUrl : String
waitingUrl =
    giphyUrl ++ "random?" ++ apiKey ++ "&tag=" ++ "waiting"


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN

main : Program Never Model Msg
main =
    program
        { init = init "cat"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
