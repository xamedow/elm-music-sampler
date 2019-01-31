module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List.Extra exposing (setAt)



-- MODEL


type alias Model =
    { ticks : List Bool
    }


initialModel : Model
initialModel =
    { ticks = [ False, False, False, False, False, False, False, False ]
    }



-- UPDATE


type alias Msg =
    { description : String
    , data : { idx : Int, value : Bool }
    }


update : Msg -> Model -> Model
update msg model =
    if msg.description == "ClickedTick" then
        let
            nextTicks =
                setAt msg.data.idx msg.data.value model.ticks
        in
        { model | ticks = nextTicks }

    else
        model



-- VIEW


viewHeader : Html Msg
viewHeader =
    header [ class "header" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "Elm music sampler" ]
            , p [] [ text "Main motto." ]
            ]
        ]


viewTick : Int -> Bool -> Html Msg
viewTick idx isActive =
    let
        className =
            if isActive then
                "tick-active"

            else
                "tick-default"
    in
    input
        [ checked isActive
        , type_ "checkbox"
        , class ("tick " ++ className)
        , onClick { description = "ClickedTick", data = { idx = idx, value = not isActive } }
        ]
        []


viewTicks : Model -> Html Msg
viewTicks model =
    div [ class "ticks-list" ] (List.indexedMap viewTick model.ticks)


view : Model -> Html Msg
view model =
    let
        activeTicksCount =
            String.fromInt (List.length (List.filter (\x -> x) model.ticks))
    in
    div [ class "home-page" ]
        [ viewHeader
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ] []
                , div [ class "col-md-3" ]
                    [ div [ class "sidebar" ]
                        [ p [] [ text ("Active ticks: " ++ activeTicksCount) ]
                        , viewTicks model
                        ]
                    ]
                ]
            ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
