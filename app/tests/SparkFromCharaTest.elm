module SparkFromCharaTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Html as H
import Html.Attributes as Attrs
import Json.Encode as Encode
import Repository as Repos
import SparkFromChara exposing (..)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (checked, classes, containing, tag, text)


suite : Test
suite =
    describe "The SparkFromChara module"
        [ describe "update" <|
            List.concat
                [ updateOnSelectCharaClassTests
                , updateOnSelectCharaTests
                , updateOnSelectWeaponTypeTests
                ]
        , describe "view" <|
            List.concat
                [ viewClassesTests
                , viewCharasTests
                , viewWeaponTypesTests
                , viewWazasTests
                ]
        ]


initialModel : Model
initialModel =
    { charaClasses = Repos.charaClasses
    , charas = []
    , charaIndex = Nothing
    , sparkType = Nothing
    , weaponType = Repos.WeaponSword
    , wazas = []
    }


updateOnSelectCharaClassTests : List Test
updateOnSelectCharaClassTests =
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
    ]


updateOnSelectCharaTests : List Test
updateOnSelectCharaTests =
    -- 閃き可能な技を設定
    [ test "キャラクターが指定されていない場合、空の技リストを Model に設定する" <|
        \_ ->
            -- 技リストを空以外に設定
            { initialModel | wazas = [ wazaParry ] }
                |> update (SelectChara Nothing)
                |> Tuple.first
                |> .wazas
                |> Expect.equal []
    , describe "指定されたキャラクターの閃きタイプに対応する技を Model に設定する"
        [ test "ベアが指定された場合、閃きタイプ「汎用」が閃き可能な技を Model に設定する" <|
            \_ ->
                initialModel
                    |> update (SelectChara <| Just charaAsBear)
                    |> Tuple.first
                    |> (\m -> ( m.charaIndex, m.sparkType, m.wazas ))
                    |> Expect.equal ( Just 0, Just Repos.SparkGeneral, Repos.findWazas Repos.SparkGeneral )
        , test "レオンが指定された場合、閃きタイプ「なし」が閃き可能な技を Model に設定する" <|
            \_ ->
                initialModel
                    |> update (SelectChara <| Just charaAsLeon)
                    |> Tuple.first
                    |> (\m -> ( m.charaIndex, m.sparkType, m.wazas ))
                    |> Expect.equal ( Just 0, Just Repos.SparkNothing, Repos.findWazas Repos.SparkNothing )
        ]
    ]


updateOnSelectWeaponTypeTests : List Test
updateOnSelectWeaponTypeTests =
    let
        -- 指定された武器タイプが Model に設定されるか検証する
        verifySetWeaponTypeToModel : Repos.WeaponTypeSymbol -> Repos.WeaponTypeSymbol -> Expectation
        verifySetWeaponTypeToModel fromWeaponType toWeaponType =
            { initialModel | weaponType = fromWeaponType }
                |> update (SelectWeaponType toWeaponType)
                |> Tuple.first
                |> .weaponType
                |> Expect.equal toWeaponType
    in
    -- 武器タイプを設定
    [ describe "指定された武器タイプを Model に設定する"
        [ test "剣" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponAxe Repos.WeaponSword
        , test "大剣" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponSword Repos.WeaponGreatSword
        , test "斧" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponSword Repos.WeaponAxe
        , test "棍棒" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponSword Repos.WeaponMace
        , test "槍" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponSword Repos.WeaponSpear
        , test "小剣" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponSword Repos.WeaponShortSword
        , test "弓" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponSword Repos.WeaponBow
        , test "体術" <|
            \_ ->
                verifySetWeaponTypeToModel Repos.WeaponSword Repos.WeaponMartialSkill
        ]
    ]


viewClassesTests : List Test
viewClassesTests =
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
    ]


viewCharasTests : List Test
viewCharasTests =
    -- キャラクター一覧
    [ test "Model にキャラクターが誰も設定されていない場合、セレクトボックスの 1項目目に「クラス未選択」を Disabld 状態で表示する" <|
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
    ]


