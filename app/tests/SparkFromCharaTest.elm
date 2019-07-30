module SparkFromCharaTest exposing (suite)

import Data
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Html as H
import Html.Attributes as Attrs
import Json.Encode as Encode
import SparkFromChara exposing (..)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (classes, tag, text)


suite : Test
suite =
    describe "The SparkFromChara module"
        [ describe "update"
            -- キャラクターを設定
            [ test "クラスが指定されていない場合、空のキャラクターリストを Model に設定する" <|
                \_ ->
                    -- キャラクターリストを空以外に設定
                    { initialModel | charas = heavyInfantries }
                        |> update (SelectCharaClass Nothing)
                        |> Tuple.first
                        |> .charas
                        |> Expect.equal []
            , describe "指定されたクラスに対応するキャラクターを Model に設定する"
                [ test "「帝国重装歩兵」が指定された場合、帝国重装歩兵のキャラクターを Model に設定する" <|
                    \_ ->
                        initialModel
                            |> update (SelectCharaClass <| Just heavyInfantryClass)
                            |> Tuple.first
                            |> .charas
                            |> Expect.equal heavyInfantries
                , test "「特殊」が指定された場合、特殊キャラクターを Model に設定する" <|
                    \_ ->
                        initialModel
                            |> update (SelectCharaClass <| Just specialCharaClass)
                            |> Tuple.first
                            |> .charas
                            |> Expect.equal specialCharas
                ]

            -- 武器タイプを設定
            , describe "指定された武器タイプを Model に設定する"
                [ test "剣" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponAxe Data.WeaponSword
                , test "大剣" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponSword Data.WeaponGreatSword
                , test "斧" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponSword Data.WeaponAxe
                , test "棍棒" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponSword Data.WeaponMace
                , test "槍" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponSword Data.WeaponSpear
                , test "小剣" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponSword Data.WeaponShortSword
                , test "弓" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponSword Data.WeaponBow
                , test "体術" <|
                    \_ ->
                        verifySetWeaponTypeToModel Data.WeaponSword Data.WeaponMartialSkill
                ]
            ]
        , describe "view"
            -- クラス一覧
            [ test "クラス一覧に対し、各クラスの名前を option の要素に、ID を option の value 属性に設定する" <|
                \_ ->
                    initialModel
                        |> view
                        |> Query.fromHtml
                        |> Query.find [ tag "select", classes [ "chara-classes" ] ]
                        |> Query.contains
                            [ H.option [ Attrs.value "0" ] [ H.text "帝国重装歩兵" ]
                            , H.option [ Attrs.value "1" ] [ H.text "帝国軽装歩兵(男)" ]
                            , H.option [ Attrs.value "2" ] [ H.text "帝国軽装歩兵(女)" ]
                            , H.option [ Attrs.value "3" ] [ H.text "帝国猟兵(男)" ]
                            , H.option [ Attrs.value "4" ] [ H.text "帝国猟兵(女)" ]
                            , H.option [ Attrs.value "5" ] [ H.text "宮廷魔術師(男)" ]
                            , H.option [ Attrs.value "6" ] [ H.text "宮廷魔術師(女)" ]
                            , H.option [ Attrs.value "7" ] [ H.text "フリーファイター(男)" ]
                            , H.option [ Attrs.value "8" ] [ H.text "フリーファイター(女)" ]
                            , H.option [ Attrs.value "9" ] [ H.text "フリーメイジ(男)" ]
                            , H.option [ Attrs.value "10" ] [ H.text "フリーメイジ(女)" ]
                            , H.option [ Attrs.value "11" ] [ H.text "インペリアルガード(男)" ]
                            , H.option [ Attrs.value "12" ] [ H.text "インペリアルガード(女)" ]
                            , H.option [ Attrs.value "13" ] [ H.text "軍師" ]
                            , H.option [ Attrs.value "14" ] [ H.text "イーストガード" ]
                            , H.option [ Attrs.value "15" ] [ H.text "デザートガード" ]
                            , H.option [ Attrs.value "16" ] [ H.text "アマゾネス" ]
                            , H.option [ Attrs.value "17" ] [ H.text "ハンター" ]
                            , H.option [ Attrs.value "18" ] [ H.text "ノーマッド(男)" ]
                            , H.option [ Attrs.value "19" ] [ H.text "ノーマッド(女)" ]
                            , H.option [ Attrs.value "20" ] [ H.text "ホーリーオーダー(男)" ]
                            , H.option [ Attrs.value "21" ] [ H.text "ホーリーオーダー(女)" ]
                            , H.option [ Attrs.value "22" ] [ H.text "海女" ]
                            , H.option [ Attrs.value "23" ] [ H.text "武装商船団" ]
                            , H.option [ Attrs.value "24" ] [ H.text "サイゴ族" ]
                            , H.option [ Attrs.value "25" ] [ H.text "格闘家" ]
                            , H.option [ Attrs.value "26" ] [ H.text "シティシーフ(男)" ]
                            , H.option [ Attrs.value "27" ] [ H.text "シティシーフ(女)" ]
                            , H.option [ Attrs.value "28" ] [ H.text "サラマンダー" ]
                            , H.option [ Attrs.value "29" ] [ H.text "モール" ]
                            , H.option [ Attrs.value "30" ] [ H.text "ネレイド" ]
                            , H.option [ Attrs.value "31" ] [ H.text "イーリス" ]
                            , H.option [ Attrs.value "40" ] [ H.text "特殊" ]
                            ]

            -- クラス選択
            , test "無効なクラスが選択された場合、Nothing を SelectCharaClass に設定して送信する" <|
                \_ ->
                    -- UI 的にあり得ないはずだが、仮に起きた場合にどうなるかを
                    -- 把握するためテストしておく
                    -- 存在しないクラスID を指定する
                    verifySendMsgFromSelectBox "32" (SelectCharaClass Nothing) initialModel <|
                        Query.find [ tag "select", classes [ "chara-classes" ] ]
            , describe "クラスが選択された場合、そのクラスの値を SelectCharaClass に設定して送信する"
                [ test "帝国重装歩兵" <|
                    \_ ->
                        verifySendMsgFromSelectBox "0" (SelectCharaClass <| Just heavyInfantryClass) initialModel <|
                            Query.find [ tag "select", classes [ "chara-classes" ] ]
                , test "特殊" <|
                    \_ ->
                        verifySendMsgFromSelectBox "40" (SelectCharaClass <| Just specialCharaClass) initialModel <|
                            Query.find [ tag "select", classes [ "chara-classes" ] ]
                ]

            -- キャラクター一覧
            , test "Model にキャラクターが誰も設定されていない場合、セレクトボックスの 1項目目に「クラス未選択」を Disabld 状態で表示する" <|
                \_ ->
                    { initialModel | charas = [] }
                        |> view
                        |> Query.fromHtml
                        |> Query.find [ tag "select", classes [ "charas" ] ]
                        |> Query.contains
                            [ H.option [ Attrs.disabled True ] [ H.text "クラス未選択" ]
                            ]
            , describe "キャラクター一覧に対し、各キャラクターの名前を option の要素に、ID を option の value 属性に設定する"
                [ test "帝国重装歩兵" <|
                    \_ ->
                        { initialModel | charas = heavyInfantries }
                            |> view
                            |> Query.fromHtml
                            |> Query.find [ tag "select", classes [ "charas" ] ]
                            |> Query.contains
                                [ H.option [ Attrs.value "0" ] [ H.text "ベア" ]
                                , H.option [ Attrs.value "1" ] [ H.text "バイソン" ]
                                , H.option [ Attrs.value "2" ] [ H.text "ウォーラス" ]
                                , H.option [ Attrs.value "3" ] [ H.text "スネイル" ]
                                , H.option [ Attrs.value "4" ] [ H.text "ヘッジホッグ" ]
                                , H.option [ Attrs.value "5" ] [ H.text "トータス" ]
                                , H.option [ Attrs.value "6" ] [ H.text "ライノ" ]
                                , H.option [ Attrs.value "7" ] [ H.text "フェルディナント" ]
                                ]
                , test "特殊" <|
                    \_ ->
                        { initialModel | charas = specialCharas }
                            |> view
                            |> Query.fromHtml
                            |> Query.find [ tag "select", classes [ "charas" ] ]
                            |> Query.contains
                                [ H.option [ Attrs.value "300" ] [ H.text "レオン" ]
                                , H.option [ Attrs.value "301" ] [ H.text "ジェラール" ]
                                , H.option [ Attrs.value "302" ] [ H.text "コッペリア" ]
                                , H.option [ Attrs.value "303" ] [ H.text "最終皇帝(男)" ]
                                , H.option [ Attrs.value "304" ] [ H.text "最終皇帝(女)" ]
                                ]
                ]

            -- キャラクター選択
            , test "無効なキャラクターが選択された場合、Nothing を SelectChara に設定して送信する" <|
                \_ ->
                    -- UI 的にあり得ないはずだが、仮に起きた場合にどうなるかを
                    -- 把握するためテストしておく
                    let
                        -- キャラクター一覧は帝国重装歩兵
                        model =
                            { initialModel | charas = heavyInfantries }
                    in
                    -- 帝国重装歩兵以外のキャラクターID を指定する
                    verifySendMsgFromSelectBox "8" (SelectChara Nothing) model <|
                        Query.find [ tag "select", classes [ "charas" ] ]
            , describe "キャラクターが選択された場合、そのキャラクターの値を SelectChara に設定して送信する"
                [ test "ベア" <|
                    \_ ->
                        let
                            model =
                                { initialModel | charas = heavyInfantries }
                        in
                        -- ベアのキャラクターID は 0
                        verifySendMsgFromSelectBox "0" (SelectChara <| Just charaAsBear) model <|
                            Query.find [ tag "select", classes [ "charas" ] ]
                , test "レオン" <|
                    \_ ->
                        let
                            model =
                                { initialModel | charas = specialCharas }
                        in
                        -- レオンのキャラクターID は 300
                        verifySendMsgFromSelectBox "300" (SelectChara <| Just charaAsLeon) model <|
                            Query.find [ tag "select", classes [ "charas" ] ]
                ]

            -- 武器タイプ選択
            , describe "武器タイプが選択された場合、その武器タイプの値を ChangeWeaponType に設定して送信する"
                [ test "剣" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponSword 0
                , test "大剣" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponGreatSword 1
                , test "斧" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponAxe 2
                , test "棍棒" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponMace 3
                , test "槍" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponSpear 4
                , test "小剣" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponShortSword 5
                , test "弓" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponBow 6
                , test "体術" <|
                    \_ ->
                        verifySendMsgFromRadioButton Data.WeaponMartialSkill 7
                ]
            ]
        ]


