module SparkFromChara exposing (Chara, Model, Msg(..), main, update, view)

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
    , charaIndex : Maybe Int
    , sparkType : Maybe Data.SparkTypeSymbol
    , weaponType : Data.WeaponTypeSymbol
    , wazas : List Data.Waza
    }


type alias Chara =
    { id : Int
    , name : String
    , sparkType : Data.SparkTypeSymbol
    , index : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { charaClasses = Data.charaClasses
      , allCharas = Data.charas
      , charas = []
      , charaIndex = Nothing
      , sparkType = Nothing
      , weaponType = Data.WeaponSword -- 初期選択は剣タイプ
      , wazas = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SelectCharaClass (Maybe Data.CharaClass)
    | SelectChara (Maybe Chara)
    | SelectWeaponType Data.WeaponTypeSymbol
    | SelectWaza (Maybe Data.Waza)



-- TODO キャラクターの (クラスによる) フィルタリングは update 側で、
-- 閃き可能な技の (武器タイプによる) フィルタリングは view 側で実施しており、
-- 処理を担当する関数に一貫性がなく気持ち悪い。
-- view 側でフィルタリングするように統一したいが、一旦全ての機能を実装することを
-- 優先する。
-- ちなみに update 側でフィルタリングするようにすると、処理が複雑化するため
-- こちらは避ける。


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCharaClass maybeCharaClass ->
            case maybeCharaClass of
                Just charaClass ->
                    let
                        newCharas =
                            filterMapCharas charaClass model.allCharas

                        charaIndex_ =
                            Maybe.withDefault -1 model.charaIndex

                        -- キャラクター一覧で選択中のキャラクターと
                        -- 同じ位置のキャラクターを選択している状態にする
                        msg_ =
                            SelectChara <| ListEx.getAt charaIndex_ newCharas
                    in
                    ( update msg_ { model | charas = newCharas } |> Tuple.first
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | charas = [] }, Cmd.none )

        SelectChara maybeChara ->
            case maybeChara of
                Just chara ->
                    ( { model
                        | charaIndex = Just chara.index
                        , sparkType = Just chara.sparkType
                        , wazas = Data.sparkTypeToWazas chara.sparkType
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | sparkType = Nothing, wazas = [] }, Cmd.none )

        SelectWeaponType weaponType ->
            ( { model | weaponType = weaponType }
            , Cmd.none
            )

        SelectWaza maybeWaza ->
            -- TODO 技選択時の動作を書く
            ( model, Cmd.none )


{-| Data.Chara のリストからクラスが一致するキャラクターを抽出し、Chara のリストを作成する
-}
filterMapCharas : Data.CharaClass -> List Data.Chara -> List Chara
filterMapCharas { charaClassType } srcCharas =
    srcCharas
        |> List.filter (.charaClassType >> (==) charaClassType)
        |> List.indexedMap
            (\index { id, name, sparkType } ->
                Chara id name sparkType index
            )



-- VIEW


view : Model -> Html Msg
view { charaClasses, charas, sparkType, weaponType, wazas } =
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
                if List.isEmpty charas then
                    -- キャラクターのリストが空＝クラス未選択の状態。
                    -- option がなかったり文字列が半角文字や全角空白で
                    -- 構成されていたりするとセレクトボックスの高さが低くなる。
                    -- 機能的には何も問題ないが見た目が気になるので、
                    -- これを防止するために全角の文字列を表示する。
                    [ option [ Attrs.disabled True ] [ text "クラス未選択" ]
                    ]

                else
                    List.map
                        (\{ id, name } ->
                            option [ Attrs.value <| String.fromInt id ] [ text name ]
                        )
                        charas
            ]
        , div [ Attrs.class "wazas-outer" ]
            [ div []
                [ text <|
                    case sparkType of
                        Just sparkType_ ->
                            "閃き可能な技【"
                                ++ Data.sparkTypeToName sparkType_
                                ++ "】"

                        Nothing ->
                            "閃き可能な技"
                ]
            , div [ Attrs.class "weapon-type-filter" ]
                [ div []
                    [ selectButton weaponType Data.WeaponSword "剣"
                    , selectButton weaponType Data.WeaponGreatSword "大剣"
                    , selectButton weaponType Data.WeaponAxe "斧"
                    , selectButton weaponType Data.WeaponMace "棍棒"
                    ]
                , div []
                    [ selectButton weaponType Data.WeaponSpear "槍"
                    , selectButton weaponType Data.WeaponShortSword "小剣"
                    , selectButton weaponType Data.WeaponBow "弓"
                    , selectButton weaponType Data.WeaponMartialSkill "体術"
                    ]
                ]
            , select [ Attrs.class "wazas", Attrs.size 8, EventsEx.onChange <| toSelectWazaAction wazas ] <|
                if List.isEmpty wazas then
                    [ option [ Attrs.disabled True ] [ text "キャラクター未選択" ]
                    ]

                else
                    wazas
                        |> List.filter (.weaponType >> (==) weaponType)
                        |> List.map
                            (\{ id, name } ->
                                option [ Attrs.value <| String.fromInt id ] [ text name ]
                            )
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
                            :: (List.repeat 1 <|
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
toSelectCharaAction : List Chara -> (String -> Msg)
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
            |> ListEx.find (.id >> (==) id_)
            |> SelectChara


{-| 閃き可能な技一覧用の change イベントハンドラを作成する
-}
toSelectWazaAction : List Data.Waza -> (String -> Msg)
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
            |> ListEx.find (.id >> (==) id_)
            |> SelectWaza


{-| 閃き可能な技一覧の武器タイプを選択するボタンを作成する
-}
selectButton : Data.WeaponTypeSymbol -> Data.WeaponTypeSymbol -> String -> Html Msg
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