viewWeaponTypesTests : List Test
viewWeaponTypesTests =
    let
        -- Model に指定された武器タイプが選択状態になっているか検証する
        verifySelectedWeaponType : Repos.WeaponTypeSymbol -> Int -> Expectation
        verifySelectedWeaponType weaponType index_ =
            { initialModel | weaponType = weaponType }
                |> view
                |> Query.fromHtml
                |> Query.find [ classes [ "weapon-type-filter" ] ]
                |> Query.findAll [ tag "input" ]
                |> Query.index index_
                |> Query.has [ checked True ]

        -- 武器タイプボタンクリック時の動作を検証する
        verifySendMsgFromRadioButton : Repos.WeaponTypeSymbol -> Int -> Expectation
        verifySendMsgFromRadioButton weaponType index_ =
            initialModel
                |> view
                |> Query.fromHtml
                |> Query.find [ classes [ "weapon-type-filter" ] ]
                |> Query.findAll [ tag "input" ]
                |> Query.index index_
                |> Event.simulate Event.click
                |> Event.expect (SelectWeaponType weaponType)
    in
    -- 武器タイプ表示
    [ describe "Model に設定されている武器タイプをチェック状態にする"
        [ test "剣" <|
            \_ -> verifySelectedWeaponType Repos.WeaponSword 0
        , test "大剣" <|
            \_ -> verifySelectedWeaponType Repos.WeaponGreatSword 1
        , test "斧" <|
            \_ -> verifySelectedWeaponType Repos.WeaponAxe 2
        , test "棍棒" <|
            \_ -> verifySelectedWeaponType Repos.WeaponMace 3
        , test "槍" <|
            \_ -> verifySelectedWeaponType Repos.WeaponSpear 4
        , test "小剣" <|
            \_ -> verifySelectedWeaponType Repos.WeaponShortSword 5
        , test "弓" <|
            \_ -> verifySelectedWeaponType Repos.WeaponBow 6
        , test "体術" <|
            \_ -> verifySelectedWeaponType Repos.WeaponMartialSkill 7
        ]

    -- 武器タイプ選択
    , describe "武器タイプが選択された場合、その武器タイプの値を SelectWeaponType に設定して送信する"
        [ test "剣" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponSword 0
        , test "大剣" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponGreatSword 1
        , test "斧" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponAxe 2
        , test "棍棒" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponMace 3
        , test "槍" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponSpear 4
        , test "小剣" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponShortSword 5
        , test "弓" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponBow 6
        , test "体術" <|
            \_ -> verifySendMsgFromRadioButton Repos.WeaponMartialSkill 7
        ]
    ]


