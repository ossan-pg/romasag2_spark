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
            [ describe "指定されたクラスに対応するキャラクターを Model に設定する"
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

            -- 剣フィルタ
            , test "剣の技が表示 ON かつメッセージが ChangeWeaponType Sword だった場合、剣の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse Sword .sword
            , test "剣の技が表示 OFF かつメッセージが ChangeWeaponType Sword だった場合、剣の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue Sword .sword

            -- 大剣フィルタ
            , test "大剣の技が表示 ON かつメッセージが ChangeWeaponType GreatSword だった場合、大剣の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse GreatSword .greatSword
            , test "大剣の技が表示 OFF かつメッセージが ChangeWeaponType GreatSword だった場合、大剣の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue GreatSword .greatSword

            -- 斧フィルタ
            , test "斧の技が表示 ON かつメッセージが ChangeWeaponType Axe だった場合、斧の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse Axe .axe
            , test "斧の技が表示 OFF かつメッセージが ChangeWeaponType Axe だった場合、斧の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue Axe .axe

            -- 棍棒フィルタ
            , test "棍棒の技が表示 ON かつメッセージが ChangeWeaponType Mace だった場合、棍棒の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse Mace .mace
            , test "棍棒の技が表示 OFF かつメッセージが ChangeWeaponType Mace だった場合、棍棒の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue Mace .mace

            --槍フィルタ
            , test "槍の技が表示 ON かつメッセージが ChangeWeaponType Spear だった場合、槍の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse Spear .spear
            , test "槍の技が表示 OFF かつメッセージが ChangeWeaponType Spear だった場合、槍の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue Spear .spear

            -- 小剣フィルタ
            , test "小剣の技が表示 ON かつメッセージが ChangeWeaponType ShortSword だった場合、小剣の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse ShortSword .shortSword
            , test "小剣の技が表示 OFF かつメッセージが ChangeWeaponType ShortSword だった場合、小剣の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue ShortSword .shortSword

            -- 弓フィルタ
            , test "弓の技が表示 ON かつメッセージが ChangeWeaponType Bow だった場合、弓の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse Bow .bow
            , test "弓の技が表示 OFF かつメッセージが ChangeWeaponType Bow だった場合、弓の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue Bow .bow

            -- 体術フィルタ
            , test "体術の技が表示 ON かつメッセージが ChangeWeaponType MartialSkill だった場合、体術の技を表示 OFF にする" <|
                \_ ->
                    verifySelectedWeaponTypeToFalse MartialSkill .martialSkill
            , test "体術の技が表示 OFF かつメッセージが ChangeWeaponType MartialSkill だった場合、体術の技を表示 ON にする" <|
                \_ ->
                    verifySelectedWeaponTypeToTrue MartialSkill .martialSkill
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
            , describe "クラスが選択された場合、そのクラスに対応するメッセージを送信する"
                [ test "帝国重装歩兵を選択された場合、SelectCharaClass HeavyInfantry メッセージを送信する" <|
                    \_ ->
                        verifySendMsgFromSelectBox "0" (SelectCharaClass <| Just heavyInfantryClass) initialModel <|
                            Query.find [ tag "select", classes [ "chara-classes" ] ]
                , test "特殊を選択された場合、SelectCharaClass SpecialCharaClass メッセージを送信する" <|
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
            , describe "キャラクターが選択された場合、そのキャラクターの閃きタイプに対応するメッセージを送信する"
                [ test "ベアを選択された場合、SelectChara General メッセージを送信する" <|
                    \_ ->
                        let
                            model =
                                { initialModel | charas = heavyInfantries }
                        in
                        -- ベアのキャラクターID は 0
                        verifySendMsgFromSelectBox "0" (SelectChara Data.General) model <|
                            Query.find [ tag "select", classes [ "charas" ] ]
                , test "レオンを選択された場合、SelectChara CannotSpark メッセージを送信する" <|
                    \_ ->
                        let
                            model =
                                { initialModel | charas = specialCharas }
                        in
                        -- レオンのキャラクターID は 300
                        verifySendMsgFromSelectBox "300" (SelectChara Data.CannotSpark) model <|
                            Query.find [ tag "select", classes [ "charas" ] ]
                ]

            -- 剣ボタン
            , test "剣の技が表示 ON の場合、剣ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "剣" "selected" <|
                        { unselectedAllWeaponTypes | sword = True }
            , test "剣の技が表示 OFF の場合、剣ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "剣" "unselected" <|
                        { selectedAllWeaponTypes | sword = False }
            , test "剣ボタンがクリックされた場合、ChangeWeaponType Sword メッセージを送信する" <|
                \_ ->
                    verifyButtonClick Sword 0

            -- 大剣ボタン
            , test "大剣の技が表示 ON の場合、大剣ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "大剣" "selected" <|
                        { unselectedAllWeaponTypes | greatSword = True }
            , test "大剣の技が表示 OFF の場合、大剣ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "大剣" "unselected" <|
                        { selectedAllWeaponTypes | greatSword = False }
            , test "大剣ボタンがクリックされた場合、ChangeWeaponType GreatSword メッセージを送信する" <|
                \_ ->
                    verifyButtonClick GreatSword 1

            -- 斧ボタン
            , test "斧の技が表示 ON の場合、斧ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "斧" "selected" <|
                        { unselectedAllWeaponTypes | axe = True }
            , test "斧の技が表示 OFF の場合、斧ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "斧" "unselected" <|
                        { selectedAllWeaponTypes | axe = False }
            , test "斧ボタンがクリックされた場合、ChangeWeaponType Axe メッセージを送信する" <|
                \_ ->
                    verifyButtonClick Axe 2

            -- 棍棒ボタン
            , test "棍棒の技が表示 ON の場合、棍棒ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "棍棒" "selected" <|
                        { unselectedAllWeaponTypes | mace = True }
            , test "棍棒の技が表示 OFF の場合、棍棒ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "棍棒" "unselected" <|
                        { selectedAllWeaponTypes | mace = False }
            , test "棍棒ボタンがクリックされた場合、ChangeWeaponType Mace メッセージを送信する" <|
                \_ ->
                    verifyButtonClick Mace 3

            -- 槍ボタン
            , test "槍の技が表示 ON の場合、槍ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "槍" "selected" <|
                        { unselectedAllWeaponTypes | spear = True }
            , test "槍の技が表示 OFF の場合、槍ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "槍" "unselected" <|
                        { selectedAllWeaponTypes | spear = False }
            , test "槍ボタンがクリックされた場合、ChangeWeaponType Spear メッセージを送信する" <|
                \_ ->
                    verifyButtonClick Spear 4

            -- 小剣ボタン
            , test "小剣の技が表示 ON の場合、小剣ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "小剣" "selected" <|
                        { unselectedAllWeaponTypes | shortSword = True }
            , test "小剣の技が表示 OFF の場合、小剣ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "小剣" "unselected" <|
                        { selectedAllWeaponTypes | shortSword = False }
            , test "小剣ボタンがクリックされた場合、ChangeWeaponType ShortSword メッセージを送信する" <|
                \_ ->
                    verifyButtonClick ShortSword 5

            -- 弓ボタン
            , test "弓の技が表示 ON の場合、弓ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "弓" "selected" <|
                        { unselectedAllWeaponTypes | bow = True }
            , test "弓の技が表示 OFF の場合、弓ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "弓" "unselected" <|
                        { selectedAllWeaponTypes | bow = False }
            , test "弓ボタンがクリックされた場合、ChangeWeaponType Bow メッセージを送信する" <|
                \_ ->
                    verifyButtonClick Bow 6

            -- 体術ボタン
            , test "体術の技が表示 ON の場合、体術ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "体術" "selected" <|
                        { unselectedAllWeaponTypes | martialSkill = True }
            , test "体術の技が表示 OFF の場合、体術ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "体術" "unselected" <|
                        { selectedAllWeaponTypes | martialSkill = False }
            , test "体術ボタンがクリックされた場合、ChangeWeaponType MartialSkill メッセージを送信する" <|
                \_ ->
                    verifyButtonClick MartialSkill 7
            ]
        ]


