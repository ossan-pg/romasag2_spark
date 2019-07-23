module SparkFromChara exposing (Chara, Model, Msg(..), SelectedWeaponTypes, WeaponType(..), main, update, view)

import Browser
import Data
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events as Events
import Html.Events.Extra as EventsEx
import List.Extra as ListEx


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
    { charaClasses : List Data.CharaClass
    , allCharas : List Data.Chara
    , charas : List Chara -- 表示用の別の Chara 型 を使用する
    , selectedWeaponTypes : SelectedWeaponTypes
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


type alias Chara =
    { id : Int
    , name : String
    , sparkType : Data.SparkType
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { charaClasses = Data.charaClasses
      , allCharas = Data.charas

      -- 初期状態では帝国重装歩兵を選択した状態にする
      , charas = filterMapCharas Data.HeavyInfantry Data.charas
      , selectedWeaponTypes = initSelectedWeaponTypes
      }
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
    | SelectCharaClass Data.CharaClassType
    | SelectChara Data.SparkType


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
        SelectCharaClass charaClassType ->
            let
                newCharas =
                    filterMapCharas charaClassType model.allCharas
            in
            ( { model | charas = newCharas }, Cmd.none )

        SelectChara sparkType ->
            -- TODO 閃きタイプを基に閃ける技一覧を作成
            ( model, Cmd.none )

        ChangeWeaponType weaponType ->
            ( { model | selectedWeaponTypes = invertSelected weaponType model.selectedWeaponTypes }
            , Cmd.none
            )


{-| 閃き可能な技について、指定された武器タイプの表示 ON/OFF を切り替える
-}
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


{-| Data.Chara のリストから閃きタイプが一致するキャラクターを抽出し、Chara のリストを作成する
-}
filterMapCharas : Data.CharaClassType -> List Data.Chara -> List Chara
filterMapCharas charaClassType srcCharas =
    srcCharas
        |> List.filter (.charaClassType >> (==) charaClassType)
        |> List.map (\{ id, name, sparkType } -> Chara id name sparkType)



-- VIEW


view : Model -> Html Msg
view { charaClasses, charas, selectedWeaponTypes } =
    div [ Attrs.class "main" ]
        [ div [ Attrs.class "chara-classes-outer" ]
            [ div [] [ text "クラス" ]
            , select [ Attrs.class "chara-classes", Attrs.size 8, EventsEx.onChange <| toSelectCharaClassAction charaClasses ] <|
                List.map
                    (\{ id, name } ->
                        option [ Attrs.value <| String.fromInt id ] [ text name ]
                    )
                    charaClasses
            ]
        , div [ Attrs.class "charas-outer" ]
            [ div [] [ text "キャラクター" ]
            , select [ Attrs.class "charas", Attrs.size 8, EventsEx.onChange <| toSelectCharaAction charas ] <|
                List.map
                    (\{ id, name } ->
                        option [ Attrs.value <| String.fromInt id ] [ text name ]
                    )
                    charas
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
                List.repeat 1 <|
                    option [ Attrs.value "Todo" ] [ text "シャッタースタッフ(攻撃)" ]
            ]
        , div [ Attrs.class "nums-of-shown-records-outer" ]
            [ div [] [ text "表示件数" ]
            , select [ Attrs.class "nums-of-shown-records", Attrs.size 4 ] <|
                List.map (\n -> option [ Attrs.value n ] [ text n ]) <|
                    List.map String.fromInt [ 5, 10, 20, 30, 40, 50 ]
            ]
        , div [ Attrs.class "spark-rates-outer" ] <|
            List.concat <|
                List.repeat 1 <|
                    [ div [] [ text "派生元：シャッタースタッフ(回復)" ]
                    , table [ Attrs.class "spark-rates" ] <|
                        tr []
                            [ th [ Attrs.class "number" ] [ text "#" ]
                            , th [ Attrs.class "spark-rate" ] [ text "閃き率" ]
                            , th [ Attrs.class "enemy-name" ] [ text "モンスター" ]
                            , th [ Attrs.class "enemy-type" ] [ text "種族" ]
                            , th [ Attrs.class "enemy-rank" ] [ text "ランク" ]
                            ]
                            :: (List.repeat 16 <|
                                    tr []
                                        [ td [ Attrs.class "number" ] [ text "50" ]
                                        , td [ Attrs.class "spark-rate" ] [ text "20.0" ]
                                        , td [ Attrs.class "enemy-name" ] [ text "ヴァンパイア(女)" ]
                                        , td [ Attrs.class "enemy-type" ] [ text "ゾンビ" ]
                                        , td [ Attrs.class "enemy-rank" ] [ text "15" ]
                                        ]
                               )
                    ]
        ]


{-| クラス一覧用の change イベントハンドラを作成する
-}
toSelectCharaClassAction : List Data.CharaClass -> (String -> Msg)
toSelectCharaClassAction charaClasses =
    \targetValue ->
        let
            -- 変換失敗の場合は 0 (帝国重装歩兵)
            -- targetValue は charaClassess の各 id を変換したものなので
            -- この値が参照されることはないはず (変換に失敗しない)
            defaultId =
                0

            id_ =
                case String.toInt targetValue of
                    Just n ->
                        n

                    Nothing ->
                        defaultId

            -- 該当なしの場合は HeavyInfantry (帝国重装歩兵)
            -- charaClassess の各 id を基に targetValue を作成しているので
            -- この値が参照されることはないはず (検索対象が必ず見つかる)
            defaultCharaClass =
                Data.HeavyInfantry
        in
        charaClasses
            |> ListEx.find (.id >> (==) id_)
            |> Maybe.map .charaClassType
            |> Maybe.withDefault defaultCharaClass
            |> SelectCharaClass


{-| キャラクター一覧用の change イベントハンドラを作成する
-}
toSelectCharaAction : List Chara -> (String -> Msg)
toSelectCharaAction charas =
    \targetValue ->
        let
            -- 変換失敗の場合は 0 (帝国重装歩兵)
            -- targetValue は charas の各 id を変換したものなので
            -- この値が参照されることはないはず (変換に失敗しない)
            defaultId =
                0

            id_ =
                case String.toInt targetValue of
                    Just n ->
                        n

                    Nothing ->
                        defaultId

            -- 該当なしの場合は General
            -- 同じ charas の各 id を基に targetValue を作成しているので
            -- この値が参照されることはないはず (検索対象が必ず見つかる)
            defaultSparkType =
                Data.General
        in
        charas
            |> ListEx.find (.id >> (==) id_)
            |> Maybe.map .sparkType
            |> Maybe.withDefault defaultSparkType
            |> SelectChara


{-| 閃き可能な技一覧を武器タイプでフィルタリングするボタンを作成する
-}
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
