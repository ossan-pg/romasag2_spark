module RepositoryTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Repository as Repos
import Test exposing (..)


suite : Test
suite =
    describe "The Repos module"
        [ describe "findWazaDerivations" findWazaDerivationsTests
        , describe "findEnemiesForSpark" findEnemiesForSparkTests
        ]


findWazaDerivationsTests : List Test
findWazaDerivationsTests =
    let
        wazaSwordAttack =
            Repos.Waza 0 "(通常攻撃：剣)" 0 3 1 Repos.WeaponSword

        wazaParry =
            Repos.Waza 16 "パリイ" 0 0 1 Repos.WeaponSword

        wazaGreatSwordAttack =
            Repos.Waza 1 "(通常攻撃：大剣)" 0 3 1 Repos.WeaponGreatSword

        wazaPowerHit =
            Repos.Waza 43 "強撃" 3 6 1 Repos.WeaponGreatSword

        wazaDropCut =
            Repos.Waza 45 "切り落とし" 5 6 1 Repos.WeaponGreatSword

        wazaSwallowCut =
            Repos.Waza 46 "ツバメ返し" 9 5 2 Repos.WeaponGreatSword

        wazaKick =
            Repos.Waza 149 "キック" 0 4 1 Repos.WeaponMartialSkill

        wazaSobat =
            Repos.Waza 150 "ソバット" 2 6 1 Repos.WeaponMartialSkill

        wazaCapoeiraKick =
            Repos.Waza 157 "カポエラキック" 6 9 1 Repos.WeaponMartialSkill
    in
    [ test "閃かない技を指定した場合、空のリストを返す" <|
        \_ ->
            -- (通常攻撃：剣) を閃くことはない
            Repos.findWazaDerivations wazaSwordAttack
                |> Expect.equal (Repos.WazaDerivation wazaSwordAttack [])
    , test "パリイを指定した場合、派生元の技に (通常攻撃：剣) の 1件だけを含むリストを返す" <|
        \_ ->
            Repos.findWazaDerivations wazaParry
                |> Expect.equal
                    (Repos.WazaDerivation wazaParry
                        [ Repos.FromWaza wazaSwordAttack 5
                        ]
                    )
    , test "カポエラキックを指定した場合、派生元の技にキック、ソバットの 2件だけを含むリストを返す" <|
        \_ ->
            Repos.findWazaDerivations wazaCapoeiraKick
                |> Expect.equal
                    (Repos.WazaDerivation wazaCapoeiraKick
                        [ Repos.FromWaza wazaKick 28
                        , Repos.FromWaza wazaSobat 21
                        ]
                    )
    , test "ツバメ返しを指定した場合、派生元の技に (通常攻撃：大剣)、強撃、切り落としの 3件だけを含むリストを返す" <|
        \_ ->
            Repos.findWazaDerivations wazaSwallowCut
                |> Expect.equal
                    (Repos.WazaDerivation wazaSwallowCut
                        [ Repos.FromWaza wazaGreatSwordAttack 40
                        , Repos.FromWaza wazaPowerHit 34
                        , Repos.FromWaza wazaDropCut 37
                        ]
                    )
    ]


findEnemiesForSparkTests : List Test
findEnemiesForSparkTests =
    let
        -- ソート条件である閃き率、敵のランク、敵の ID を
        -- 確認しやすい形式に変換する
        pretty : Repos.EnemyWithSparkRate -> ( Float, ( Int, Int, String ) )
        pretty { enemy, sparkRate } =
            ( sparkRate, ( enemy.rank, enemy.id, enemy.name ) )
    in
    [ describe "閃き難度を基に、閃き率の降順、敵のランクの昇順、敵の ID の昇順でソートされた敵のリストを返す"
        [ test "閃き難度が 49 の場合、空のリストを返す" <|
            \_ ->
                -- 閃き難度が敵の技レベルよりも 6 以上高い場合、
                -- 閃き率は 0% になる。
                -- 敵の技レベルの最高はアルビオンの 43 だけなので、
                -- 閃き難度が 49 以上の場合は該当する敵がいない。
                Repos.findEnemiesForSpark 49
                    |> Expect.equal []
        , test "閃き難度が 48 の場合、アルビオンだけを含むリストを返す" <|
            \_ ->
                Repos.findEnemiesForSpark 48
                    |> List.map pretty
                    |> Expect.equal
                        [ ( 0.4, ( 16, 143, "アルビオン" ) )
                        ]
        , test "閃き難度が 47 の場合、アルビオン、ディアブロ、トウテツ、ミスティックの順に並んだリストを返す" <|
            \_ ->
                Repos.findEnemiesForSpark 47
                    |> List.map pretty
                    |> Expect.equal
                        [ ( 0.8, ( 16, 143, "アルビオン" ) )
                        , ( 0.4, ( 16, 79, "ディアブロ" ) )
                        , ( 0.4, ( 16, 95, "トウテツ" ) )
                        , ( 0.4, ( 16, 223, "ミスティック" ) )
                        ]
        , test "閃き難度が 42 の場合、先頭から 4件がディアブロ、トウテツ、ミスティック、アルビオンの順に並んだリストを返す" <|
            \_ ->
                Repos.findEnemiesForSpark 42
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
                Repos.findEnemiesForSpark 35
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
