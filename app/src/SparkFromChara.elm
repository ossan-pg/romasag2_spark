module SparkFromChara exposing (IndexedChara, Model, Msg(..), main, update, view)

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
    , wazas : List Repos.Waza
    }


type alias IndexedChara =
    { index : Int
    , chara : Repos.Chara
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { charaClasses = Repos.charaClasses
      , charas = []
      , charaIndex = Nothing
      , sparkType = Nothing
      , weaponType = Repos.WeaponSword -- 初期選択は剣タイプ
      , wazas = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SelectCharaClass (Maybe Repos.CharaClass)
    | SelectChara (Maybe IndexedChara)
    | SelectWeaponType Repos.WeaponTypeSymbol
    | SelectWaza (Maybe Repos.Waza)



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
                            Repos.findCharas charaClass
                                |> List.indexedMap IndexedChara

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
                Just { index, chara } ->
                    ( { model
                        | charaIndex = Just index
                        , sparkType = Just chara.sparkType
                        , wazas = Repos.sparkTypeToWazas chara.sparkType
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



-- VIEW


view : Model -> Html Msg
view model =
    div [ Attrs.class "main" ]
        [ viewCharaClasses model
        , viewCharas model
        , viewWazas model
        , viewNumsOfShownRecords
        , viewSparkRates model
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


viewWazas : Model -> Html Msg
viewWazas { sparkType, weaponType, wazas } =
    section [ Attrs.class "wazas-outer" ]
        [ div []
            [ text <|
                case sparkType of
                    Just sparkType_ ->
                        "閃き可能な技【"
                            ++ Repos.sparkTypeToName sparkType_
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
                    |> List.filter (.weaponType >> (==) weaponType)
                    |> List.map
                        (\{ id, name } ->
                            option [ Attrs.value <| String.fromInt id ] [ text name ]
                        )
        ]


viewNumsOfShownRecords : Html Msg
viewNumsOfShownRecords =
    section [ Attrs.class "nums-of-shown-records-outer" ]
        [ div [] [ text "表示件数" ]
        , select [ Attrs.class "nums-of-shown-records", Attrs.size 4 ] <|
            List.map (\n -> option [ Attrs.value n ] [ text n ]) <|
                List.map String.fromInt [ 5, 10, 20, 30, 40, 50 ]
        ]


viewSparkRates : Model -> Html Msg
viewSparkRates _ =
    section [ Attrs.class "spark-rates-outer" ] <|
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
toSelectWazaAction : List Repos.Waza -> (String -> Msg)
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
