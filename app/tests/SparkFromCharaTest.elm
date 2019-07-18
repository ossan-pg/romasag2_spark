module SparkFromCharaTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import SparkFromChara exposing (..)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (classes, tag, text)


suite : Test
suite =
    let
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
    in
    describe "The SparkFromChara module"
        [ describe "view"
            [ test "剣の技が表示対象の場合、剣ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "剣" "selected" <|
                        { unselectedAllWeaponTypes | sword = True }
            , test "剣の技が表示対象外の場合、剣ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "剣" "unselected" <|
                        { selectedAllWeaponTypes | sword = False }
            , test "大剣の技が表示対象の場合、大剣ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "大剣" "selected" <|
                        { unselectedAllWeaponTypes | greatSword = True }
            , test "大剣の技が表示対象外の場合、大剣ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "大剣" "unselected" <|
                        { selectedAllWeaponTypes | greatSword = False }
            , test "斧の技が表示対象の場合、斧ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "斧" "selected" <|
                        { unselectedAllWeaponTypes | axe = True }
            , test "斧の技が表示対象外の場合、斧ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "斧" "unselected" <|
                        { selectedAllWeaponTypes | axe = False }
            , test "棍棒の技が表示対象の場合、棍棒ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "棍棒" "selected" <|
                        { unselectedAllWeaponTypes | mace = True }
            , test "棍棒の技が表示対象外の場合、棍棒ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "棍棒" "unselected" <|
                        { selectedAllWeaponTypes | mace = False }
            , test "槍の技が表示対象の場合、槍ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "槍" "selected" <|
                        { unselectedAllWeaponTypes | spear = True }
            , test "槍の技が表示対象外の場合、槍ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "槍" "unselected" <|
                        { selectedAllWeaponTypes | spear = False }
            , test "小剣の技が表示対象の場合、小剣ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "小剣" "selected" <|
                        { unselectedAllWeaponTypes | shortSword = True }
            , test "小剣の技が表示対象外の場合、小剣ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "小剣" "unselected" <|
                        { selectedAllWeaponTypes | shortSword = False }
            , test "弓の技が表示対象の場合、弓ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "弓" "selected" <|
                        { unselectedAllWeaponTypes | bow = True }
            , test "弓の技が表示対象外の場合、弓ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "弓" "unselected" <|
                        { selectedAllWeaponTypes | bow = False }
            , test "体術の技が表示対象の場合、体術ボタンに selected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "体術" "selected" <|
                        { unselectedAllWeaponTypes | martialSkill = True }
            , test "体術の技が表示対象外の場合、体術ボタンに unselected クラスを設定する" <|
                \_ ->
                    verifyClassOfButton "体術" "unselected" <|
                        { selectedAllWeaponTypes | martialSkill = False }
            ]
        ]


verifyClassOfButton : String -> String -> SelectedWeaponTypes -> Expectation
verifyClassOfButton weaponType className selectedWeaponTypes =
    Model selectedWeaponTypes
        |> view
        |> Query.fromHtml
        |> Query.find [ classes [ "weapon-type-filter" ] ]
        |> Query.find [ tag "button", classes [ className ] ]
        |> Query.has [ text weaponType ]
