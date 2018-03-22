module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Http

-- MODEL

type alias Model =
    {
        topic: String
    ,   gifUrl: String
    }


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic "waiting.gif"
    , getRandomGif topic)


-- MESSAGES


type Msg
    = GetNewGif
    | ReceiveNewGif (Result Http.Error String)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [h2 [] [text model.topic]
             , button [onClick GetNewGif] [text "get new gif"]
             , br [] []
             , img[src model.gifUrl] []
             ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNewGif ->
            ( model, getRandomGif model.topic)
        ReceiveNewGif (Ok newUrl) ->
            (Model model.topic newUrl, Cmd.none)
        ReceiveNewGif (Err _) ->
            (model, Cmd.none)

getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let url = "https://api.giphy.com/v1/gifs/random?api_key=LhH2kxvrnOiFtgADwGFwI3LwhiEzfab8" ++ "&tag=cat"
    in Http.send ReceiveNewGif (Http.get url decodeGifUrl)

decodeGifUrl : Decode.Decoder String
decodeGifUrl = Decode.at ["data", "image_url"] Decode.string

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

