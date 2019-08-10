module DataTest exposing (suite)

import Data
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "The Data module"
        [ describe "findWazaDeriviations" findWazaDeriviationsTests
        , describe "findEnemiesForSpark" findEnemiesForSparkTests
        ]


findWazaDeriviationsTests : List Test
findWazaDeriviationsTests =
    let
        wazaSwordAttack =
            Data.Waza 0 "(通常攻撃：剣)" 0 3 1 Data.WeaponSword

        wazaParry =
            Data.Waza 16 "パリイ" 0 0 1 Data.WeaponSword

        wazaGreatSwordAttack =
            Data.Waza 1 "(通常攻撃：大剣)" 0 3 1 Data.WeaponGreatSword

        wazaPowerHit =
            Data.Waza 43 "強撃" 3 6 1 Data.WeaponGreatSword

        wazaDropCut =
            Data.Waza 45 "切り落とし" 5 6 1 Data.WeaponGreatSword

        wazaSwallowCut =
            Data.Waza 46 "ツバメ返し" 9 5 2 Data.WeaponGreatSword

        wazaKick =
            Data.Waza 149 "キック" 0 4 1 Data.WeaponMartialSkill

        wazaSobat =
            Data.Waza 150 "ソバット" 2 6 1 Data.WeaponMartialSkill

        wazaCapoeiraKick =
            Data.Waza 157 "カポエラキック" 6 9 1 Data.WeaponMartialSkill
    in
    [ test "閃かない技を指定した場合、空のリストを返す" <|
        \_ ->
            -- (通常攻撃：剣) を閃くことはない
            Data.findWazaDeriviations wazaSwordAttack
                |> Expect.equal (Data.WazaDeriviation wazaSwordAttack [])
    , test "パリイを指定した場合、派生元の技に (通常攻撃：剣) の 1件だけを含むリストを返す" <|
        \_ ->
            Data.findWazaDeriviations wazaParry
                |> Expect.equal
                    (Data.WazaDeriviation wazaParry
                        [ Data.FromWaza wazaSwordAttack 5
                        ]
                    )
    , test "カポエラキックを指定した場合、派生元の技にキック、ソバットの 2件だけを含むリストを返す" <|
        \_ ->
            Data.findWazaDeriviations wazaCapoeiraKick
                |> Expect.equal
                    (Data.WazaDeriviation wazaCapoeiraKick
                        [ Data.FromWaza wazaKick 28
                        , Data.FromWaza wazaSobat 21
                        ]
                    )
    , test "ツバメ返しを指定した場合、派生元の技に (通常攻撃：大剣)、強撃、切り落としの 3件だけを含むリストを返す" <|
        \_ ->
            Data.findWazaDeriviations wazaSwallowCut
                |> Expect.equal
                    (Data.WazaDeriviation wazaSwallowCut
                        [ Data.FromWaza wazaGreatSwordAttack 40
                        , Data.FromWaza wazaPowerHit 34
                        , Data.FromWaza wazaDropCut 37
                        ]
                    )
    ]


