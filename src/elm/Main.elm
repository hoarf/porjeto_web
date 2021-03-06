module Main exposing (..)

import EmailInput
import Html exposing (..)
import Http exposing (Response)
import Json.Decode as Decode
import Material
import Model exposing (..)
import Msg exposing (..)
import Navigation exposing (Location)
import Route exposing (..)
import Types exposing (..)
import Views.Model exposing (..)


-- APP


main : Program () Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = \m -> Sub.none
        }



-- INIT


init : flags -> Location -> ( Model, Cmd Msg )
init flags location =
    setRoute (Just HomeRoute)
        (Init
            { mdl = Material.model
            , pageState = Loaded HomePage
            , email = EmailInput.default ""
            }
        )



-- UPDATE


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        QuestionnaireRetrieveResult (Ok questionnaire) ->
            Model.toAnswering model questionnaire ! []

        QuestionnaireRetrieveResult (Err error) ->
            Error (decodeError error) ! []

        EvaluationCreateResult (Ok evaluation) ->
            Model.toLoadingQuestionnaire model evaluation

        EvaluationCreateResult (Err error) ->
            Error (decodeError error) ! []

        EvaluationUpdateResult (Ok evaluation) ->
            Model.toDone model

        EvaluationUpdateResult (Err error) ->
            Error (decodeError error) ! []

        NextQuestion answer ->
            Model.nextQuestion model answer

        PreviousQuestion answer ->
            Model.previousQuestion model answer

        BeginQuestionnaire ->
            Model.toLoadingEval model

        FinishQuestionnaire ->
            Model.toFinished model

        Mdl message_ ->
            Model.updateMdl model message_

        UserChanged email ->
            Model.updateEmail model email ! []

        UpdateAnswer ix value ->
            Model.updateAnswer model ix value ! []

        AnswerUpdateResult (Err error) ->
            Error (decodeError error) ! []

        AnswerUpdateResult (Ok _) ->
            model ! []

        SetRoute route ->
            setRoute route model



-- VIEW


view : Model -> Html Msg.Msg
view model =
    main_ []
        [ Views.Model.title model
        , Views.Model.content model
        , Views.Model.actions model
        ]


decodeError : Http.Error -> String
decodeError error =
    let
        err =
            toString error
    in
    case error of
        Http.BadStatus response ->
            parseError response.body

        _ ->
            "Something went wrong: " ++ err


parseError : String -> String
parseError body =
    case Decode.decodeString (Decode.field "message" Decode.string) body of
        Ok value ->
            value

        Err error ->
            "Invalid Response."
