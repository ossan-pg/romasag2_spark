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
                , updateOnSelectWazaTests
                ]
        , describe "view" <|
            List.concat
                [ viewClassesTests
                , viewCharasTests
                , viewWeaponTypesTests
                , viewWazasTests
                , viewWazaEnemiesTests
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
    , wazaIndex = Nothing
    , allWazaEnemies = []
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
    let
        pretty : Model -> ( Maybe Int, Maybe Repos.SparkTypeSymbol, List ( Int, String ) )
        pretty { charaIndex, sparkType, wazas } =
            ( charaIndex
            , sparkType
            , wazas |> List.map (\{ index, waza } -> ( index, waza.name ))
            )
    in
    -- 閃き可能な技を設定
    [ test "キャラクターが指定されていない場合、空の技リストを Model に設定する" <|
        \_ ->
            -- キャラクターの選択位置、選択中キャラクターの閃きタイプ、
            -- 技リストを空以外に設定
            { initialModel
                | charaIndex = Just 0
                , sparkType = Just Repos.SparkAxe
                , wazas = [ wazaParry ]
            }
                |> update (SelectChara Nothing)
                |> Tuple.first
                |> pretty
                |> Expect.equal ( Nothing, Nothing, [] )
    , describe "指定されたキャラクターの閃きタイプに対応する技を Model に設定する"
        [ test "武器タイプに小剣を選択中の状態でベアが指定された場合、閃きタイプ「汎用」が閃き可能な小剣の技を Model に設定する" <|
            \_ ->
                { initialModel | weaponType = Repos.WeaponShortSword }
                    |> update (SelectChara <| Just charaAsBear)
                    |> Tuple.first
                    |> pretty
                    |> Expect.equal
                        ( Just 0
                        , Just Repos.SparkGeneral
                        , [ ( 0, "スネークショット" )
                          , ( 1, "マタドール" )
                          , ( 2, "乱れ突き" )
                          , ( 3, "スクリュードライバ" )
                          , ( 4, "マッドバイター" )
                          , ( 5, "火龍出水" )
                          , ( 6, "百花繚乱" )
                          ]
                        )
        , test "武器タイプに弓を選択中の状態でレオンが指定された場合、閃きタイプ「なし」が閃き可能な弓の技を Model に設定する" <|
            \_ ->
                { initialModel | weaponType = Repos.WeaponBow }
                    |> update (SelectChara <| Just charaAsLeon)
                    |> Tuple.first
                    |> pretty
                    |> Expect.equal
                        ( Just 0
                        , Just Repos.SparkNothing
                        , [ ( 0, "ハートシーカー" )
                          , ( 1, "皆死ね矢" )
                          , ( 2, "スターライトアロー" )
                          ]
                        )
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


updateOnSelectWazaTests : List Test
updateOnSelectWazaTests =
    let
        verifySetWazaEnemiesToModel :
            IndexedWaza
            -> List ( String, List ( Float, ( String, Repos.EnemyTypeSymbol, Int ) ) )
            -> Expectation
        verifySetWazaEnemiesToModel toWaza allWazaEnemyTuples =
            let
                -- 指定された敵リストの各件数で update 結果の
                -- allWazaEnemyTuples の敵リストを切り取る
                numsOfTake =
                    allWazaEnemyTuples
                        |> List.map (Tuple.second >> List.length)

                -- 結果を確認しやすい形式に変換する
                -- ( "派生元の技",
                --   [ ( 閃き率, ( "敵名", 敵種族, 敵ランク ) )
                --   , ...
                --   ]
                -- )
                pretty :
                    List WazaEnemies
                    -> List ( String, List ( Float, ( String, Repos.EnemyTypeSymbol, Int ) ) )
                pretty allWazaEnemies_ =
                    allWazaEnemies_
                        |> List.map2 Tuple.pair numsOfTake
                        |> List.map
                            (\( nrOfTake, { fromWaza, enemies } ) ->
                                ( fromWaza.name
                                , enemies
                                    |> List.take nrOfTake
                                    |> List.map
                                        (\{ sparkRate, enemy } ->
                                            ( sparkRate, ( enemy.name, enemy.enemyType, enemy.rank ) )
                                        )
                                )
                            )
            in
            initialModel
                |> update (SelectWaza <| Just toWaza)
                |> Tuple.first
                |> (\m -> ( m.wazaIndex, pretty m.allWazaEnemies ))
                |> Expect.equal ( Just toWaza.index, allWazaEnemyTuples )
    in
    -- 派生元の技と敵一覧を設定
    -- 敵一覧は件数が多いため、先頭から数件を検証し、それらが一致すれば OK とする
    [ test "技が指定されていない場合、空の派生元の技と敵のリストを Model に設定する" <|
        \_ ->
            -- 派生元の技と敵のリストを空以外に設定
            { initialModel | allWazaEnemies = [ WazaEnemies wazaParry.waza [] ] }
                |> update (SelectWaza Nothing)
                |> Tuple.first
                |> (\m -> ( m.wazaIndex, m.allWazaEnemies ))
                |> Expect.equal ( Nothing, [] )
    , describe "指定された技に対応する派生元の技と敵一覧を Model に設定する"
        [ test "パリイ" <|
            \_ ->
                verifySetWazaEnemiesToModel wazaParry
                    [ ( "(通常攻撃：剣)"
                      , [ ( 20.4, ( "バルチャー", Repos.EnemyWinged, 1 ) )
                        , ( 20.4, ( "飛蛇", Repos.EnemySnake, 1 ) )
                        , ( 20.4, ( "アデプト", Repos.EnemyHuman, 1 ) )
                        , ( 20.4, ( "タータラ", Repos.EnemyReptile, 1 ) )
                        , ( 20.4, ( "サイレン", Repos.EnemyWinged, 2 ) )
                        , ( 20.4, ( "バファロー", Repos.EnemyBeast, 2 ) )
                        , ( 20.4, ( "センチペタ", Repos.EnemyInsect, 3 ) )
                        , ( 20.4, ( "スライム", Repos.EnemySlime, 3 ) )
                        , ( 20.4, ( "レインイーター", Repos.EnemyGhost, 4 ) )
                        , ( 20.4, ( "ザ・ドラゴン", Repos.EnemyBoss, 20 ) )
                        , ( 9.8, ( "砂竜", Repos.EnemySnake, 4 ) )
                        , ( 9.8, ( "ニクサー", Repos.EnemyAquatic, 4 ) )
                        , ( 9.8, ( "竜金", Repos.EnemyFish, 5 ) )
                        , ( 9.8, ( "スプリッツァー", Repos.EnemyPlant, 5 ) )
                        , ( 9.8, ( "ニクシー", Repos.EnemyAquatic, 5 ) )
                        , ( 9.8, ( "ガリアンブルー", Repos.EnemyHuman, 5 ) )
                        ]
                      )
                    ]
        , test "かめごうら割り" <|
            \_ ->
                verifySetWazaEnemiesToModel
                    (IndexedWaza 10 <| Repos.Waza 87 "かめごうら割り" 12 11 1 Repos.WeaponMace)
                    [ ( "骨砕き"
                      , [ ( 20.4, ( "アルビオン", Repos.EnemyFish, 16 ) )
                        , ( 5.1, ( "ディアブロ", Repos.EnemyDemon, 16 ) )
                        , ( 5.1, ( "トウテツ", Repos.EnemyBeast, 16 ) )
                        , ( 5.1, ( "ミスティック", Repos.EnemyHuman, 16 ) )
                        , ( 2.4, ( "ナックラビー", Repos.EnemyDemon, 15 ) )
                        , ( 2.4, ( "ヘルビースト", Repos.EnemySkeleton, 16 ) )
                        , ( 2.4, ( "獄竜", Repos.EnemyUndead, 16 ) )
                        , ( 2.4, ( "ラルヴァクィーン", Repos.EnemyDemiHuman, 16 ) )
                        , ( 2.4, ( "カイザーアント", Repos.EnemyInsect, 16 ) )
                        , ( 2.4, ( "ヴリトラ", Repos.EnemySnake, 16 ) )
                        , ( 2.4, ( "ベインサーペント", Repos.EnemyAquatic, 16 ) )
                        ]
                      )
                    , ( "ダブルヒット"
                      , [ ( 20.4, ( "スカルロード", Repos.EnemySkeleton, 15 ) )
                        , ( 20.4, ( "ロビンハット", Repos.EnemyDemiHuman, 15 ) )
                        , ( 20.4, ( "メドゥサ", Repos.EnemySnake, 15 ) )
                        , ( 20.4, ( "フォージウィルム", Repos.EnemyWinged, 16 ) )
                        , ( 20.4, ( "セフィラス", Repos.EnemySprite, 16 ) )
                        , ( 20.4, ( "フィア", Repos.EnemyGhost, 16 ) )
                        , ( 20.4, ( "金龍", Repos.EnemyDragon, 40 ) )
                        , ( 9.4, ( "アルビオン", Repos.EnemyFish, 16 ) )
                        , ( 8.6, ( "ナックラビー", Repos.EnemyDemon, 15 ) )
                        , ( 8.6, ( "ヘルビースト", Repos.EnemySkeleton, 16 ) )
                        , ( 8.6, ( "獄竜", Repos.EnemyUndead, 16 ) )
                        , ( 8.6, ( "ラルヴァクィーン", Repos.EnemyDemiHuman, 16 ) )
                        , ( 8.6, ( "ディアブロ", Repos.EnemyDemon, 16 ) )
                        , ( 8.6, ( "トウテツ", Repos.EnemyBeast, 16 ) )
                        , ( 8.6, ( "カイザーアント", Repos.EnemyInsect, 16 ) )
                        , ( 8.6, ( "ヴリトラ", Repos.EnemySnake, 16 ) )
                        , ( 8.6, ( "ベインサーペント", Repos.EnemyAquatic, 16 ) )
                        , ( 8.6, ( "ミスティック", Repos.EnemyHuman, 16 ) )
                        ]
                      )
                    ]
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
        -- 指定された閃き可能な技がセレクトボックスに設定されるか検証する
        verifySetWazasToSelectBox : List IndexedWaza -> List ( String, String ) -> Expectation
        verifySetWazasToSelectBox wazas valueAndTexts =
            let
                options =
                    List.map
                        (\( value_, text_ ) ->
                            H.option [ Attrs.value value_ ] [ H.text text_ ]
                        )
                        valueAndTexts
            in
            { initialModel | wazas = wazas }
                |> view
                |> Query.fromHtml
                |> Query.find [ tag "select", classes [ "wazas" ] ]
                |> Query.contains options
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
    , describe "閃き可能な技一覧に対し、指定された閃き可能な技の名前を option の要素に、ID を option の value 属性に設定する"
        [ test "剣" <|
            \_ ->
                verifySetWazasToSelectBox
                    [ wazaParry, wazaDoubleCut ]
                    [ ( "16", "パリイ" ), ( "17", "二段斬り" ) ]
        , test "大剣" <|
            \_ ->
                verifySetWazasToSelectBox
                    [ IndexedWaza 0 <|
                        Repos.Waza 42 "巻き打ち" 1 4 1 Repos.WeaponGreatSword
                    , IndexedWaza 1 <|
                        Repos.Waza 43 "強撃" 3 6 1 Repos.WeaponGreatSword
                    , IndexedWaza 2 <|
                        Repos.Waza 44 "ディフレクト" 0 0 1 Repos.WeaponGreatSword
                    , IndexedWaza 3 <|
                        Repos.Waza 45 "切り落とし" 5 6 1 Repos.WeaponGreatSword
                    , IndexedWaza 4 <|
                        Repos.Waza 46 "ツバメ返し" 9 5 2 Repos.WeaponGreatSword
                    ]
                    [ ( "42", "巻き打ち" )
                    , ( "43", "強撃" )
                    , ( "44", "ディフレクト" )
                    , ( "45", "切り落とし" )
                    , ( "46", "ツバメ返し" )
                    ]
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


viewWazaEnemiesTests : List Test
viewWazaEnemiesTests =
    let
        allWazaEnemies =
            -- 実際と同じ件数を確認する意味はないので、
            -- 敵の件数はそれぞれ 3件にしている。
            -- また、閃き率は本来全て 20.4 だが、正しく反映されていることを
            -- 確認したいので一部任意の値に変更している。
            [ WazaEnemies (Repos.Waza 2 "(通常攻撃：斧)" 0 3 1 Repos.WeaponAxe)
                [ Repos.EnemyWithSparkRate
                    (Repos.Enemy 9 "ボーンドレイク" 24 Repos.EnemySkeleton 10)
                    20.4
                , Repos.EnemyWithSparkRate
                    (Repos.Enemy 57 "ワイバーン" 24 Repos.EnemyWinged 10)
                    9.8
                , Repos.EnemyWithSparkRate
                    (Repos.Enemy 121 "サンドバイター" 24 Repos.EnemySnake 10)
                    5.1
                ]
            , WazaEnemies (Repos.Waza 66 "大木断" 4 6 1 Repos.WeaponAxe)
                [ Repos.EnemyWithSparkRate
                    (Repos.Enemy 85 "ヘルハウンド" 15 Repos.EnemyBeast 6)
                    20.4
                , Repos.EnemyWithSparkRate
                    (Repos.Enemy 86 "ワンプス" 15 Repos.EnemyBeast 7)
                    20.4
                , Repos.EnemyWithSparkRate
                    (Repos.Enemy 183 "ムドメイン" 15 Repos.EnemySlime 8)
                    20.4
                ]
            , WazaEnemies (Repos.Waza 67 "ブレードロール" 8 8 1 Repos.WeaponAxe)
                [ Repos.EnemyWithSparkRate
                    (Repos.Enemy 163 "ニクサー" 14 Repos.EnemyAquatic 4)
                    20.4
                , Repos.EnemyWithSparkRate
                    (Repos.Enemy 5 "スケルトン" 14 Repos.EnemySkeleton 6)
                    20.4
                , Repos.EnemyWithSparkRate
                    (Repos.Enemy 37 "オーガ" 14 Repos.EnemyDemiHuman 6)
                    20.4
                ]
            ]
    in
    -- 派生元の技と敵の一覧
    [ test "Model に派生元の技と敵が設定されていない場合、派生元の技と敵の一覧を表示しない" <|
        \_ ->
            { initialModel | allWazaEnemies = [] }
                |> view
                |> Query.fromHtml
                |> Query.find [ tag "section", classes [ "waza-enemies-outer" ] ]
                |> Query.hasNot [ tag "div" ]
    , test "派生元の技を表示し、その下に項番、閃き率、敵の名前、敵の種族、敵のランクを表形式で表示する" <|
        \_ ->
            { initialModel | allWazaEnemies = allWazaEnemies }
                |> view
                |> Query.fromHtml
                |> Query.find [ tag "section", classes [ "waza-enemies-outer" ] ]
                |> Query.contains
                    [ H.section [ Attrs.class "waza-enemies-outer" ]
                        [ H.section [] [ H.text "派生元：(通常攻撃：斧)" ]
                        , H.table [ Attrs.class "waza-enemies" ]
                            [ H.tr []
                                [ H.th [ Attrs.class "number" ] [ H.text "#" ]
                                , H.th [ Attrs.class "spark-rate" ] [ H.text "閃き率" ]
                                , H.th [ Attrs.class "enemy-name" ] [ H.text "モンスター" ]
                                , H.th [ Attrs.class "enemy-type" ] [ H.text "種族" ]
                                , H.th [ Attrs.class "enemy-rank" ] [ H.text "ランク" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "1" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "20.4" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "ボーンドレイク" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "骸骨" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "10" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "2" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "9.8" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "ワイバーン" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "有翼" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "10" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "3" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "5.1" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "サンドバイター" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "蛇" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "10" ]
                                ]
                            ]
                        , H.section [] [ H.text "派生元：大木断" ]
                        , H.table [ Attrs.class "waza-enemies" ]
                            [ H.tr []
                                [ H.th [ Attrs.class "number" ] [ H.text "#" ]
                                , H.th [ Attrs.class "spark-rate" ] [ H.text "閃き率" ]
                                , H.th [ Attrs.class "enemy-name" ] [ H.text "モンスター" ]
                                , H.th [ Attrs.class "enemy-type" ] [ H.text "種族" ]
                                , H.th [ Attrs.class "enemy-rank" ] [ H.text "ランク" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "1" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "20.4" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "ヘルハウンド" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "獣" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "6" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "2" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "20.4" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "ワンプス" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "獣" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "7" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "3" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "20.4" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "ムドメイン" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "無機質" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "8" ]
                                ]
                            ]
                        , H.section [] [ H.text "派生元：ブレードロール" ]
                        , H.table [ Attrs.class "waza-enemies" ]
                            [ H.tr []
                                [ H.th [ Attrs.class "number" ] [ H.text "#" ]
                                , H.th [ Attrs.class "spark-rate" ] [ H.text "閃き率" ]
                                , H.th [ Attrs.class "enemy-name" ] [ H.text "モンスター" ]
                                , H.th [ Attrs.class "enemy-type" ] [ H.text "種族" ]
                                , H.th [ Attrs.class "enemy-rank" ] [ H.text "ランク" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "1" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "20.4" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "ニクサー" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "水棲" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "4" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "2" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "20.4" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "スケルトン" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "骸骨" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "6" ]
                                ]
                            , H.tr []
                                [ H.td [ Attrs.class "number" ] [ H.text "3" ]
                                , H.td [ Attrs.class "spark-rate" ] [ H.text "20.4" ]
                                , H.td [ Attrs.class "enemy-name" ] [ H.text "オーガ" ]
                                , H.td [ Attrs.class "enemy-type" ] [ H.text "獣人" ]
                                , H.td [ Attrs.class "enemy-rank" ] [ H.text "6" ]
                                ]
                            ]
                        ]
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


wazaParry : IndexedWaza
wazaParry =
    IndexedWaza 0 <| Repos.Waza 16 "パリイ" 0 0 1 Repos.WeaponSword


wazaDoubleCut : IndexedWaza
wazaDoubleCut =
    IndexedWaza 1 <| Repos.Waza 17 "二段斬り" 2 3 2 Repos.WeaponSword


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