viewWazasTests : List Test
viewWazasTests =
    let
        -- 指定された武器タイプの技がセレクトボックスに設定されるか検証する
        verifySetWazasToSelectBox : List Repos.Waza -> Repos.WeaponTypeSymbol -> List ( String, String ) -> Expectation
        verifySetWazasToSelectBox wazas weaponType valueAndTexts =
            let
                options =
                    List.map
                        (\( value_, text_ ) ->
                            H.option [ Attrs.value value_ ] [ H.text text_ ]
                        )
                        valueAndTexts
            in
            { initialModel | weaponType = weaponType, wazas = wazas }
                |> view
                |> Query.fromHtml
                |> Query.find [ tag "select", classes [ "wazas" ] ]
                |> Query.contains options

        -- 指定された武器タイプの技がセレクトボックスに設定される件数を検証する
        verifyCountOfWazasInSelectBox : List Repos.Waza -> Repos.WeaponTypeSymbol -> Int -> Expectation
        verifyCountOfWazasInSelectBox wazas weaponType count_ =
            { initialModel | weaponType = weaponType, wazas = wazas }
                |> view
                |> Query.fromHtml
                |> Query.find [ tag "select", classes [ "wazas" ] ]
                |> Query.findAll [ tag "option" ]
                |> Query.count (Expect.equal count_)
    in
    -- 閃きタイプ表示
    [ describe "「閃き可能な技」の右側にキャラクターの閃きタイプを表示する"
        [ test "閃きタイプの指定なし" <|
            \_ ->
                { initialModel | sparkType = Nothing }
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ classes [ "wazas-outer" ] ]
                    |> Query.find [ tag "div", containing [ text "閃き可能な技" ] ]
                    |> Query.has [ text "閃き可能な技" ]
        , test "剣1" <|
            \_ ->
                { initialModel | sparkType = Just Repos.SparkSword1 }
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ classes [ "wazas-outer" ] ]
                    |> Query.find [ tag "div", containing [ text "閃き可能な技" ] ]
                    |> Query.has [ text "閃き可能な技【剣1】" ]
        , test "汎用" <|
            \_ ->
                { initialModel | sparkType = Just Repos.SparkGeneral }
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ classes [ "wazas-outer" ] ]
                    |> Query.find [ tag "div", containing [ text "閃き可能な技" ] ]
                    |> Query.has [ text "閃き可能な技【汎用】" ]
        ]

    -- 閃き可能な技一覧
    , test "Model に閃き可能な技が設定されていない場合、セレクトボックスの 1項目目に「キャラクター未選択」を Disabld 状態で表示する" <|
        \_ ->
            { initialModel | wazas = [] }
                |> view
                |> Query.fromHtml
                |> Query.find [ tag "select", classes [ "wazas" ] ]
                |> Query.contains
                    [ H.option [ Attrs.disabled True ] [ H.text "キャラクター未選択" ]
                    ]
    , describe "閃き可能な技一覧に対し、現在選択中の武器タイプについて各技の名前を option の要素に、ID を option の value 属性に設定する"
        -- 「セレクトボックスに特定の要素 *だけ* が含まれていること」を
        -- 検証したかったが、その方法を見付けられなかった。
        -- なので、同じ Model に対して
        -- 「セレクトボックスに想定した要素が含まれていること」と
        -- 「セレクトボックスの要素が想定した個数であること」の
        -- 2種類の検証を実施することで仕様通りであるかを担保することにした。
        [ test "剣" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest Repos.WeaponSword <|
                    [ ( "16", "パリイ" ), ( "17", "二段斬り" ) ]
        , test "剣(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponSword <|
                    List.length
                        [ ( "16", "パリイ" ), ( "17", "二段斬り" ) ]
        , test "大剣" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest Repos.WeaponGreatSword <|
                    [ ( "42", "巻き打ち" ), ( "43", "強撃" ) ]
        , test "大剣(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponGreatSword <|
                    List.length
                        [ ( "42", "巻き打ち" ), ( "43", "強撃" ) ]
        , test "斧" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest
                    Repos.WeaponAxe
                    [ ( "62", "アクスボンバー" ), ( "63", "トマホーク" ) ]
        , test "斧(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponAxe <|
                    List.length
                        [ ( "62", "アクスボンバー" ), ( "63", "トマホーク" ) ]
        , test "棍棒" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest Repos.WeaponMace <|
                    [ ( "78", "返し突き" ), ( "79", "脳天割り" ) ]
        , test "棍棒(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponMace <|
                    List.length
                        [ ( "78", "返し突き" ), ( "79", "脳天割り" ) ]
        , test "槍" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest
                    Repos.WeaponSpear
                    [ ( "94", "足払い" ), ( "95", "二段突き" ) ]
        , test "槍(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponSpear <|
                    List.length
                        [ ( "94", "足払い" ), ( "95", "二段突き" ) ]
        , test "小剣" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest Repos.WeaponShortSword <|
                    [ ( "113", "感電衝" ), ( "115", "マリオネット" ) ]
        , test "小剣(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponShortSword <|
                    List.length
                        [ ( "113", "感電衝" ), ( "115", "マリオネット" ) ]
        , test "弓" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest
                    Repos.WeaponBow
                    [ ( "133", "瞬速の矢" ), ( "134", "でたらめ矢" ) ]
        , test "弓(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponBow <|
                    List.length
                        [ ( "133", "瞬速の矢" ), ( "134", "でたらめ矢" ) ]
        , test "体術" <|
            \_ ->
                verifySetWazasToSelectBox wazasForTest Repos.WeaponMartialSkill <|
                    [ ( "150", "ソバット" ), ( "151", "カウンター" ) ]
        , test "体術(件数)" <|
            \_ ->
                verifyCountOfWazasInSelectBox wazasForTest Repos.WeaponMartialSkill <|
                    List.length
                        [ ( "150", "ソバット" ), ( "151", "カウンター" ) ]
        ]

    -- 閃き可能な技選択
    , test "無効な技が選択された場合、Nothing を SelectWaza に設定して送信する" <|
        \_ ->
            -- UI 的にあり得ないはずだが、仮に起きた場合にどうなるかを
            -- 把握するためテストしておく
            let
                model =
                    { initialModel | wazas = [ wazaParry, wazaDoubleCut ] }
            in
            -- 閃き可能な技一覧にない技ID を指定する
            verifySendMsgFromSelectBox "999" (SelectWaza Nothing) model <|
                Query.find [ tag "select", classes [ "wazas" ] ]
    , describe "技が選択された場合、その技の値を SelectWaza に設定して送信する"
        [ test "パリイ" <|
            \_ ->
                let
                    model =
                        { initialModel | wazas = [ wazaParry, wazaDoubleCut ] }
                in
                verifySendMsgFromSelectBox "16" (SelectWaza <| Just wazaParry) model <|
                    Query.find [ tag "select", classes [ "wazas" ] ]
        , test "二段斬り" <|
            \_ ->
                let
                    model =
                        { initialModel | wazas = [ wazaParry, wazaDoubleCut ] }
                in
                verifySendMsgFromSelectBox "17" (SelectWaza <| Just wazaDoubleCut) model <|
                    Query.find [ tag "select", classes [ "wazas" ] ]
        ]
    ]


heavyInfantryClass : Repos.CharaClass
heavyInfantryClass =
    Repos.CharaClass Repos.HeavyInfantry 0 "帝国重装歩兵" "初期状態で加入済み。"