findEnemiesForSparkTests : List Test
findEnemiesForSparkTests =
    let
        -- ソート条件である閃き率、敵のランク、敵の ID を
        -- 確認しやすい形式に変換する
        pretty : Data.EnemyWithSparkRatio -> ( Float, ( Int, Int, String ) )
        pretty { enemy, sparkRatio } =
            ( sparkRatio, ( enemy.rank, enemy.id, enemy.name ) )
    in
    [ describe "閃き難度を基に、閃き率の降順、敵のランクの昇順、敵の ID の昇順でソートされた敵のリストを返す"
        [ test "閃き難度が 49 の場合、空のリストを返す" <|
            \_ ->
                -- 閃き難度が敵の技レベルよりも 6 以上高い場合、
                -- 閃き率は 0% になる。
                -- 敵の技レベルの最高はアルビオンの 43 だけなので、
                -- 閃き難度が 49 以上の場合は該当する敵がいない。
                Data.findEnemiesForSpark 49
                    |> Expect.equal []
        , test "閃き難度が 48 の場合、アルビオンだけを含むリストを返す" <|
            \_ ->
                Data.findEnemiesForSpark 48
                    |> List.map pretty
                    |> Expect.equal
                        [ ( 0.4, ( 16, 143, "アルビオン" ) )
                        ]
        , test "閃き難度が 47 の場合、アルビオン、ディアブロ、トウテツ、ミスティックの順に並んだリストを返す" <|
            \_ ->
                Data.findEnemiesForSpark 47
                    |> List.map pretty
                    |> Expect.equal
                        [ ( 0.8, ( 16, 143, "アルビオン" ) )
                        , ( 0.4, ( 16, 79, "ディアブロ" ) )
                        , ( 0.4, ( 16, 95, "トウテツ" ) )
                        , ( 0.4, ( 16, 223, "ミスティック" ) )
                        ]
        , test "閃き難度が 42 の場合、先頭から 4件がディアブロ、トウテツ、ミスティック、アルビオンの順に並んだリストを返す" <|
            \_ ->
                Data.findEnemiesForSpark 42
                    |> List.take 4
                    |> List.map pretty
                    |> Expect.equal
                        [ ( 20.4, ( 16, 79, "ディアブロ" ) )
                        , ( 20.4, ( 16, 95, "トウテツ" ) )
                        , ( 20.4, ( 16, 223, "ミスティック" ) )
                        , ( 7.8, ( 16, 143, "アルビオン" ) )
                        ]
        , test "閃き難度が 35 の場合、先頭から 4件がヒューリオン、ビーストメア、アルラウネ、ゴールデンバウムの順に並び、その後ろに閃き率 9.8% の敵、9.4% の敵が続くリストを返す" <|
            \_ ->
                Data.findEnemiesForSpark 35
                    |> List.take 26
                    |> List.map pretty
                    |> Expect.equal
                        [ ( 20.4, ( 13, 76, "ヒューリオン" ) )
                        , ( 20.4, ( 14, 45, "ビーストメア" ) )
                        , ( 20.4, ( 14, 157, "アルラウネ" ) )
                        , ( 20.4, ( 16, 191, "ゴールドバウム" ) )

                        -- 閃き率 9.8%
                        , ( 9.8, ( 15, 78, "ナックラビー" ) )
                        , ( 9.8, ( 16, 15, "ヘルビースト" ) )
                        , ( 9.8, ( 16, 31, "獄竜" ) )
                        , ( 9.8, ( 16, 47, "ラルヴァクィーン" ) )
                        , ( 9.8, ( 16, 79, "ディアブロ" ) )
                        , ( 9.8, ( 16, 95, "トウテツ" ) )
                        , ( 9.8, ( 16, 111, "カイザーアント" ) )
                        , ( 9.8, ( 16, 127, "ヴリトラ" ) )
                        , ( 9.8, ( 16, 143, "アルビオン" ) )
                        , ( 9.8, ( 16, 175, "ベインサーペント" ) )
                        , ( 9.8, ( 16, 223, "ミスティック" ) )

                        -- 閃き率 9.4%
                        , ( 9.4, ( 15, 14, "スカルロード" ) )
                        , ( 9.4, ( 15, 46, "ロビンハット" ) )
                        , ( 9.4, ( 15, 62, "ナイトフォーク" ) )
                        , ( 9.4, ( 15, 94, "ヌエ" ) )
                        , ( 9.4, ( 15, 126, "メドゥサ" ) )
                        , ( 9.4, ( 15, 174, "首長竜" ) )
                        , ( 9.4, ( 16, 63, "フォージウィルム" ) )
                        , ( 9.4, ( 16, 207, "セフィラス" ) )
                        , ( 9.4, ( 16, 239, "フィア" ) )
                        , ( 9.4, ( 16, 255, "リザードロード" ) )
                        , ( 9.4, ( 40, 305, "金龍" ) )
                        ]
        ]
    ]
