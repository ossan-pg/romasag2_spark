module DataTest exposing (suite)

import Data
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "The Data module"
        [ describe "findWazaDeriviations"
            -- キャラクターを設定
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
        ]


wazaSwordAttack : Data.Waza
wazaSwordAttack =
    Data.Waza 0 "(通常攻撃：剣)" 0 3 1 Data.WeaponSword


wazaParry : Data.Waza
wazaParry =
    Data.Waza 16 "パリイ" 0 0 1 Data.WeaponSword


wazaGreatSwordAttack : Data.Waza
wazaGreatSwordAttack =
    Data.Waza 1 "(通常攻撃：大剣)" 0 3 1 Data.WeaponGreatSword


wazaPowerHit : Data.Waza
wazaPowerHit =
    Data.Waza 43 "強撃" 3 6 1 Data.WeaponGreatSword


wazaDropCut : Data.Waza
wazaDropCut =
    Data.Waza 45 "切り落とし" 5 6 1 Data.WeaponGreatSword


wazaSwallowCut : Data.Waza
wazaSwallowCut =
    Data.Waza 46 "ツバメ返し" 9 5 2 Data.WeaponGreatSword


wazaKick : Data.Waza
wazaKick =
    Data.Waza 149 "キック" 0 4 1 Data.WeaponMartialSkill


wazaSobat : Data.Waza
wazaSobat =
    Data.Waza 150 "ソバット" 2 6 1 Data.WeaponMartialSkill


wazaCapoeiraKick : Data.Waza
wazaCapoeiraKick =
    Data.Waza 157 "カポエラキック" 6 9 1 Data.WeaponMartialSkill