initialModel : Model
initialModel =
    { charaClasses = Data.charaClasses
    , allCharas = Data.charas
    , charas = []
    , weaponType = Data.WeaponSword
    }


heavyInfantryClass : Data.CharaClass
heavyInfantryClass =
    Data.CharaClass Data.HeavyInfantry 0 "帝国重装歩兵" "初期状態で加入済み。"


charaAsBear : Chara
charaAsBear =
    Chara 0 "ベア" Data.SparkGeneral


heavyInfantries : List Chara
heavyInfantries =
    [ charaAsBear
    , Chara 1 "バイソン" Data.SparkGeneral
    , Chara 2 "ウォーラス" Data.SparkGeneral
    , Chara 3 "スネイル" Data.SparkSword2
    , Chara 4 "ヘッジホッグ" Data.SparkGeneral
    , Chara 5 "トータス" Data.SparkGeneral
    , Chara 6 "ライノ" Data.SparkGeneral
    , Chara 7 "フェルディナント" Data.SparkGeneral
    ]


specialCharaClass : Data.CharaClass
specialCharaClass =
    Data.CharaClass Data.SpecialChara 40 "特殊" "【加入条件省略】"


charaAsLeon : Chara
charaAsLeon =
    Chara 300 "レオン" Data.SparkNothing


