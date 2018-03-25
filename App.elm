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


replaceIdx : List a -> Int -> a -> List a
replaceIdx lst idx e =
    List.take idx lst ++ [ e ] ++ List.drop (idx + 1) lst


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        replacedWithWaiting i =
            replaceIdx model.gifUrl i model.waitingUrl

        replacedWithChanged i url =
            replaceIdx model.gifUrl i url
    in
    case msg of
        GetNewGif ->
            ( { model | gifUrl = model.waitingUrl :: model.gifUrl }, getRandomGif model.topic ReceiveNewGif )

        ChangeGif i ->
            ( { model | gifUrl = replacedWithWaiting i }, getRandomGif model.topic (ReceiveChangeGif i) )

        GetWaitingGif ->
            ( model, getWaitingGif )

        ReceiveNewGif (Ok newUrl) ->
            ( { model | gifUrl = addNewGifToList newUrl model.gifUrl }, Cmd.none )

        ReceiveChangeGif idx (Ok newUrl) ->
            ( { model | gifUrl = replacedWithChanged idx newUrl }, Cmd.none )

        ReceiveWaitingGif (Ok newUrl) ->
            ( { model | waitingUrl = newUrl }, Cmd.none )

        ReceiveNewGif (Err _) ->
            ( model, Cmd.none )

        ReceiveWaitingGif (Err _) ->
            ( model, Cmd.none )

        ReceiveChangeGif idx (Err _) ->
            ( model, Cmd.none )

        ChangeTopic str ->
            ( { model | topic = str }, Cmd.none )


getRandomGif : String -> (Result.Result Http.Error String -> Msg) -> Cmd Msg
getRandomGif topic msg =
    let
        url =
            giphyUrl ++ "random?" ++ apiKey ++ "&tag=" ++ topic
    in
    Http.send msg (Http.get url decodeGifUrl)


addNewGifToList : String -> List String -> List String
addNewGifToList s lst =
    case lst of
        [] ->
            []

        l :: rest ->
            s :: rest


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
    Decode.at [ "data", "images", "fixed_height", "url" ] Decode.string



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
