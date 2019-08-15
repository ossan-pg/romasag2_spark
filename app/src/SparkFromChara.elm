module SparkFromChara exposing (IndexedChara, IndexedWaza, Model, Msg(..), WazaEnemies, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events as Events
import Html.Events.Extra as EventsEx
import List.Extra as ListEx
import Repository as Repos


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
    { charaClasses : List Repos.CharaClass
    , charas : List IndexedChara
    , charaIndex : Maybe Int
    , sparkType : Maybe Repos.SparkTypeSymbol
    , weaponType : Repos.WeaponTypeSymbol
    , wazas : List IndexedWaza
    , wazaIndex : Maybe Int
    , numOfShownEnemies : Int
    , allWazaEnemies : List WazaEnemies
    }


type alias IndexedChara =
    { index : Int
    , chara : Repos.Chara
    }


type alias IndexedWaza =
    { index : Int
    , waza : Repos.Waza
    }


{-| 派生元の技と、閃き可能な技レベルの敵およびその敵に対する閃き率の一覧
-}
type alias WazaEnemies =
    { fromWaza : Repos.Waza
    , enemies : List Repos.EnemyWithSparkRate
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { charaClasses = Repos.charaClasses
      , charas = []
      , charaIndex = Nothing
      , sparkType = Nothing
      , weaponType = Repos.WeaponSword -- 初期選択は剣タイプ
      , wazas = []
      , wazaIndex = Nothing
      , numOfShownEnemies = 10
      , allWazaEnemies = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SelectCharaClass (Maybe Repos.CharaClass)
    | SelectChara (Maybe IndexedChara)
    | SelectWeaponType Repos.WeaponTypeSymbol
    | SelectWaza (Maybe IndexedWaza)
    | SelectNumOfShownEnemies Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCharaClass maybeCharaClass ->
            case maybeCharaClass of
                Just charaClass ->
                    let
                        newCharas =
                            Repos.findCharas charaClass
                                |> List.indexedMap IndexedChara

                        charaIndex_ =
                            Maybe.withDefault -1 model.charaIndex

                        -- キャラクター一覧で選択中のキャラクターと
                        -- 同じ位置のキャラクターを選択している状態にする
                        msg_ =
                            SelectChara <| ListEx.getAt charaIndex_ newCharas
                    in
                    update msg_ { model | charas = newCharas }

                Nothing ->
                    update (SelectChara Nothing) { model | charas = [] }

        SelectChara maybeChara ->
            case maybeChara of
                Just { index, chara } ->
                    let
                        newWazas =
                            Repos.findWazas chara.sparkType
                                |> List.filter
                                    (.weaponType >> (==) model.weaponType)
                                |> List.indexedMap IndexedWaza

                        wazaIndex_ =
                            Maybe.withDefault -1 model.wazaIndex

                        -- 閃き可能な技一覧で選択中の技と
                        -- 同じ位置の技を選択している状態にする
                        msg_ =
                            SelectWaza <| ListEx.getAt wazaIndex_ <| newWazas
                    in
                    update msg_
                        { model
                            | charaIndex = Just index
                            , sparkType = Just chara.sparkType
                            , wazas = newWazas
                        }

                Nothing ->
                    update (SelectWaza Nothing)
                        { model
                            | charaIndex = Nothing
                            , sparkType = Nothing
                            , wazas = []
                        }

        SelectWeaponType weaponType ->
            let
                charaIndex_ =
                    Maybe.withDefault -1 model.charaIndex

                msg_ =
                    SelectChara <| ListEx.getAt charaIndex_ model.charas
            in
            -- 武器タイプを変更した状態で現在のキャラクターを再度選択し、
            -- 閃き可能な技を更新する
            update msg_ { model | weaponType = weaponType }

        SelectWaza maybeWaza ->
            case maybeWaza of
                Just { index, waza } ->
                    let
                        toWazaEnemies : Repos.FromWaza -> WazaEnemies
                        toWazaEnemies { fromWaza, sparkLevel } =
                            WazaEnemies fromWaza <|
                                List.take model.numOfShownEnemies <|
                                    Repos.findEnemiesForSpark sparkLevel

                        allWazaEnemies_ =
                            Repos.findWazaDerivations waza
                                |> .fromWazas
                                |> List.map toWazaEnemies
                    in
                    ( { model
                        | wazaIndex = Just index
                        , allWazaEnemies = allWazaEnemies_
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model
                        | wazaIndex = Nothing
                        , allWazaEnemies = []
                      }
                    , Cmd.none
                    )

        SelectNumOfShownEnemies n ->
            let
                wazaIndex_ =
                    Maybe.withDefault -1 model.wazaIndex

                msg_ =
                    SelectWaza <| ListEx.getAt wazaIndex_ model.wazas
            in
            -- 表示件数を変更した状態で現在の閃き可能な技を再度選択し、
            -- 敵一覧を更新する
            update msg_ { model | numOfShownEnemies = n }



-- VIEW


view : Model -> Html Msg
view model =
    div [ Attrs.class "main" ]
        [ viewCharaClasses model
        , viewCharas model
        , viewWazas model
        , viewNumsOfShownEnemies model
        , viewWazaEnemies model
        ]


viewCharaClasses : Model -> Html Msg
viewCharaClasses { charaClasses } =
    section [ Attrs.class "chara-classes-outer" ]
        [ div [] [ text "クラス" ]
        , select [ Attrs.class "chara-classes", Attrs.size 8, EventsEx.onChange <| toSelectCharaClassAction charaClasses ] <|
            List.map
                (\{ id, name } ->
                    option [ Attrs.value <| String.fromInt id ] [ text name ]
                )
                charaClasses
        ]


viewCharas : Model -> Html Msg
viewCharas { charas } =
    section [ Attrs.class "charas-outer" ]
        [ div [] [ text "キャラクター" ]
        , select [ Attrs.class "charas", Attrs.size 8, EventsEx.onChange <| toSelectCharaAction charas ] <|
            if List.isEmpty charas then
                -- キャラクターのリストが空＝クラス未選択の状態。
                -- option がなかったり文字列が半角文字や全角空白で
                -- 構成されていたりするとセレクトボックスの高さが低くなる。
                -- 機能的には何も問題ないが見た目が気になるので、
                -- これを防止するために全角の文字列を表示する。
                [ option [ Attrs.disabled True ] [ text "クラス未選択" ]
                ]

            else
                charas
                    |> List.map .chara
                    |> List.map
                        (\{ id, name } ->
                            option [ Attrs.value <| String.fromInt id ] [ text name ]
                        )
        ]


sparkTypeToDisplayName : Repos.SparkTypeSymbol -> String
sparkTypeToDisplayName symbol =
    case symbol of
        Repos.SparkSword1 ->
            "剣1"

        Repos.SparkSword2 ->
            "剣2"

        Repos.SparkGreatSword1 ->
            "大剣1"

        Repos.SparkGreatSword2 ->
            "大剣2"

        Repos.SparkAxe ->
            "斧"

        Repos.SparkSpearAxe ->
            "槍斧"

        Repos.SparkMace ->
            "棍棒"

        Repos.SparkSpear ->
            "槍"

        Repos.SparkShortSword ->
            "小剣"

        Repos.SparkBow ->
            "弓"

        Repos.SparkMartialSkill1 ->
            "体術1"

        Repos.SparkMartialSkill2 ->
            "体術2"

        Repos.SparkGeneral ->
            "汎用"

        Repos.SparkSpell ->
            "術"

        Repos.SparkNothing ->
            "なし"


viewWazas : Model -> Html Msg
viewWazas { sparkType, weaponType, wazas } =
    section [ Attrs.class "wazas-outer" ]
        [ div []
            [ text <|
                case sparkType of
                    Just sparkType_ ->
                        "閃き可能な技【"
                            ++ sparkTypeToDisplayName sparkType_
                            ++ "】"

                    Nothing ->
                        "閃き可能な技"
            ]
        , div [ Attrs.class "weapon-type-filter" ]
            [ div []
                [ selectButton weaponType Repos.WeaponSword "剣"
                , selectButton weaponType Repos.WeaponGreatSword "大剣"
                , selectButton weaponType Repos.WeaponAxe "斧"
                , selectButton weaponType Repos.WeaponMace "棍棒"
                ]
            , div []
                [ selectButton weaponType Repos.WeaponSpear "槍"
                , selectButton weaponType Repos.WeaponShortSword "小剣"
                , selectButton weaponType Repos.WeaponBow "弓"
                , selectButton weaponType Repos.WeaponMartialSkill "体術"
                ]
            ]
        , select [ Attrs.class "wazas", Attrs.size 8, EventsEx.onChange <| toSelectWazaAction wazas ] <|
            if List.isEmpty wazas then
                [ option [ Attrs.disabled True ] [ text "キャラクター未選択" ]
                ]

            else
                wazas
                    |> List.map .waza
                    |> List.map
                        (\{ id, name } ->
                            option [ Attrs.value <| String.fromInt id ] [ text name ]
                        )
        ]


viewNumsOfShownEnemies : Model -> Html Msg
viewNumsOfShownEnemies { numOfShownEnemies } =
    let
        nums =
            [ 10, 15, 20, 30, 40, 50 ]

        defaultNum =
            10

        toMsg : Int -> Msg
        toMsg =
            \value ->
                nums
                    |> ListEx.find ((==) value)
                    |> Maybe.withDefault defaultNum
                    |> SelectNumOfShownEnemies
    in
    section [ Attrs.class "nums-of-shown-enemies-outer" ]
        [ div [] [ text "表示件数" ]
        , select
            [ Attrs.class "nums-of-shown-enemies"
            , Attrs.size 6
            , EventsEx.onChange <| toChangeAction defaultNum toMsg
            ]
          <|
            List.map
                (\num ->
                    let
                        strNum =
                            String.fromInt num
                    in
                    option
                        [ Attrs.selected <| num == numOfShownEnemies
                        , Attrs.value strNum
                        ]
                        [ text strNum ]
                )
            <|
                nums
        ]


viewWazaEnemies : Model -> Html Msg
viewWazaEnemies { allWazaEnemies } =
    section [ Attrs.class "waza-enemies-outer" ] <|
        List.concatMap
            (\{ fromWaza, enemies } ->
                [ section [] [ text <| "派生元：" ++ fromWaza.name ]
                , table [ Attrs.class "waza-enemies" ] <|
                    tr []
                        [ th [ Attrs.class "number" ] [ text "#" ]
                        , th [ Attrs.class "spark-rate" ] [ text "閃き率" ]
                        , th [ Attrs.class "enemy-name" ] [ text "モンスター" ]
                        , th [ Attrs.class "enemy-type" ] [ text "種族" ]
                        , th [ Attrs.class "enemy-rank" ] [ text "ランク" ]
                        ]
                        :: List.indexedMap
                            (\index { sparkRate, enemy } ->
                                tr []
                                    [ td [ Attrs.class "number" ] [ text <| String.fromInt <| index + 1 ]
                                    , td [ Attrs.class "spark-rate" ] [ text <| String.fromFloat sparkRate ]
                                    , td [ Attrs.class "enemy-name" ] [ text enemy.name ]
                                    , td [ Attrs.class "enemy-type" ] [ text <| Repos.enemyTypeToName enemy.enemyType ]
                                    , td [ Attrs.class "enemy-rank" ] [ text <| String.fromInt enemy.rank ]
                                    ]
                            )
                            enemies
                ]
            )
            allWazaEnemies


{-| クラス一覧用の change イベントハンドラを作成する
-}
toSelectCharaClassAction : List Repos.CharaClass -> (String -> Msg)
toSelectCharaClassAction charaClasses =
    \targetValue ->
        let
            -- 変換失敗の場合は -1 (該当クラスなし)
            -- targetValue は charaClassess の各 id を変換したものなので
            -- この値が参照されることはないはず (変換に失敗しない)
            defaultId =
                -1

            id_ =
                case String.toInt targetValue of
                    Just n ->
                        n

                    Nothing ->
                        defaultId
        in
        charaClasses
            |> ListEx.find (.id >> (==) id_)
            |> SelectCharaClass


{-| キャラクター一覧用の change イベントハンドラを作成する
-}
toSelectCharaAction : List IndexedChara -> (String -> Msg)
toSelectCharaAction charas =
    \targetValue ->
        let
            -- 変換失敗の場合は -1 (該当キャラなし)
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
        in
        charas
            |> ListEx.find (.chara >> .id >> (==) id_)
            |> SelectChara


{-| 閃き可能な技一覧用の change イベントハンドラを作成する
-}
toSelectWazaAction : List IndexedWaza -> (String -> Msg)
toSelectWazaAction wazas =
    \targetValue ->
        let
            -- 変換失敗の場合は -1 (該当キャラなし)
            -- targetValue は wazas の各 id を変換したものなので
            -- この値が参照されることはないはず (変換に失敗しない)
            defaultId =
                -1

            id_ =
                case String.toInt targetValue of
                    Just n ->
                        n

                    Nothing ->
                        defaultId
        in
        wazas
            |> ListEx.find (.waza >> .id >> (==) id_)
            |> SelectWaza


{-| 閃き可能な技一覧の武器タイプを選択するボタンを作成する
-}
selectButton : Repos.WeaponTypeSymbol -> Repos.WeaponTypeSymbol -> String -> Html Msg
selectButton checkedWeaponType weaponType weaponName =
    label []
        [ input
            [ Attrs.type_ "radio"
            , Attrs.name "weaponTypes"
            , Attrs.checked <| weaponType == checkedWeaponType
            , Events.onClick <| SelectWeaponType weaponType
            ]
            []
        , text weaponName
        ]


{-| セレクトボックスの change イベントハンドラを作成する
-}
toChangeAction : Int -> (Int -> Msg) -> (String -> Msg)
toChangeAction defaultOptionValue toMsg =
    \targetValue ->
        String.toInt targetValue
            |> Maybe.withDefault defaultOptionValue
            |> toMsg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