{-| 全ての武器種を未選択の SelectedWeaponTypes
-}
unselectedAllWeaponTypes : SelectedWeaponTypes
unselectedAllWeaponTypes =
    { sword = False
    , greatSword = False
    , axe = False
    , mace = False
    , spear = False
    , shortSword = False
    , bow = False
    , martialSkill = False
    }


{-| 全ての武器種を選択中の SelectedWeaponTypes
-}
selectedAllWeaponTypes : SelectedWeaponTypes
selectedAllWeaponTypes =
    { sword = True
    , greatSword = True
    , axe = True
    , mace = True
    , spear = True
    , shortSword = True
    , bow = True
    , martialSkill = True
    }


initialModel : Model
initialModel =
    { charaClasses = Data.charaClasses
    , allCharas = Data.charas
    , charas = []
    , selectedWeaponTypes = unselectedAllWeaponTypes
    }


heavyInfantryClass : Data.CharaClass
heavyInfantryClass =
    Data.CharaClass Data.HeavyInfantry 0 "帝国重装歩兵" "初期状態で加入済み。"


heavyInfantries : List Chara
heavyInfantries =
    [ Chara 0 "ベア" Data.General
    , Chara 1 "バイソン" Data.General
    , Chara 2 "ウォーラス" Data.General
    , Chara 3 "スネイル" Data.Sword2
    , Chara 4 "ヘッジホッグ" Data.General
    , Chara 5 "トータス" Data.General
    , Chara 6 "ライノ" Data.General
    , Chara 7 "フェルディナント" Data.General
    ]


