module Material.Button exposing
    ( Config
    , button
    , buttonConfig
    , outlinedButton
    , raisedButton
    , unelevatedButton
    )

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Html.Events


type alias Config msg =
    { variant : Variant
    , icon : Maybe String
    , trailingIcon : Bool
    , disabled : Bool
    , dense : Bool
    , additionalAttributes : List (Html.Attribute msg)
    , onClick : Maybe msg
    }


buttonConfig : Config msg
buttonConfig =
    { variant = Text
    , icon = Nothing
    , trailingIcon = False
    , disabled = False
    , dense = False
    , additionalAttributes = []
    , onClick = Nothing
    }


type Variant
    = Text
    | Raised
    | Unelevated
    | Outlined


button : Config msg -> String -> Html msg
button config label =
    Html.node "mdc-button"
        (List.filterMap identity
            [ rootCs
            , variantCs config
            , denseCs config
            , disabledAttr config
            , clickHandler config
            ]
            ++ config.additionalAttributes
        )
        (List.filterMap identity
            [ leadingIconElt config
            , labelElt label
            , trailingIconElt config
            ]
        )


raisedButton : Config msg -> String -> Html msg
raisedButton config label =
    button { config | variant = Raised } label


unelevatedButton : Config msg -> String -> Html msg
unelevatedButton config label =
    button { config | variant = Unelevated } label


outlinedButton : Config msg -> String -> Html msg
outlinedButton config label =
    button { config | variant = Outlined } label


rootCs : Maybe (Html.Attribute msg)
rootCs =
    Just (class "mdc-button")


disabledAttr : Config msg -> Maybe (Html.Attribute msg)
disabledAttr { disabled } =
    Just (Html.Attributes.disabled disabled)


clickHandler : Config msg -> Maybe (Html.Attribute msg)
clickHandler { onClick } =
    Maybe.map Html.Events.onClick onClick


variantCs : Config msg -> Maybe (Html.Attribute msg)
variantCs { variant } =
    case variant of
        Text ->
            Nothing

        Raised ->
            Just (class "mdc-button--raised")

        Unelevated ->
            Just (class "mdc-button--unelevated")

        Outlined ->
            Just (class "mdc-button--outlined")


denseCs : Config msg -> Maybe (Html.Attribute msg)
denseCs { dense } =
    if dense then
        Just (class "mdc-button--dense")

    else
        Nothing


iconElt : Config msg -> Maybe (Html msg)
iconElt { icon } =
    Maybe.map
        (\iconName ->
            Html.i
                [ class "mdc-button__icon material-icons"
                , Html.Attributes.attribute "aria-hidden" "true"
                ]
                [ text iconName ]
        )
        icon


leadingIconElt : Config msg -> Maybe (Html msg)
leadingIconElt config =
    if not config.trailingIcon then
        iconElt config

    else
        Nothing


trailingIconElt : Config msg -> Maybe (Html msg)
trailingIconElt config =
    if config.trailingIcon then
        iconElt config

    else
        Nothing


labelElt : String -> Maybe (Html msg)
labelElt label =
    Just (Html.span [ class "mdc-button__label" ] [ text label ])