specialCharas : List Chara
specialCharas =
    [ charaAsLeon
    , Chara 301 "ジェラール" Data.SparkSpell
    , Chara 302 "コッペリア" Data.SparkNothing
    , Chara 303 "最終皇帝(男)" Data.SparkSword2
    , Chara 304 "最終皇帝(女)" Data.SparkSword2
    ]


{-| 指定された武器種を未選択に変更するか検証する
-}
verifySetWeaponTypeToModel : Data.WeaponType -> Data.WeaponType -> Expectation
verifySetWeaponTypeToModel initialWeaponType weaponType =
    { initialModel | weaponType = initialWeaponType }
        |> update (ChangeWeaponType weaponType)
        |> Tuple.first
        |> .weaponType
        |> Expect.equal weaponType


{-| セレクトボックスの項目選択時に対応したメッセージが送信されるか検証する
-}
verifySendMsgFromSelectBox : String -> Msg -> Model -> (Query.Single Msg -> Query.Single Msg) -> Expectation
verifySendMsgFromSelectBox optionValue expectedMsg model query =
    let
        eventObject : Encode.Value
        eventObject =
            Encode.object
                [ ( "target"
                  , Encode.object
                        [ ( "value", Encode.string optionValue ) ]
                  )
                ]
    in
    model
        |> view
        |> Query.fromHtml
        |> query
        |> Event.simulate (Event.custom "change" eventObject)
        |> Event.expect expectedMsg


{-| フィルタボタンクリック時の動作を検証する
-}
verifySendMsgFromRadioButton : Data.WeaponType -> Int -> Expectation
verifySendMsgFromRadioButton weaponType index_ =
    initialModel
        |> view
        |> Query.fromHtml
        |> Query.find [ classes [ "weapon-type-filter" ] ]
        |> Query.findAll [ tag "input" ]
        |> Query.index index_
        |> Event.simulate Event.click
        |> Event.expect (ChangeWeaponType weaponType)
