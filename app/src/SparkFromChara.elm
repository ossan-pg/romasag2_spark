module SparkFromChara exposing (Model, Msg(..), SelectedWeaponTypes, WeaponType(..), main, view)

import Browser
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { selectedWeaponTypes : SelectedWeaponTypes
    }


type alias SelectedWeaponTypes =
    { sword : Bool
    , greatSword : Bool
    , axe : Bool
    , mace : Bool
    , spear : Bool
    , shortSword : Bool
    , bow : Bool
    , martialSkill : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model initSelectedWeaponTypes
    , Cmd.none
    )


initSelectedWeaponTypes : SelectedWeaponTypes
initSelectedWeaponTypes =
    { sword = False
    , greatSword = False
    , axe = False
    , mace = False
    , spear = False
    , shortSword = False
    , bow = False
    , martialSkill = False
    }



-- UPDATE


type Msg
    = ChangeWeaponType WeaponType


type WeaponType
    = Sword -- 剣
    | GreatSword -- 大剣
    | Axe -- 斧
    | Mace -- 棍棒
    | Spear -- 槍
    | ShortSword -- 小剣
    | Bow -- 弓
    | MartialSkill -- 体術


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeWeaponType weaponType ->
            ( { model | selectedWeaponTypes = invertSelected weaponType model.selectedWeaponTypes }
            , Cmd.none
            )


invertSelected : WeaponType -> SelectedWeaponTypes -> SelectedWeaponTypes
invertSelected weaponType selected =
    case weaponType of
        Sword ->
            { selected | sword = not selected.sword }

        GreatSword ->
            { selected | greatSword = not selected.greatSword }

        Axe ->
            { selected | axe = not selected.axe }

        Mace ->
            { selected | mace = not selected.mace }

        Spear ->
            { selected | spear = not selected.spear }

        ShortSword ->
            { selected | shortSword = not selected.shortSword }

        Bow ->
            { selected | bow = not selected.bow }

        MartialSkill ->
            { selected | martialSkill = not selected.martialSkill }



-- VIEW


view : Model -> Html Msg
view { selectedWeaponTypes } =
    div [ Attrs.class "main" ]
        [ div [ Attrs.class "chara-classes-outer" ]
            [ div [] [ text "クラス" ]
            , select [ Attrs.class "chara-classes", Attrs.size 8 ] <|
                List.repeat 16 <|
                    option [ Attrs.value "Todo" ] [ text "インペリアルガード(男)" ]
            ]
        , div [ Attrs.class "charas-outer" ]
            [ div [] [ text "キャラクター" ]
            , select [ Attrs.class "charas", Attrs.size 8 ] <|
                List.repeat 8 <|
                    option [ Attrs.value "Todo" ] [ text "ワレンシュタイン" ]
            ]
        , div [ Attrs.class "wazas-outer" ]
            [ div [] [ text "閃き可能な技" ]
            , div [ Attrs.class "weapon-type-filter" ]
                [ div []
                    [ filterButton Sword "剣" selectedWeaponTypes.sword
                    , filterButton GreatSword "大剣" selectedWeaponTypes.greatSword
                    , filterButton Axe "斧" selectedWeaponTypes.axe
                    , filterButton Mace "棍棒" selectedWeaponTypes.mace
                    ]
                , div []
                    [ filterButton Spear "槍" selectedWeaponTypes.spear
                    , filterButton ShortSword "小剣" selectedWeaponTypes.shortSword
                    , filterButton Bow "弓" selectedWeaponTypes.bow
                    , filterButton MartialSkill "体術" selectedWeaponTypes.martialSkill
                    ]
                ]
            , select [ Attrs.class "wazas", Attrs.size 8 ] <|
                List.repeat 16 <|
                    option [ Attrs.value "Todo" ] [ text "シャッタースタッフ(攻撃)" ]
            ]
        , div [ Attrs.class "spark-rates-outer" ] <|
            List.concat <|
                List.repeat 3 <|
                    [ div [] [ text "派生元：シャッタースタッフ(回復)" ]
                    , table [ Attrs.class "spark-rates" ] <|
                        tr []
                            [ th [ Attrs.class "spark-rate" ] [ text "閃き率" ]
                            , th [ Attrs.class "enemy-name" ] [ text "モンスター" ]
                            , th [ Attrs.class "enemy-type" ] [ text "種族" ]
                            , th [ Attrs.class "enemy-rank" ] [ text "ランク" ]
                            ]
                            :: (List.repeat 16 <|
                                    tr []
                                        [ td [ Attrs.class "spark-rate" ] [ text "20.0" ]
                                        , td [ Attrs.class "enemy-name" ] [ text "ヴァンパイア(女)" ]
                                        , td [ Attrs.class "enemy-type" ] [ text "ゾンビ" ]
                                        , td [ Attrs.class "enemy-rank" ] [ text "15" ]
                                        ]
                               )
                    ]
        ]


onChange : (String -> msg) -> Attribute msg
onChange handler =
    Events.on "change" (Decode.map handler Events.targetValue)


filterButton : WeaponType -> String -> Bool -> Html Msg
filterButton weaponType weaponName selected =
    button
        [ Events.onClick <| ChangeWeaponType weaponType
        , if selected then
            Attrs.class "selected"

          else
            Attrs.class "unselected"
        ]
        [ text weaponName ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
