module Views.Question exposing (..)

import Answer exposing (..)
import Html exposing (..)
import Material
import Material.List as Lists
import Material.Options as Options
import Material.Toggles as Toggles
import Msg exposing (..)
import Question exposing (..)


-- VIEWS


view : Question -> Material.Model -> Html Msg
view question mdl =
    Options.div []
        [ h3 [] [ text question.description ]
        , Lists.ul []
            [ Lists.li [] [ Lists.content [] [ checkbox_ 1 question.answer mdl question ] ]
            , Lists.li [] [ Lists.content [] [ checkbox_ 2 question.answer mdl question ] ]
            , Lists.li [] [ Lists.content [] [ checkbox_ 3 question.answer mdl question ] ]
            , Lists.li [] [ Lists.content [] [ checkbox_ 4 question.answer mdl question ] ]
            , Lists.li [] [ Lists.content [] [ checkbox_ 5 question.answer mdl question ] ]
            ]
        ]


checkbox_ : Int -> Answer -> Material.Model -> Question -> Html Msg
checkbox_ ix { values } mdl { options } =
    Toggles.checkbox Mdl
        [ ix ]
        mdl
        [ Toggles.ripple
        , Toggles.value (Answer.valueAt values (ix - 1))
        , Options.onCheck (UpdateAnswer ix)
        ]
        [ text (Question.optionAt options (ix - 1)) ]