charaAsBear : IndexedChara
charaAsBear =
    IndexedChara 0 <|
        Repos.Chara 0 "ベア" 14 16 12 15 12 11 23 3 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 1 Repos.SparkGeneral


heavyInfantries : List IndexedChara
heavyInfantries =
    [ charaAsBear
    , IndexedChara 1 <|
        Repos.Chara 1 "バイソン" 15 17 12 16 13 11 21 1 -7 1 -7 1 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 2 Repos.SparkGeneral
    , IndexedChara 2 <|
        Repos.Chara 2 "ウォーラス" 13 16 14 14 10 10 23 1 -7 1 -7 -7 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 3 Repos.SparkGeneral
    , IndexedChara 3 <|
        Repos.Chara 3 "スネイル" 12 15 12 16 13 13 21 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 4 Repos.SparkSword2
    , IndexedChara 4 <|
        Repos.Chara 4 "ヘッジホッグ" 11 18 12 16 12 11 22 0 0 -7 0 -7 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 5 Repos.SparkGeneral
    , IndexedChara 5 <|
        Repos.Chara 5 "トータス" 12 15 13 15 14 12 22 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 6 Repos.SparkGeneral
    , IndexedChara 6 <|
        Repos.Chara 6 "ライノ" 13 16 14 15 11 13 21 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 7 Repos.SparkGeneral
    , IndexedChara 7 <|
        Repos.Chara 7 "フェルディナント" 10 15 13 16 13 10 23 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 Repos.HeavyInfantry 8 Repos.SparkGeneral
    ]


specialCharaClass : Repos.CharaClass
specialCharaClass =
    Repos.CharaClass Repos.SpecialChara 40 "特殊" "【加入条件省略】"


charaAsLeon : IndexedChara
charaAsLeon =
    IndexedChara 0 <|
        Repos.Chara 300 "レオン" 19 19 17 20 12 14 20 5 2 0 0 0 0 0 0 0 2 0 Repos.SpecialChara 0 Repos.SparkNothing


specialCharas : List IndexedChara
specialCharas =
    [ charaAsLeon
    , IndexedChara 1 <|
        Repos.Chara 301 "ジェラール" 16 17 22 19 11 20 11 0 0 0 0 0 0 0 0 0 0 0 Repos.SpecialChara 0 Repos.SparkSpell
    , IndexedChara 2 <|
        Repos.Chara 302 "コッペリア" 99 20 20 15 15 20 20 15 15 15 15 15 0 0 0 0 0 0 Repos.SpecialChara 0 Repos.SparkNothing
    , IndexedChara 3 <|
        Repos.Chara 303 "最終皇帝(男)" 19 25 23 23 15 24 21 10 5 5 5 5 0 0 0 0 10 0 Repos.SpecialChara 0 Repos.SparkSword2
    , IndexedChara 4 <|
        Repos.Chara 304 "最終皇帝(女)" 10 23 24 24 15 25 20 10 5 5 5 5 0 0 0 0 10 0 Repos.SpecialChara 0 Repos.SparkSword2
    ]


wazaParry : Repos.Waza
wazaParry =
    Repos.Waza 16 "パリイ" 0 0 1 Repos.WeaponSword


wazaDoubleCut : Repos.Waza
wazaDoubleCut =
    Repos.Waza 17 "二段斬り" 2 3 2 Repos.WeaponSword


wazasForTest : List Repos.Waza
wazasForTest =
    [ wazaParry
    , wazaDoubleCut
    , Repos.Waza 42 "巻き打ち" 1 4 1 Repos.WeaponGreatSword
    , Repos.Waza 43 "強撃" 3 6 1 Repos.WeaponGreatSword
    , Repos.Waza 62 "アクスボンバー" 3 5 1 Repos.WeaponAxe
    , Repos.Waza 63 "トマホーク" 1 3 1 Repos.WeaponAxe
    , Repos.Waza 78 "返し突き" 0 4 1 Repos.WeaponMace
    , Repos.Waza 79 "脳天割り" 3 5 1 Repos.WeaponMace
    , Repos.Waza 94 "足払い" 0 0 1 Repos.WeaponSpear
    , Repos.Waza 95 "二段突き" 2 3 2 Repos.WeaponSpear
    , Repos.Waza 113 "感電衝" 1 2 1 Repos.WeaponShortSword
    , Repos.Waza 115 "マリオネット" 6 0 1 Repos.WeaponShortSword
    , Repos.Waza 133 "瞬速の矢" 3 5 1 Repos.WeaponBow
    , Repos.Waza 134 "でたらめ矢" 2 3 1 Repos.WeaponBow
    , Repos.Waza 150 "ソバット" 2 6 1 Repos.WeaponMartialSkill
    , Repos.Waza 151 "カウンター" 0 6 1 Repos.WeaponMartialSkill
    ]


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