specialCharaClass : Data.CharaClass
specialCharaClass =
    Data.CharaClass Data.SpecialChara 40 "特殊" "【加入条件省略】"


specialCharas : List Chara
specialCharas =
    [ Chara 300 "レオン" Data.CannotSpark
    , Chara 301 "ジェラール" Data.Spell
    , Chara 302 "コッペリア" Data.CannotSpark
    , Chara 303 "最終皇帝(男)" Data.Sword2
    , Chara 304 "最終皇帝(女)" Data.Sword2
    ]


{-| 指定された武器種を選択中に変更するか検証する
-}
verifySelectedWeaponTypeToTrue : WeaponType -> (SelectedWeaponTypes -> Bool) -> Expectation
verifySelectedWeaponTypeToTrue weaponType toBool =
    { initialModel | selectedWeaponTypes = unselectedAllWeaponTypes }
        |> update (ChangeWeaponType weaponType)
        |> Tuple.first
        |> .selectedWeaponTypes
        |> toBool
        |> Expect.equal True


{-| 指定された武器種を未選択に変更するか検証する
-}
verifySelectedWeaponTypeToFalse : WeaponType -> (SelectedWeaponTypes -> Bool) -> Expectation
verifySelectedWeaponTypeToFalse weaponType toBool =
    { initialModel | selectedWeaponTypes = selectedAllWeaponTypes }
        |> update (ChangeWeaponType weaponType)
        |> Tuple.first
        |> .selectedWeaponTypes
        |> toBool
        |> Expect.equal False


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


{-| フィルタボタンに設定するクラスを検証する
-}
verifyClassOfButton : String -> String -> SelectedWeaponTypes -> Expectation
verifyClassOfButton weaponType className selectedWeaponTypes =
    { initialModel | selectedWeaponTypes = selectedWeaponTypes }
        |> view
        |> Query.fromHtml
        |> Query.find [ classes [ "weapon-type-filter" ] ]
        |> Query.find [ tag "button", classes [ className ] ]
        |> Query.has [ text weaponType ]


{-| フィルタボタンクリック時の動作を検証する
-}
verifyButtonClick : WeaponType -> Int -> Expectation
verifyButtonClick weaponType index_ =
    initialModel
        |> view
        |> Query.fromHtml
        |> Query.find [ classes [ "weapon-type-filter" ] ]
        |> Query.findAll [ tag "button" ]
        |> Query.index index_
        |> Event.simulate Event.click
        |> Event.expect (ChangeWeaponType weaponType)
