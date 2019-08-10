module Data exposing
    ( CharaClassSymbol(..), CharaClass, charaClasses
    , SparkTypeSymbol(..), sparkTypeToName, Chara, charas
    , WeaponTypeSymbol(..), Waza, wazas, sparkTypeToWazas
    , FromWaza, WazaDeriviation, findWazaDeriviations
    , EnemyTypeSymbol(..), enemyTypeToName, Enemy, enemies
    , EnemyWithSparkRatio, findEnemiesForSpark
    )

{-|

@docs CharaClassSymbol, CharaClass, charaClasses
@docs SparkTypeSymbol, sparkTypeToName, Chara, charas
@docs WeaponTypeSymbol, Waza, wazas, sparkTypeToWazas
@docs FromWaza, WazaDeriviation, findWazaDeriviations
@docs EnemyTypeSymbol, enemyTypeToName, Enemy, enemies
@docs EnemyWithSparkRatio, findEnemiesForSpark

-}

import List.Extra as ListEx
import Set exposing (Set)


type CharaClassSymbol
    = HeavyInfantry -- 帝国重装歩兵
    | LightInfantryM -- 帝国軽装歩兵(男)
    | LightInfantryF -- 帝国軽装歩兵(女)
    | RangerM -- 帝国猟兵(男)
    | RangerF -- 帝国猟兵(女)
    | CourtMageM -- 宮廷魔術師(男)
    | CourtMageF -- 宮廷魔術師(女)
    | MercenaryM -- フリーファイター(男)
    | MercenaryF -- フリーファイター(女)
    | MageForHireM -- フリーメイジ(男)
    | MageForHireF -- フリーメイジ(女)
    | ImperialGuardM -- インペリアルガード(男)
    | ImperialGuardF -- インペリアルガード(女)
    | Strategist -- 軍師
    | LevanteGuard -- イーストガード
    | DesertGuard -- デザートガード
    | Amazon -- アマゾネス
    | Hunter -- ハンター
    | NomadM -- ノーマッド(男)
    | NomadF -- ノーマッド(女)
    | CrusaderM -- ホーリーオーダー(男)
    | CrusaderF -- ホーリーオーダー(女)
    | Diver -- 海女
    | ArmedMerchant -- 武装商船団
    | SaigoClansman -- サイゴ族
    | Brawler -- 格闘家
    | VagabondM -- シティシーフ(男)
    | VagabondF -- シティシーフ(男)
    | Salamander -- サラマンダー
    | Mole -- モール
    | Nereid -- ネレイド
    | Iris -- イーリス
    | SpecialChara -- 特殊(レオン、ジェラール、コッペリア、最終皇帝)


type alias CharaClass =
    { charaClassType : CharaClassSymbol
    , id : Int
    , name : String
    , joinCondition : String
    }


charaClasses : List CharaClass
charaClasses =
    [ CharaClass HeavyInfantry 0 "帝国重装歩兵" "初期状態で加入済み。"
    , CharaClass LightInfantryM 1 "帝国軽装歩兵(男)" "初期状態で加入済み。"
    , CharaClass LightInfantryF 2 "帝国軽装歩兵(女)" "初期状態で加入済み。"
    , CharaClass RangerM 3 "帝国猟兵(男)" "初期状態で加入済み。"
    , CharaClass RangerF 4 "帝国猟兵(女)" "初期状態で加入済み。"
    , CharaClass CourtMageM 5 "宮廷魔術師(男)" "初期状態で加入済み。"
    , CharaClass CourtMageF 6 "宮廷魔術師(女)" "初期状態で加入済み。"
    , CharaClass MercenaryM 7 "フリーファイター(男)" "初期状態で加入済み。ゴブリン襲撃中はパーティーへの編成不可。"
    , CharaClass MercenaryF 8 "フリーファイター(女)" "初期状態で加入済み。ゴブリン襲撃中はパーティーへの編成不可。"
    , CharaClass MageForHireM 9 "フリーメイジ(男)" "玉座イベントで術研究所を建設する。"
    , CharaClass MageForHireF 10 "フリーメイジ(女)" "玉座イベントで術研究所を建設する。"
    , CharaClass ImperialGuardM 11 "インペリアルガード(男)" "玉座イベントでインペリアルガードを結成する。"
    , CharaClass ImperialGuardF 12 "インペリアルガード(女)" "玉座イベントでインペリアルガードを結成する。"
    , CharaClass Strategist 13 "軍師" "玉座イベントで大学を建設する → 大学の入学試験に合格する → 大学内の軍師に話しかける。"
    , CharaClass LevanteGuard 14 "イーストガード" "チョントウ城でセキシュウサイを倒した後、リャンシャンでイーストガードに話しかける(年代ジャンプをはさまないこと)。"
    , CharaClass DesertGuard 15 "デザートガード" "移動湖でノエルを倒す or 和解する → 移動湖 or テレルテバの酒場でデザートガードに話しかける。"
    , CharaClass Amazon 16 "アマゾネス" "サラマットでモンスターに襲われているアマゾネスを助ける → 女 or 人外の皇帝でアマゾネスに話しかける。もしくは、ロックブーケを倒す。"
    , CharaClass Hunter 17 "ハンター" "白アリの巣でクィーンを倒す → 南の集落のハンターに話しかける。"
    , CharaClass NomadM 18 "ノーマッド(男)" "地上戦艦でボクオーンを倒す。"
    , CharaClass NomadF 19 "ノーマッド(女)" "地上戦艦でボクオーンを倒す。"
    , CharaClass CrusaderM 20 "ホーリーオーダー(男)" "サイフリートの砦でサイフリートを倒す。"
    , CharaClass CrusaderF 21 "ホーリーオーダー(女)" "サイフリートの砦でサイフリートを倒す。"
    , CharaClass Diver 22 "海女" "沈没船のギャロンを倒す → トバの酒場の海女に話しかける。"
    , CharaClass ArmedMerchant 23 "武装商船団" "武装商船団問題イベントの選択肢で「服従」させる。もしくは、ギャロンの反乱イベントでギャロンを倒す。"
    , CharaClass SaigoClansman 24 "サイゴ族" "南のダンジョンのボスを倒す → ムーの越冬地のサイゴ族に話しかける。"
    , CharaClass Brawler 25 "格闘家" "モンスターの巣の中ボス(ゼラチナスマター)を倒す → 龍の穴で格闘家に話しかける → モンスターの巣の奥で話しかける。もしくは、モンスターの巣のボス(悪魔系)を倒す → 龍の穴でザ・ドラゴンを倒す → 年代ジャンプ or 全滅時の皇帝継承で候補に出てきた格闘家を皇帝にする。"
    , CharaClass VagabondM 26 "シティシーフ(男)" "アバロンの泥棒イベントでモンスターに襲われているシティシーフ(女)を助ける → シーフギルドで依頼を受け下水道のボス(ディープワン)を倒す → シティシーフに協力してもらい運河要塞を攻略する。"
    , CharaClass VagabondF 27 "シティシーフ(女)" "アバロンの泥棒イベントでモンスターに襲われているシティシーフ(女)を助ける → シーフギルドで依頼を受け下水道のボス(ディープワン)を倒す → シティシーフに協力してもらい運河要塞を攻略する。"
    , CharaClass Salamander 28 "サラマンダー" "コムルーン火山噴火危機のイベントでコムルーン火山頂上の岩を倒す → ゼミオのサラマンダー(ケルート)に話しかける。"
    , CharaClass Mole 29 "モール" "白アリの巣でクィーンを倒す → 年代ジャンプする。"
    , CharaClass Nereid 30 "ネレイド" "人魚イベント or 沈没船イベントの過程で魔女から人魚薬の材料を教えてもらう → ルドン高原のアクア湖でネレイドと話す → モールの住処で「モールのつぼ」を受け取る(クィーンは倒しておく) → アバロンの満月亭に泊まる → モールの住処で「月光のクシ」を受け取る → アクア湖でネレイドと話す。"
    , CharaClass Iris 31 "イーリス" "詩人の楽器を全て集める → チカパ山の頂上に到達する。"
    , CharaClass SpecialChara 40 "特殊" "【加入条件省略】"
    ]


type SparkTypeSymbol
    = SparkSword1 -- 剣1
    | SparkSword2 -- 剣2
    | SparkGreatSword1 -- 大剣1
    | SparkGreatSword2 -- 大剣2
    | SparkAxe -- 斧
    | SparkSpearAxe -- 槍斧
    | SparkMace -- 棍棒
    | SparkSpear -- 槍
    | SparkShortSword -- 小剣
    | SparkBow -- 弓
    | SparkMartialSkill1 --体術1
    | SparkMartialSkill2 --体術2
    | SparkGeneral -- 汎用
    | SparkSpell --術
    | SparkNothing --なし


sparkTypeToName : SparkTypeSymbol -> String
sparkTypeToName symbol =
    case symbol of
        SparkSword1 ->
            "剣1"

        SparkSword2 ->
            "剣2"

        SparkGreatSword1 ->
            "大剣1"

        SparkGreatSword2 ->
            "大剣2"

        SparkAxe ->
            "斧"

        SparkSpearAxe ->
            "槍斧"

        SparkMace ->
            "棍棒"

        SparkSpear ->
            "槍"

        SparkShortSword ->
            "小剣"

        SparkBow ->
            "弓"

        SparkMartialSkill1 ->
            "体術1"

        SparkMartialSkill2 ->
            "体術2"

        SparkGeneral ->
            "汎用"

        SparkSpell ->
            "術"

        SparkNothing ->
            "なし"


type alias Chara =
    { id : Int -- キャラ別の便宜上のID
    , name : String -- キャラ名
    , lp : Int -- LP
    , str : Int -- 腕力
    , dex : Int -- 器用さ
    , mag : Int -- 魔力
    , int : Int -- 理力
    , spd : Int -- 素早さ
    , sta : Int -- 体力
    , offsetSlash : Int -- 斬レベルの補正値
    , offsetStab : Int -- 突レベルの補正値
    , offsetBash : Int -- 殴レベルの補正値
    , offsetShoot : Int -- 射レベルの補正値
    , offsetMartial : Int -- 体術レベルの補正値
    , offsetFire : Int -- 火術レベルの補正値
    , offsetWater : Int -- 水術レベルの補正値
    , offsetWind : Int -- 風術レベルの補正値
    , offsetEarth : Int -- 地術レベルの補正値
    , offsetLight : Int -- 天術レベルの補正値
    , offsetDark : Int -- 冥術レベルの補正値
    , charaClassType : CharaClassSymbol -- キャラのクラス
    , charaOrder : Int -- キャラのクラス内での順番
    , sparkType : SparkTypeSymbol -- 閃きタイプ
    }


charas : List Chara
charas =
    -- 帝国重装歩兵
    [ Chara 0 "ベア" 14 16 12 15 12 11 23 3 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 1 SparkGeneral
    , Chara 1 "バイソン" 15 17 12 16 13 11 21 1 -7 1 -7 1 -7 -7 -7 -7 -7 -7 HeavyInfantry 2 SparkGeneral
    , Chara 2 "ウォーラス" 13 16 14 14 10 10 23 1 -7 1 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 3 SparkGeneral
    , Chara 3 "スネイル" 12 15 12 16 13 13 21 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 4 SparkSword2
    , Chara 4 "ヘッジホッグ" 11 18 12 16 12 11 22 0 0 -7 0 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 5 SparkGeneral
    , Chara 5 "トータス" 12 15 13 15 14 12 22 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 6 SparkGeneral
    , Chara 6 "ライノ" 13 16 14 15 11 13 21 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 7 SparkGeneral
    , Chara 7 "フェルディナント" 10 15 13 16 13 10 23 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 8 SparkGeneral

    -- 帝国軽装歩兵(男)
    , Chara 8 "ジェイムズ" 11 16 15 13 11 17 18 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 1 SparkGreatSword2
    , Chara 9 "ジョン" 13 16 15 14 10 18 17 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 2 SparkGreatSword2
    , Chara 10 "リチャード" 8 17 15 12 12 19 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 3 SparkSword1
    , Chara 11 "ハーバート" 10 18 16 14 11 17 17 1 1 1 1 -7 -7 -7 -6 -7 -7 -7 LightInfantryM 4 SparkSword2
    , Chara 12 "ハリー" 11 18 16 16 15 15 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 5 SparkGreatSword2
    , Chara 13 "ロナルド" 9 17 15 14 11 18 18 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 6 SparkGeneral
    , Chara 14 "ドワイト" 8 17 18 13 12 16 17 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 7 SparkGreatSword2
    , Chara 15 "フランクリン" 13 18 15 13 13 18 17 1 1 1 1 -7 -7 -5 -7 -7 -7 -7 LightInfantryM 8 SparkSword2

    -- 帝国軽装歩兵(女)
    , Chara 16 "ライーザ" 11 16 16 16 13 16 17 2 2 2 2 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 1 SparkShortSword
    , Chara 17 "ジェシカ" 8 16 18 17 10 14 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 2 SparkSword2
    , Chara 18 "シャーリー" 7 17 15 16 13 17 18 1 1 1 1 -7 -7 -7 -4 -7 -7 -7 LightInfantryF 3 SparkShortSword
    , Chara 19 "オードリー" 15 18 15 17 11 15 17 2 2 2 2 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 4 SparkSword2
    , Chara 20 "ジュディ" 10 17 15 16 16 18 18 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 5 SparkSword1
    , Chara 21 "グレース" 12 18 15 15 15 17 17 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 6 SparkSword2
    , Chara 22 "イングリット" 8 17 16 15 14 16 18 2 2 2 2 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 7 SparkShortSword
    , Chara 23 "グレタ" 9 17 15 15 11 17 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 8 SparkBow

    -- 帝国猟兵(男)
    , Chara 24 "ヘンリー" 12 13 22 13 11 16 15 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerM 1 SparkBow
    , Chara 25 "ルイ" 11 14 21 14 11 15 15 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 RangerM 2 SparkBow
    , Chara 26 "チャールズ" 10 15 20 13 12 15 14 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerM 3 SparkBow
    , Chara 27 "ウィリアム" 13 13 22 12 10 16 16 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerM 4 SparkBow
    , Chara 28 "フィリップ" 12 15 21 14 12 14 16 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 -7 RangerM 5 SparkBow
    , Chara 29 "エドワード" 10 16 20 11 14 17 15 -7 -7 -7 4 -7 -7 -7 -7 -7 -7 -7 RangerM 6 SparkBow
    , Chara 30 "アレクサンドル" 12 13 22 16 10 15 17 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 -7 RangerM 7 SparkBow
    , Chara 31 "フリードリッヒ" 15 14 21 13 12 16 15 -7 -7 -7 2 -7 -5 -7 -7 -7 -7 -7 RangerM 8 SparkBow

    -- 帝国猟兵(女)
    , Chara 32 "テレーズ" 10 13 20 15 10 16 14 -7 2 -7 2 -7 -7 -6 -7 -7 -7 -7 RangerF 1 SparkBow
    , Chara 33 "メアリー" 8 15 21 14 13 15 13 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerF 2 SparkShortSword
    , Chara 34 "アグネス" 6 14 20 17 12 16 12 -7 1 -7 1 -7 -7 -5 -7 -7 -5 -7 RangerF 3 SparkBow
    , Chara 35 "キャサリン" 7 13 22 15 11 15 14 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerF 4 SparkBow
    , Chara 36 "アン" 9 16 20 14 12 15 13 -7 -7 -7 1 -7 -7 -7 -7 -4 -7 -7 RangerF 5 SparkBow
    , Chara 37 "ユリアナ" 11 12 23 14 12 13 15 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 RangerF 6 SparkBow
    , Chara 38 "イザベラ" 7 14 21 19 10 14 12 -7 1 -7 1 -7 -7 -7 -7 -1 -7 -7 RangerF 7 SparkBow
    , Chara 39 "エリザベス" 8 13 22 15 12 13 15 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerF 8 SparkBow

    -- 宮廷魔術師(男)
    , Chara 40 "アリエス" 10 12 16 21 11 13 12 -7 -7 -5 -7 -7 -7 1 1 -7 -7 -7 CourtMageM 1 SparkMace
    , Chara 41 "サジタリウス" 12 10 19 19 10 14 10 -7 -7 -7 0 -7 -7 1 1 -7 -7 -7 CourtMageM 2 SparkBow
    , Chara 42 "ライブラ" 8 11 16 23 11 12 11 -7 -7 -7 -7 -7 -7 3 3 -7 -7 -7 CourtMageM 3 SparkSpell
    , Chara 43 "タウラス" 11 12 17 21 13 14 10 -7 -7 -7 -7 -7 -7 2 2 -7 -7 -7 CourtMageM 4 SparkSpell
    , Chara 44 "ジェミニ" 10 11 17 20 12 14 13 -7 -7 -7 -7 -7 -7 2 2 -7 -7 -7 CourtMageM 5 SparkSpell
    , Chara 45 "カプリコーン" 9 12 16 19 14 13 12 -7 -7 -4 -7 -7 -7 1 1 -7 -7 -7 CourtMageM 6 SparkMace
    , Chara 46 "キグナス" 13 13 18 21 14 12 12 -7 -7 -7 -7 -7 -7 2 2 -7 -7 -7 CourtMageM 7 SparkSpell
    , Chara 47 "クラックス" 10 11 17 20 12 15 11 -7 -7 -7 -7 -7 -7 1 1 -7 -7 -7 CourtMageM 8 SparkSpell

    -- 宮廷魔術師(女)
    , Chara 48 "エメラルド" 10 10 17 20 14 16 10 -7 -7 -7 -7 -7 2 -7 2 -7 -7 -7 CourtMageF 1 SparkSpell
    , Chara 49 "アメジスト" 8 10 17 19 13 15 13 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 2 SparkSpell
    , Chara 50 "オニキス" 11 10 18 20 12 16 11 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 3 SparkSpell
    , Chara 51 "トパーズ" 10 11 16 20 15 15 10 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 4 SparkSpell
    , Chara 52 "ガーネット" 8 11 16 21 14 15 11 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 5 SparkSpell
    , Chara 53 "オパール" 12 11 17 20 14 16 11 -7 -7 -7 -7 -7 2 -7 2 -7 -7 -7 CourtMageF 6 SparkSpell
    , Chara 54 "ルビー" 10 11 18 22 15 16 10 -7 -7 -7 -7 -7 3 -7 3 -7 -7 -7 CourtMageF 7 SparkSpell
    , Chara 55 "サファイア" 12 13 17 18 12 17 12 -7 3 -7 -7 -7 2 -7 2 -7 -7 -7 CourtMageF 8 SparkShortSword

    -- フリーファイター(男)
    , Chara 56 "ヘクター" 13 21 14 12 11 16 18 2 -7 2 -7 -7 -7 -7 -7 -6 -7 -7 MercenaryM 1 SparkGreatSword2
    , Chara 57 "オライオン" 11 20 15 13 10 17 16 3 -7 -7 -7 -7 -6 -7 -7 -7 -7 -7 MercenaryM 2 SparkSword1
    , Chara 58 "ジェイスン" 11 19 16 14 11 15 17 1 1 1 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryM 3 SparkSpearAxe
    , Chara 59 "シーシアス" 10 20 14 13 10 16 17 1 1 1 -7 -7 -7 -7 -5 -7 -7 -7 MercenaryM 4 SparkSpearAxe
    , Chara 60 "アキリーズ" 13 19 15 14 13 15 19 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryM 5 SparkGreatSword1
    , Chara 61 "ユリシーズ" 12 21 15 13 12 16 17 1 1 1 -7 -7 -7 -5 -7 -7 -7 -7 MercenaryM 6 SparkSpearAxe
    , Chara 62 "パーシアス" 11 18 16 13 12 17 16 2 -7 2 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryM 7 SparkGeneral
    , Chara 63 "ハーキュリーズ" 13 20 17 14 13 14 16 1 -7 1 -7 -7 -7 -7 -7 -7 -6 -7 MercenaryM 8 SparkGreatSword2

    -- フリーファイター(女)
    , Chara 64 "アンドロマケー" 11 19 16 15 11 13 18 1 -7 -7 1 -7 -7 -6 -7 -7 -7 -7 MercenaryF 1 SparkSword2
    , Chara 65 "シーデー" 10 18 17 15 11 15 16 1 -7 -7 1 1 -7 -7 -7 -7 -5 -7 MercenaryF 2 SparkBow
    , Chara 66 "メディア" 15 19 16 14 18 14 17 2 -7 2 2 -7 -6 -7 -7 -6 -7 -7 MercenaryF 3 SparkSword2
    , Chara 67 "ヒッポリュテー" 12 18 15 17 12 13 18 2 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryF 4 SparkSpearAxe
    , Chara 68 "デーイダメイア" 14 19 16 15 10 14 17 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryF 5 SparkGreatSword2
    , Chara 69 "ペネロープ" 11 20 16 14 11 13 19 2 -7 -7 -7 -7 -7 -7 -7 -5 -7 -7 MercenaryF 6 SparkSword2
    , Chara 70 "アンドロメダ" 7 17 18 15 13 15 17 1 -7 -7 1 -7 -7 -7 -6 -7 -7 -7 MercenaryF 7 SparkBow
    , Chara 71 "ディアネイラ" 10 19 16 14 13 14 18 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 MercenaryF 8 SparkGreatSword2

    -- フリーメイジ(男)
    , Chara 72 "レグルス" 10 12 15 20 15 17 15 -7 -7 -5 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 1 SparkMartialSkill1
    , Chara 73 "アルゴル" 8 12 16 19 13 16 15 -7 -7 -5 -7 -7 -7 2 -7 2 -7 -7 MageForHireM 2 SparkMace
    , Chara 74 "ポラリス" 10 11 16 21 12 16 16 -7 -7 -7 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 3 SparkSpell
    , Chara 75 "カノープス" 6 12 15 19 14 18 15 -7 -7 -5 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 4 SparkMace
    , Chara 76 "プロキオン" 8 10 16 20 15 17 15 -7 -7 -4 -7 -7 -7 2 -7 2 -7 -7 MageForHireM 5 SparkMace
    , Chara 77 "リゲル" 9 11 18 18 14 16 14 -7 -7 -6 -7 -7 -7 2 -7 2 -7 -7 MageForHireM 6 SparkBow
    , Chara 78 "ヴェガ" 13 12 14 22 12 17 15 -7 -7 -7 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 7 SparkSpell
    , Chara 79 "シリウス" 7 11 17 19 13 16 16 -7 -7 -6 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 8 SparkMace

    -- フリーメイジ(女)
    , Chara 80 "ローズ" 7 11 17 19 13 17 13 -7 -7 -5 -7 -7 2 -7 -7 2 -7 -7 MageForHireF 1 SparkSpell
    , Chara 81 "リリィ" 8 10 18 20 12 16 12 -7 -7 -4 -7 -7 3 -7 -7 3 -7 -7 MageForHireF 2 SparkShortSword
    , Chara 82 "デイジー" 10 11 17 18 13 19 13 -7 -7 -7 -7 -7 1 -7 -7 1 -7 -7 MageForHireF 3 SparkSpell
    , Chara 83 "アイリス" 9 10 15 22 17 15 12 -7 -7 -7 -7 -7 1 -7 -7 1 -7 -7 MageForHireF 4 SparkSpell
    , Chara 84 "マグノリア" 11 13 18 19 15 17 14 -7 -7 -5 -7 -7 3 -7 -7 3 -7 -7 MageForHireF 5 SparkMartialSkill2
    , Chara 85 "ヘイゼル" 7 11 17 20 16 16 13 -7 -7 -7 -7 -7 4 -7 -7 4 -7 -7 MageForHireF 6 SparkSpell
    , Chara 86 "アイヴィ" 8 10 17 19 15 18 11 -7 -7 -6 -7 -7 3 -7 -7 3 -7 -7 MageForHireF 7 SparkShortSword
    , Chara 87 "ウィンドシード" 9 11 17 20 16 17 13 -7 -7 -7 -7 -7 2 -7 -7 2 -7 -7 MageForHireF 8 SparkSpell

    -- インペリアルガード(男)
    , Chara 88 "ワレンシュタイン" 12 23 10 11 10 12 20 3 3 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 1 SparkSpearAxe
    , Chara 89 "タンクレッド" 13 21 12 11 11 11 21 -7 2 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 2 SparkSpear
    , Chara 90 "ダブー" 12 22 10 12 12 14 19 -7 3 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 3 SparkSpear
    , Chara 91 "マールバラ" 14 23 11 13 14 13 18 -7 2 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 4 SparkSpear
    , Chara 92 "ハンニバル" 15 25 12 11 18 11 18 4 4 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 5 SparkSpearAxe
    , Chara 93 "エパミノンダス" 11 22 13 12 13 12 17 -7 2 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 6 SparkSpear
    , Chara 94 "グスタフ" 13 24 10 10 10 11 20 -7 3 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 7 SparkSpear
    , Chara 95 "ベリサリウス" 12 23 11 14 12 13 19 -7 2 -7 2 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 8 SparkSpearAxe

    -- インペリアルガード(女)
    , Chara 96 "ミネルバ" 11 20 12 17 12 10 17 2 2 -7 2 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 1 SparkSword2
    , Chara 97 "ルナ" 14 21 10 18 13 12 16 -7 2 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 2 SparkSpearAxe
    , Chara 98 "ユノー" 10 23 10 15 12 11 17 -7 3 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 3 SparkGeneral
    , Chara 99 "セレス" 13 22 10 15 13 13 16 2 2 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 4 SparkGreatSword2
    , Chara 100 "オーロラ" 12 21 11 17 15 10 17 -7 3 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 5 SparkSpearAxe
    , Chara 101 "フューリー" 11 19 13 18 15 11 16 -7 2 -7 2 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 6 SparkSpearAxe
    , Chara 102 "ヴィクトリア" 10 21 12 16 14 11 18 -7 3 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 7 SparkSpear
    , Chara 103 "ディアナ" 15 22 11 16 18 11 18 -7 2 2 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 8 SparkSword1

    -- 軍師
    , Chara 104 "シゲン" 10 10 11 21 12 23 11 -7 -7 -7 -7 -7 -7 3 3 -7 3 -7 Strategist 1 SparkSpell
    , Chara 105 "ハクヤク" 8 10 13 19 12 22 11 -7 -7 -7 -7 -7 3 -7 -7 3 3 -7 Strategist 2 SparkSpell
    , Chara 106 "タンプク" 9 10 11 20 11 24 11 -7 -7 -7 -5 -7 -7 3 -7 3 3 -7 Strategist 3 SparkSpell
    , Chara 107 "チュウタツ" 13 12 12 22 15 22 13 -7 -7 -7 -7 -7 5 -7 5 -7 5 -7 Strategist 4 SparkSpell
    , Chara 108 "コウキン" 11 10 11 21 13 23 10 -7 -7 -7 -7 -7 -7 3 3 -7 3 -7 Strategist 5 SparkSpell
    , Chara 109 "ハクゲン" 13 13 12 20 14 22 12 -4 -7 -7 -7 -7 4 -7 4 -7 4 -7 Strategist 6 SparkGreatSword1
    , Chara 110 "モウトク" 12 11 12 19 12 21 12 -7 -7 -7 -5 -7 -7 3 -7 3 3 -7 Strategist 7 SparkBow
    , Chara 111 "コウメイ" 5 10 10 25 10 25 10 -7 -7 -7 -7 -7 5 -7 -7 5 5 -7 Strategist 8 SparkSpell

    -- イーストガード
    , Chara 112 "ジュウベイ" 12 18 14 11 23 21 13 3 -7 -7 -7 -7 -7 -7 -6 -7 -7 -7 LevanteGuard 1 SparkGreatSword1
    , Chara 113 "テッシュウ" 14 17 13 13 13 20 11 1 -7 -7 -7 -7 -7 -6 -7 -7 -7 -7 LevanteGuard 2 SparkGreatSword1
    , Chara 114 "シュウサク" 13 16 15 12 14 21 10 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 3 SparkGreatSword1
    , Chara 115 "ガンリュウ" 10 18 10 11 12 21 11 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 4 SparkGreatSword1
    , Chara 116 "トシ" 11 20 12 13 15 20 12 3 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 5 SparkGreatSword1
    , Chara 117 "レンヤ" 13 19 14 12 12 21 10 4 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 6 SparkSword1
    , Chara 118 "ボクデン" 15 16 12 14 14 22 11 2 -7 -7 2 -7 -7 -7 -6 -7 -7 -7 LevanteGuard 7 SparkGreatSword1
    , Chara 119 "ソウジ" 1 22 12 14 13 24 11 3 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 8 SparkGreatSword1

    -- デザートガード
    , Chara 120 "シャールカーン" 12 19 12 17 16 13 18 2 -7 -7 -7 -7 -7 -7 -7 -4 -7 -7 DesertGuard 1 SparkSword1
    , Chara 121 "ネマーン" 11 20 13 16 14 12 19 1 -7 -7 1 -7 -7 -7 -5 -7 -7 -7 DesertGuard 2 SparkGeneral
    , Chara 122 "ダンダーン" 14 18 15 18 17 12 18 2 -7 -7 -7 -7 -7 -7 -7 -6 -7 -7 DesertGuard 3 SparkGeneral
    , Chara 123 "シャハリヤール" 15 19 13 16 15 13 19 1 -7 -7 1 1 -7 -7 -7 -5 -7 -7 DesertGuard 4 SparkSword2
    , Chara 124 "アバールハサン" 10 18 14 17 13 14 17 3 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 DesertGuard 5 SparkGeneral
    , Chara 125 "マルザワーン" 12 20 12 16 16 14 18 1 -7 -7 1 -7 -7 -7 -5 -7 -7 -7 DesertGuard 6 SparkGeneral
    , Chara 126 "アルマノス" 14 19 15 18 14 12 16 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 DesertGuard 7 SparkGeneral
    , Chara 127 "スライマーン" 13 19 14 18 13 13 19 2 -7 -7 2 2 -7 -7 -7 -6 -7 -7 DesertGuard 8 SparkSword1

    -- アマゾネス
    , Chara 128 "ジャンヌ" 11 17 19 13 10 17 19 -7 3 3 3 -7 -7 -7 -7 -7 -7 -7 Amazon 1 SparkSpearAxe
    , Chara 129 "クリームヒルト" 8 15 20 12 14 18 18 -7 2 2 2 -7 -7 -7 -7 -7 -7 -7 Amazon 2 SparkSpearAxe
    , Chara 130 "エカテリーナ" 15 14 18 15 21 16 21 1 -7 -7 1 1 -7 -7 -7 -7 -7 -7 Amazon 3 SparkSpearAxe
    , Chara 131 "テオドラ" 10 17 19 12 16 18 17 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 Amazon 4 SparkSpear
    , Chara 132 "アグリッピナ" 11 15 19 13 15 17 19 -7 2 2 2 -7 -7 -7 -7 -7 -7 -7 Amazon 5 SparkSpearAxe
    , Chara 133 "アルテミシア" 8 15 20 14 14 16 18 -7 -7 -7 5 -7 -7 -7 -7 -7 -6 -7 Amazon 6 SparkBow
    , Chara 134 "ブコウ" 13 16 17 14 13 15 20 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 Amazon 7 SparkSpearAxe
    , Chara 135 "トモエ" 14 19 18 12 18 17 18 3 3 -7 3 -7 -7 -7 -7 -7 -7 -7 Amazon 8 SparkSpearAxe

    -- ハンター
    , Chara 136 "ハムバ" 10 12 24 10 12 14 15 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 Hunter 1 SparkBow
    , Chara 137 "クワワ" 12 11 22 12 17 13 16 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 Hunter 2 SparkBow
    , Chara 138 "ムジュグ" 11 13 24 11 14 15 14 -7 -7 -7 2 2 -7 -7 -7 -7 -7 -7 Hunter 3 SparkBow
    , Chara 139 "バイ" 8 13 23 10 14 13 15 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 Hunter 4 SparkBow
    , Chara 140 "オセイ" 9 14 22 11 21 14 16 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 Hunter 5 SparkBow
    , Chara 141 "ランガリ" 10 15 21 11 16 13 14 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 Hunter 6 SparkBow
    , Chara 142 "ケチェワ" 14 12 24 11 13 12 17 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 Hunter 7 SparkBow
    , Chara 143 "ガダフム" 12 12 25 10 14 14 14 -7 -7 2 2 -7 -7 -7 -7 -7 -7 -7 Hunter 8 SparkBow

    -- ノーマッド(男)
    , Chara 144 "アルタン" 12 17 19 15 12 17 13 1 1 1 1 -7 -7 -7 -7 -5 -7 -7 NomadM 1 SparkSpearAxe
    , Chara 145 "ガルタン" 11 18 17 15 11 16 14 -7 -7 2 2 2 -7 -7 -7 -7 -7 -7 NomadM 2 SparkAxe
    , Chara 146 "バツー" 13 16 20 16 13 16 13 1 -7 1 1 -7 -7 -7 -7 -7 -7 -7 NomadM 3 SparkAxe
    , Chara 147 "エセン" 9 17 18 16 18 17 12 -7 -7 1 1 1 -7 -7 1 -7 -7 -7 NomadM 4 SparkSword1
    , Chara 148 "ダヤン" 11 18 18 17 10 15 13 1 -7 1 1 -7 -7 -7 -7 -6 -7 -7 NomadM 5 SparkAxe
    , Chara 149 "アクダ" 10 15 19 18 11 18 12 -7 -7 2 2 2 -7 -7 -7 -7 -7 -7 NomadM 6 SparkAxe
    , Chara 150 "アボキ" 10 17 18 15 13 16 15 -7 -7 1 1 -7 -7 -7 -7 -6 -7 -7 NomadM 7 SparkSpearAxe
    , Chara 151 "ボクトツ" 11 18 16 15 12 17 14 -7 -7 2 2 -7 -7 -7 -7 -7 -7 -7 NomadM 8 SparkAxe

    -- ノーマッド(女)
    , Chara 152 "ファティマ" 8 15 18 18 23 17 13 2 -7 2 2 -7 -7 -7 -7 -5 -7 -7 NomadF 1 SparkBow
    , Chara 153 "ベスマ" 9 16 17 18 12 16 15 -7 -7 1 1 -7 -6 -7 -7 -7 -7 -7 NomadF 2 SparkBow
    , Chara 154 "アリア" 9 14 19 20 10 16 13 -7 -7 1 1 -7 -7 -7 -7 -7 -7 -7 NomadF 3 SparkBow
    , Chara 155 "ミズラ" 10 14 19 17 13 18 14 -7 -7 2 2 -7 -7 -7 -7 -5 -7 -7 NomadF 4 SparkBow
    , Chara 156 "アズィーザ" 6 14 18 18 11 17 15 -7 -7 1 1 1 -7 -7 -7 -7 -7 -7 NomadF 5 SparkMace
    , Chara 157 "ドニヤ" 10 15 19 19 13 16 13 -7 -7 2 2 -7 -7 -7 -7 -7 -7 -7 NomadF 6 SparkSword2
    , Chara 158 "ノーズハトゥ" 11 12 20 16 11 19 14 -7 -7 1 1 -7 -7 -7 -6 -7 -7 -7 NomadF 7 SparkBow
    , Chara 159 "シャハラザード" 12 14 20 17 12 18 14 -7 -7 2 2 -7 -7 -7 -7 -6 -7 -7 NomadF 8 SparkBow

    -- ホーリーオーダー(男)
    , Chara 160 "ゲオルグ" 14 21 13 16 10 11 18 5 5 5 -7 -7 -7 4 -7 -7 -7 -7 CrusaderM 1 SparkSpearAxe
    , Chara 161 "ピーター" 13 20 14 15 11 13 17 3 3 -7 -7 -7 -7 -7 2 -7 -7 -7 CrusaderM 2 SparkGeneral
    , Chara 162 "ポール" 15 22 12 15 10 12 19 3 -7 -7 -7 -7 -7 2 -7 -7 -7 -7 CrusaderM 3 SparkSpearAxe
    , Chara 163 "ジェイコブ" 12 21 13 15 10 13 18 2 2 -7 -7 -7 -7 -7 -7 1 -7 -7 CrusaderM 4 SparkSpearAxe
    , Chara 164 "ベネディクト" 13 20 14 18 10 11 17 2 -7 -7 -7 -7 -7 2 -7 -7 -7 -7 CrusaderM 5 SparkSword1
    , Chara 165 "バランタイン" 15 22 13 17 11 12 16 4 -7 -7 -7 -7 -7 -7 -7 2 -7 -7 CrusaderM 6 SparkGeneral
    , Chara 166 "ウルバン" 12 21 12 15 10 14 17 2 -7 -7 -7 -7 -7 -7 1 -7 1 -7 CrusaderM 7 SparkSpearAxe
    , Chara 167 "クリストフ" 14 21 12 15 10 12 20 3 -7 -7 -7 3 -7 -7 -7 3 -7 -7 CrusaderM 8 SparkSword2

    -- ホーリーオーダー(女)
    , Chara 168 "ソフィア" 12 12 11 24 13 12 12 -7 -7 1 -7 -7 -7 4 -7 -7 4 -7 CrusaderF 1 SparkMace
    , Chara 169 "アガタ" 11 13 12 22 13 12 12 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 2 SparkSpell
    , Chara 170 "モニカ" 8 12 12 23 13 11 12 -7 -7 2 -7 -7 -7 2 -7 -7 2 -7 CrusaderF 3 SparkSpell
    , Chara 171 "ガートルード" 13 14 11 22 12 13 11 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 4 SparkSpell
    , Chara 172 "バルバラ" 11 13 10 22 13 14 14 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 5 SparkMace
    , Chara 173 "マチルダ" 12 14 12 21 12 13 13 -7 -7 2 -7 -7 -7 2 -7 -7 2 -7 CrusaderF 6 SparkMace
    , Chara 174 "マグダレーナ" 14 13 14 22 12 11 12 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 7 SparkSpell
    , Chara 175 "マリア" 12 13 11 23 11 12 13 -7 -7 1 -7 -7 -7 3 -7 -7 3 -7 CrusaderF 8 SparkMace

    -- 海女
    , Chara 176 "ナタリー" 8 15 16 18 13 19 17 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 1 SparkSpell
    , Chara 177 "マライア" 6 16 14 19 14 18 19 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 2 SparkSpell
    , Chara 178 "ジャニス" 7 14 15 18 11 19 16 -7 -4 -7 -7 -7 -7 -7 4 -7 4 -7 Diver 3 SparkSpell
    , Chara 179 "オリヴィア" 6 15 16 16 12 18 18 -7 -3 -7 -7 -7 -7 -7 1 -7 1 -7 Diver 4 SparkMace
    , Chara 180 "ケイト" 9 14 17 18 12 20 17 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 5 SparkSpell
    , Chara 181 "サラ" 8 16 14 18 13 17 18 -7 -3 -7 -7 -7 -7 -7 1 -7 1 -7 Diver 6 SparkSpell
    , Chara 182 "デビー" 11 17 15 17 12 19 19 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 7 SparkSpell
    , Chara 183 "リンダ" 8 14 17 18 22 18 17 -7 -4 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 8 SparkSpell

    -- 武装商船団
    , Chara 184 "エンリケ" 13 17 16 12 13 21 15 -7 -7 2 2 -7 -7 -4 -7 -7 -7 -7 ArmedMerchant 1 SparkAxe
    , Chara 185 "マゼラン" 12 18 14 13 16 20 17 -7 -7 3 -7 3 -7 -7 -7 -7 -7 -7 ArmedMerchant 2 SparkSpearAxe
    , Chara 186 "ガマ" 14 17 15 12 15 22 15 2 -7 2 -7 -7 -7 -7 -7 -7 -7 -7 ArmedMerchant 3 SparkBow
    , Chara 187 "マハン" 11 17 17 11 16 20 16 -7 -7 2 2 -7 -7 -3 -7 -7 -7 -7 ArmedMerchant 4 SparkSpearAxe
    , Chara 188 "フィッシャー" 13 18 14 12 20 20 17 -7 -7 2 -7 2 -7 -7 -7 -7 -7 -7 ArmedMerchant 5 SparkAxe
    , Chara 189 "ティルピッツ" 9 19 15 11 14 21 16 -7 2 2 -7 -7 -7 -7 -7 -7 -7 -7 ArmedMerchant 6 SparkSpearAxe
    , Chara 190 "テイワ" 12 16 18 11 15 20 16 -7 -7 1 1 -7 -7 -3 -7 -7 -7 -7 ArmedMerchant 7 SparkAxe
    , Chara 191 "ドレイク" 15 18 16 10 21 22 15 1 -7 1 1 -7 -7 -7 -2 -7 -7 -7 ArmedMerchant 8 SparkSword1

    -- サイゴ族
    , Chara 192 "エイリーク" 13 18 14 12 11 12 21 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 -7 SaigoClansman 1 SparkMace
    , Chara 193 "ハールファグル" 12 19 13 13 10 13 20 -7 -7 1 -7 1 -7 -7 -7 -7 -7 -7 SaigoClansman 2 SparkMace
    , Chara 194 "パールナ" 14 18 13 11 10 14 21 -7 -7 2 -7 2 -7 -7 -7 -7 -7 -7 SaigoClansman 3 SparkMartialSkill2
    , Chara 195 "アリンビョルン" 12 17 14 12 12 13 22 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 -7 SaigoClansman 4 SparkMace
    , Chara 196 "エギル" 14 19 11 13 11 15 21 -7 -7 1 -7 1 -7 -7 -7 -7 -7 -7 SaigoClansman 5 SparkMartialSkill1
    , Chara 197 "オーラーヴ" 11 17 13 11 10 11 22 -7 -7 2 -7 2 -7 -7 -7 -7 -7 -7 SaigoClansman 6 SparkMace
    , Chara 198 "シグルズ" 10 16 14 13 13 12 20 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 -7 SaigoClansman 7 SparkMace
    , Chara 199 "スノリ" 12 18 12 11 12 14 21 -7 -7 5 -7 5 -7 -7 -7 -7 -7 -7 SaigoClansman 8 SparkMartialSkill1

    -- 格闘家
    , Chara 200 "カール" 16 17 14 11 12 14 23 -7 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 Brawler 1 SparkMartialSkill2
    , Chara 201 "フリッツ" 14 19 11 10 11 15 22 -7 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 Brawler 2 SparkMartialSkill2
    , Chara 202 "ダイナマイト" 28 18 12 10 13 16 21 -7 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 Brawler 3 SparkMartialSkill2
    , Chara 203 "テリー" 13 17 13 11 12 14 23 -7 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 Brawler 4 SparkMartialSkill2
    , Chara 204 "ブルーザー" 14 19 11 10 10 15 24 -7 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 Brawler 5 SparkMartialSkill2
    , Chara 205 "ベイダー" 16 23 10 10 10 10 25 -7 -7 -7 -7 4 -7 -7 -7 -7 -7 -7 Brawler 6 SparkMartialSkill2
    , Chara 206 "ハセ" 19 17 13 11 11 16 23 -7 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 Brawler 7 SparkMartialSkill2
    , Chara 207 "ライガー" 13 18 14 10 11 18 19 -7 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 Brawler 8 SparkMartialSkill1

    -- シティシーフ(男)
    , Chara 208 "スパロー" 12 15 19 12 11 19 15 1 -7 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondM 1 SparkBow
    , Chara 209 "クロウ" 9 16 18 13 12 21 14 1 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 2 SparkShortSword
    , Chara 210 "ロビン" 13 15 19 13 11 19 15 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 3 SparkSword2
    , Chara 211 "ピジョン" 11 16 18 11 13 20 16 1 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 4 SparkSword2
    , Chara 212 "スターリング" 10 17 18 11 23 19 14 1 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 5 SparkSword1
    , Chara 213 "スイフト" 8 16 17 12 16 20 15 1 1 -7 -7 -7 -7 -7 -7 -3 -7 -7 VagabondM 6 SparkShortSword
    , Chara 214 "スラッシュ" 7 16 18 14 15 19 14 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 7 SparkSword1
    , Chara 215 "ファルコン" 10 15 17 13 12 21 13 0 0 -7 0 -7 -7 -7 -7 -7 -7 -7 VagabondM 8 SparkBow

    -- シティシーフ(男)
    , Chara 216 "キャット" 9 15 18 13 24 22 12 -7 1 -7 -7 1 -7 -7 -7 -7 0 -7 VagabondF 1 SparkMartialSkill2
    , Chara 217 "ビーバー" 11 13 18 15 11 19 13 -7 2 -7 -7 -7 -7 -4 -7 -7 -7 -7 VagabondF 2 SparkShortSword
    , Chara 218 "バジャー" 8 13 17 16 15 18 12 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondF 3 SparkBow
    , Chara 219 "マウス" 9 13 18 17 12 18 11 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondF 4 SparkShortSword
    , Chara 220 "ラビット" 7 14 17 13 23 21 10 -7 3 -7 -7 -7 -7 -7 -7 -7 -6 -7 VagabondF 5 SparkSword1
    , Chara 221 "フェレット" 9 15 18 14 16 19 11 -7 1 -7 -7 -7 -7 -7 2 -7 -7 -7 VagabondF 6 SparkSword1
    , Chara 222 "ウィーゼル" 6 13 18 15 18 20 10 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondF 7 SparkShortSword
    , Chara 223 "フォックス" 8 13 20 16 15 19 10 -7 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondF 8 SparkShortSword

    -- サラマンダー
    , Chara 224 "ケルート" 13 22 10 18 13 11 20 -7 -7 2 -7 2 3 -7 -7 -7 -7 -7 Salamander 1 SparkAxe
    , Chara 225 "タンボラ" 12 23 11 19 12 10 21 -7 -7 2 -7 2 4 -7 -7 -7 -7 -7 Salamander 2 SparkMace
    , Chara 226 "ガルンガン" 11 22 10 18 11 12 21 -7 -7 3 -7 3 3 -7 -7 -7 -7 -7 Salamander 3 SparkMartialSkill2
    , Chara 227 "アウ" 14 24 12 17 12 11 20 -7 -7 2 -7 2 5 -7 -7 -7 -7 -7 Salamander 4 SparkMartialSkill2
    , Chara 228 "メラピ" 12 21 11 16 13 10 22 -7 2 2 -7 2 4 -7 -7 -7 -7 -7 Salamander 5 SparkMace
    , Chara 229 "アグン" 13 22 10 17 16 12 21 -7 -7 2 -7 2 3 -7 -7 -7 -7 -7 Salamander 6 SparkAxe
    , Chara 230 "ソプタン" 11 21 11 19 11 12 22 -7 -7 2 -7 2 2 -7 -7 -7 -7 -7 Salamander 7 SparkGreatSword2
    , Chara 231 "パパンダヤン" 14 21 10 18 12 14 21 -7 -7 3 -7 3 3 -7 -7 -7 -7 -7 Salamander 8 SparkMartialSkill2

    -- モール
    , Chara 232 "シエロ" 12 10 21 18 14 11 22 -7 3 -7 -7 -7 -7 -7 -7 4 -7 -7 Mole 1 SparkShortSword
    , Chara 233 "レゴ" 13 12 22 19 15 10 20 -7 1 -7 -7 1 -7 -7 -7 3 -7 -7 Mole 2 SparkShortSword
    , Chara 234 "チェルノ" 15 11 21 18 13 12 21 -7 1 1 -7 -7 -7 -7 -7 2 -7 -7 Mole 3 SparkShortSword
    , Chara 235 "ポド" 12 10 22 17 12 11 21 -7 0 -7 -7 -7 -7 -7 -7 5 -7 -7 Mole 4 SparkShortSword
    , Chara 236 "ラト" 14 11 20 20 11 11 22 -7 2 -7 -7 2 -7 -7 -7 3 -7 -7 Mole 5 SparkShortSword
    , Chara 237 "グライ" 11 12 22 17 12 12 20 -7 1 -7 -7 -7 -7 -7 -7 4 -7 -7 Mole 6 SparkShortSword
    , Chara 238 "バーティ" 13 10 21 16 19 11 23 -7 1 -7 -7 1 -7 -7 -7 5 -7 -7 Mole 7 SparkShortSword
    , Chara 239 "ブルニ" 12 11 23 18 14 12 21 -7 2 -7 -7 2 -7 -7 -7 3 -7 -7 Mole 8 SparkShortSword

    -- ネレイド
    , Chara 240 "テティス" 8 10 22 19 14 21 10 -7 -7 -2 -7 -7 -7 4 -7 -7 -7 -7 Nereid 1 SparkSpell
    , Chara 241 "ペルーサ" 9 10 21 17 13 20 10 -7 -7 -3 -7 -7 -7 5 -7 -7 -7 -7 Nereid 2 SparkMace
    , Chara 242 "リューシアナッサ" 9 10 23 18 15 22 10 -7 -7 -2 -7 -7 -7 5 -7 -7 -7 -7 Nereid 3 SparkSpell
    , Chara 243 "メリテー" 7 10 22 17 13 21 10 -7 -7 -4 -7 -7 -7 4 -7 -7 -7 -7 Nereid 4 SparkSpell
    , Chara 244 "アムピトリーテ" 10 10 21 20 14 23 10 -7 -7 -3 -7 -7 -7 5 -7 -7 -7 -7 Nereid 5 SparkSpell
    , Chara 245 "ナウシトエ" 9 10 25 17 13 21 10 -7 -7 -2 -7 -7 -7 4 -7 -7 -7 -7 Nereid 6 SparkSpell
    , Chara 246 "サオー" 7 10 21 18 14 22 10 -7 -7 -3 -7 -7 -7 3 -7 -7 -7 -7 Nereid 7 SparkMace
    , Chara 247 "ガラテイア" 9 10 24 19 18 20 10 -7 -7 -1 -7 -7 -7 5 -7 -7 -7 -7 Nereid 8 SparkSpell

    -- イーリス
    , Chara 248 "ウィンディ" 7 10 17 21 13 20 10 -7 -7 -7 0 -7 -7 -7 5 -7 -7 -7 Iris 1 SparkBow
    , Chara 249 "クラウディア" 6 10 18 21 12 24 10 -7 -7 -7 -2 -7 -7 -7 3 -7 -7 -7 Iris 2 SparkBow
    , Chara 250 "スカイア" 8 10 19 24 11 21 10 -7 -7 -7 -7 -7 -7 -7 5 -7 -7 -7 Iris 3 SparkBow
    , Chara 251 "ブレズィア" 7 10 17 23 13 20 10 -7 -7 -7 -3 -7 -7 -7 4 -7 -7 -7 Iris 4 SparkBow
    , Chara 252 "ゲイル" 6 10 18 23 15 22 10 -7 -7 -7 -1 -7 -7 -7 4 -7 -7 -7 Iris 5 SparkBow
    , Chara 253 "エア" 8 10 17 24 12 21 10 -7 -7 -7 -7 -7 -7 -7 6 -7 -7 -7 Iris 6 SparkBow
    , Chara 254 "ストーミー" 7 10 19 24 15 20 10 -7 -7 -7 -7 -7 -7 -7 7 -7 -7 -7 Iris 7 SparkBow
    , Chara 255 "ナディール" 9 10 20 23 13 23 10 -7 -7 -7 -7 -7 -7 -7 5 -7 -7 -7 Iris 8 SparkBow

    -- 特殊
    , Chara 300 "レオン" 19 19 17 20 12 14 20 5 2 0 0 0 0 0 0 0 2 0 SpecialChara 0 SparkNothing
    , Chara 301 "ジェラール" 16 17 22 19 11 20 11 0 0 0 0 0 0 0 0 0 0 0 SpecialChara 0 SparkSpell
    , Chara 302 "コッペリア" 99 20 20 15 15 20 20 15 15 15 15 15 0 0 0 0 0 0 SpecialChara 0 SparkNothing
    , Chara 303 "最終皇帝(男)" 19 25 23 23 15 24 21 10 5 5 5 5 0 0 0 0 10 0 SpecialChara 0 SparkSword2
    , Chara 304 "最終皇帝(女)" 10 23 24 24 15 25 20 10 5 5 5 5 0 0 0 0 10 0 SpecialChara 0 SparkSword2
    ]


type WeaponTypeSymbol
    = WeaponSword -- 剣
    | WeaponGreatSword -- 大剣
    | WeaponAxe -- 斧
    | WeaponMace -- 棍棒
    | WeaponSpear -- 槍
    | WeaponShortSword -- 小剣
    | WeaponBow -- 弓
    | WeaponMartialSkill -- 体術


type alias Waza =
    { id : Int -- 技別の便宜上のID
    , name : String -- 技名
    , wp : Int -- 消費WP
    , atk : Int -- 1回当たりの攻撃力
    , nrOfAtk : Int -- 攻撃回数
    , weaponType : WeaponTypeSymbol -- 武器タイプ
    }


wazas : List Waza
wazas =
    [ Waza 0 "(通常攻撃：剣)" 0 3 1 WeaponSword
    , Waza 1 "(通常攻撃：大剣)" 0 3 1 WeaponGreatSword
    , Waza 2 "(通常攻撃：斧)" 0 3 1 WeaponAxe
    , Waza 3 "(通常攻撃：棍棒)" 0 3 1 WeaponMace
    , Waza 4 "(通常攻撃：槍)" 0 3 1 WeaponSpear
    , Waza 5 "(通常攻撃：小剣)" 0 3 1 WeaponShortSword
    , Waza 6 "(通常攻撃：弓)" 0 3 1 WeaponBow
    , Waza 7 "(通常攻撃：爪)" 0 3 1 WeaponMartialSkill
    , Waza 10 "パンチ" 0 3 1 WeaponMartialSkill
    , Waza 11 "ファイナルストライク" 1 12 1 WeaponSword
    , Waza 12 "ダンシングソード" 5 7 1 WeaponGreatSword
    , Waza 13 "シャッタースタッフ(攻撃)" 1 15 1 WeaponMace
    , Waza 14 "シャッタースタッフ(回復)" 1 10 1 WeaponMace
    , Waza 15 "なぎ払い" 0 2 1 WeaponSword
    , Waza 16 "パリイ" 0 0 1 WeaponSword
    , Waza 17 "二段斬り" 2 3 2 WeaponSword
    , Waza 18 "短冊斬り" 5 3 3 WeaponSword
    , Waza 19 "みじん斬り" 4 7 1 WeaponSword
    , Waza 20 "線斬り" 7 3 4 WeaponSword
    , Waza 21 "空圧波" 5 5 1 WeaponSword
    , Waza 22 "十文字斬り" 3 6 1 WeaponSword
    , Waza 23 "つむじ風" 4 6 1 WeaponSword
    , Waza 24 "音速剣" 5 7 1 WeaponSword
    , Waza 25 "光速剣" 8 10 1 WeaponSword
    , Waza 26 "真空斬り" 10 10 1 WeaponSword
    , Waza 27 "残像剣" 7 7 1 WeaponSword
    , Waza 28 "不動剣" 14 14 1 WeaponSword
    , Waza 29 "落月破斬" 1 4 1 WeaponSword
    , Waza 30 "プロミネンス斬" 4 7 1 WeaponSword
    , Waza 31 "風狼剣" 1 5 1 WeaponSword
    , Waza 32 "咬竜剣" 7 8 1 WeaponSword
    , Waza 33 "サクション" 4 3 1 WeaponSword
    , Waza 34 "分子分解" 5 0 1 WeaponSword
    , Waza 35 "スウォーム" 4 5 1 WeaponSword
    , Waza 36 "カマイタチ" 2 5 1 WeaponSword
    , Waza 37 "稲妻斬り" 4 6 1 WeaponSword
    , Waza 41 "みね打ち" 0 0 1 WeaponGreatSword
    , Waza 42 "巻き打ち" 1 4 1 WeaponGreatSword
    , Waza 43 "強撃" 3 6 1 WeaponGreatSword
    , Waza 44 "ディフレクト" 0 0 1 WeaponGreatSword
    , Waza 45 "切り落とし" 5 6 1 WeaponGreatSword
    , Waza 46 "ツバメ返し" 9 5 2 WeaponGreatSword
    , Waza 47 "水鳥剣" 6 6 1 WeaponGreatSword
    , Waza 48 "無無剣" 5 7 1 WeaponGreatSword
    , Waza 49 "無明剣" 13 14 1 WeaponGreatSword
    , Waza 50 "流し斬り" 7 6 1 WeaponGreatSword
    , Waza 51 "乱れ雪月花" 12 12 1 WeaponGreatSword
    , Waza 52 "清流剣" 7 8 1 WeaponGreatSword
    , Waza 53 "活人剣" 15 0 1 WeaponGreatSword
    , Waza 54 "雷殺斬" 3 7 1 WeaponGreatSword
    , Waza 55 "聖光" 2 4 1 WeaponGreatSword
    , Waza 56 "月影" 3 5 1 WeaponGreatSword
    , Waza 57 "一刀両断" 9 8 1 WeaponGreatSword
    , Waza 58 "退魔神剣" 4 5 1 WeaponGreatSword
    , Waza 59 "殺虫剣" 3 6 1 WeaponGreatSword
    , Waza 60 "殺人剣" 6 6 1 WeaponGreatSword
    , Waza 62 "アクスボンバー" 3 5 1 WeaponAxe
    , Waza 63 "トマホーク" 1 3 1 WeaponAxe
    , Waza 64 "一人時間差" 4 6 1 WeaponAxe
    , Waza 65 "ヨーヨー" 3 3 1 WeaponAxe
    , Waza 66 "大木断" 4 6 1 WeaponAxe
    , Waza 67 "ブレードロール" 8 8 1 WeaponAxe
    , Waza 68 "次元断" 9 0 1 WeaponAxe
    , Waza 69 "高速ナブラ" 9 5 3 WeaponAxe
    , Waza 70 "マキ割りスペシャル" 8 11 1 WeaponAxe
    , Waza 71 "スカイドライブ" 11 15 1 WeaponAxe
    , Waza 72 "フェザーシール" 1 0 1 WeaponAxe
    , Waza 73 "電光ブーメラン" 1 5 1 WeaponAxe
    , Waza 74 "死の舞い" 9 0 1 WeaponAxe
    , Waza 75 "幻体戦士法" 10 0 1 WeaponAxe
    , Waza 76 "デストラクション" 7 11 1 WeaponAxe
    , Waza 78 "返し突き" 0 4 1 WeaponMace
    , Waza 79 "脳天割り" 3 5 1 WeaponMace
    , Waza 80 "骨砕き" 5 6 1 WeaponMace
    , Waza 81 "削岩撃" 5 4 3 WeaponMace
    , Waza 82 "ダブルヒット" 4 4 2 WeaponMace
    , Waza 83 "地裂撃" 5 4 1 WeaponMace
    , Waza 84 "グランドスラム" 7 5 1 WeaponMace
    , Waza 85 "オゾンビート" 5 6 1 WeaponMace
    , Waza 86 "フルフラット" 6 7 1 WeaponMace
    , Waza 87 "かめごうら割り" 12 11 1 WeaponMace
    , Waza 88 "ウェアバスター" 1 5 1 WeaponMace
    , Waza 89 "動くな" 3 0 1 WeaponMace
    , Waza 90 "スペルエンハンス" 1 0 1 WeaponMace
    , Waza 91 "祝福" 2 0 1 WeaponMace
    , Waza 93 "グランドバスター" 3 5 1 WeaponMace
    , Waza 94 "足払い" 0 0 1 WeaponSpear
    , Waza 95 "二段突き" 2 3 2 WeaponSpear
    , Waza 96 "稲妻突き" 4 6 1 WeaponSpear
    , Waza 97 "くし刺し" 4 5 1 WeaponSpear
    , Waza 98 "チャージ" 3 6 1 WeaponSpear
    , Waza 99 "エイミング" 1 3 1 WeaponSpear
    , Waza 100 "風車" 2 5 1 WeaponSpear
    , Waza 101 "一文字突き" 5 7 1 WeaponSpear
    , Waza 102 "活殺化石衝" 6 7 1 WeaponSpear
    , Waza 103 "スパイラルチャージ" 10 11 1 WeaponSpear
    , Waza 104 "活殺獣神衝" 8 10 1 WeaponSpear
    , Waza 105 "無双三段" 9 13 1 WeaponSpear
    , Waza 106 "ポセイドンシュート" 2 6 1 WeaponSpear
    , Waza 107 "サンダーボルト" 5 5 1 WeaponSpear
    , Waza 108 "下り飛竜" 10 15 1 WeaponSpear
    , Waza 109 "サイコバインド" 6 6 1 WeaponSpear
    , Waza 112 "フェイント" 0 0 1 WeaponShortSword
    , Waza 113 "感電衝" 1 2 1 WeaponShortSword
    , Waza 114 "サイドワインダー" 3 5 1 WeaponShortSword
    , Waza 115 "マリオネット" 6 0 1 WeaponShortSword
    , Waza 116 "スネークショット" 6 6 1 WeaponShortSword
    , Waza 117 "マタドール" 2 6 1 WeaponShortSword
    , Waza 118 "乱れ突き" 8 4 3 WeaponShortSword
    , Waza 119 "プラズマスラスト" 4 5 1 WeaponShortSword
    , Waza 120 "スクリュードライバ" 6 7 1 WeaponShortSword
    , Waza 121 "幻惑剣" 8 9 1 WeaponShortSword
    , Waza 122 "ファイナルレター" 10 12 1 WeaponShortSword
    , Waza 124 "マッドバイター" 1 4 1 WeaponShortSword
    , Waza 126 "火龍出水" 6 0 1 WeaponShortSword
    , Waza 130 "百花繚乱" 7 8 1 WeaponShortSword
    , Waza 133 "瞬速の矢" 3 5 1 WeaponBow
    , Waza 134 "でたらめ矢" 2 3 1 WeaponBow
    , Waza 135 "影ぬい" 1 0 1 WeaponBow
    , Waza 136 "ビーストスレイヤー" 4 6 1 WeaponBow
    , Waza 137 "アローレイン" 4 5 1 WeaponBow
    , Waza 138 "二本射ち" 2 3 2 WeaponBow
    , Waza 139 "イド・ブレイク" 3 4 1 WeaponBow
    , Waza 140 "影矢" 8 6 1 WeaponBow
    , Waza 141 "バラージシュート" 10 8 1 WeaponBow
    , Waza 142 "落鳳破" 5 7 1 WeaponBow
    , Waza 143 "イヅナ" 10 12 1 WeaponBow
    , Waza 144 "ハートシーカー" 2 0 1 WeaponBow
    , Waza 145 "皆死ね矢" 7 0 1 WeaponBow
    , Waza 146 "スターライトアロー" 8 11 1 WeaponBow
    , Waza 149 "キック" 0 4 1 WeaponMartialSkill
    , Waza 150 "ソバット" 2 6 1 WeaponMartialSkill
    , Waza 151 "カウンター" 0 6 1 WeaponMartialSkill
    , Waza 152 "ネコだまし" 0 0 1 WeaponMartialSkill
    , Waza 153 "集気法" 0 3 1 WeaponMartialSkill
    , Waza 154 "気弾" 3 5 1 WeaponMartialSkill
    , Waza 155 "コークスクリュー" 4 8 1 WeaponMartialSkill
    , Waza 156 "不動金しばり" 2 0 1 WeaponMartialSkill
    , Waza 157 "カポエラキック" 6 9 1 WeaponMartialSkill
    , Waza 158 "マシンガンジャブ" 6 6 2 WeaponMartialSkill
    , Waza 159 "ジョルトカウンター" 3 9 1 WeaponMartialSkill
    , Waza 160 "クワドラブル" 9 12 1 WeaponMartialSkill
    , Waza 161 "活殺破邪法" 8 10 1 WeaponMartialSkill
    , Waza 162 "千手観音" 12 9 2 WeaponMartialSkill
    , Waza 163 "サラマンダークロー" 1 4 1 WeaponMartialSkill
    , Waza 164 "赤竜波" 4 7 1 WeaponMartialSkill
    , Waza 167 "ふみつけ" 16 10 1 WeaponMartialSkill
    , Waza 196 "ベルセルク" 8 0 1 WeaponMartialSkill
    , Waza 197 "地獄爪殺法" 3 5 1 WeaponMartialSkill
    ]


sparkTypeToWazas : SparkTypeSymbol -> List Waza
sparkTypeToWazas sparkType =
    let
        filterWazas : Set Int -> List Waza
        filterWazas wazaIds =
            List.filter (\{ id } -> Set.member id wazaIds) wazas
    in
    case sparkType of
        SparkSword1 ->
            filterWazas wazasOfSparkSword1

        SparkSword2 ->
            filterWazas wazasOfSparkSword2

        SparkGreatSword1 ->
            filterWazas wazasOfSparkGreatSword1

        SparkGreatSword2 ->
            filterWazas wazasOfSparkGreatSword2

        SparkAxe ->
            filterWazas wazasOfSparkAxe

        SparkSpearAxe ->
            filterWazas wazasOfSparkSpearAxe

        SparkMace ->
            filterWazas wazasOfSparkMace

        SparkSpear ->
            filterWazas wazasOfSparkSpear

        SparkShortSword ->
            filterWazas wazasOfSparkShortSword

        SparkBow ->
            filterWazas wazasOfSparkBow

        SparkMartialSkill1 ->
            filterWazas wazasOfSparkMartialSkill1

        SparkMartialSkill2 ->
            filterWazas wazasOfSparkMartialSkill2

        SparkGeneral ->
            filterWazas wazasOfSparkGeneral

        SparkSpell ->
            filterWazas wazasOfSparkSpell

        SparkNothing ->
            filterWazas wazasOfSparkNothing


wazasOfSparkSword1 =
    Set.fromList
        [ 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 42, 43, 44, 45, 47, 48, 49, 50, 51, 52, 54, 55, 56, 57, 58, 59, 60, 62, 63, 64, 66, 69, 70, 72, 73, 74, 75, 76, 78, 80, 82, 83, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 104, 106, 107, 108, 109, 113, 116, 117, 118, 119, 120, 121, 122, 124, 126, 130, 133, 134, 135, 137, 138, 144, 145, 146, 150, 151, 153, 154, 155 ]


wazasOfSparkSword2 =
    Set.fromList
        [ 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 44, 45, 47, 48, 50, 52, 54, 55, 56, 57, 58, 59, 60, 62, 63, 72, 73, 74, 75, 76, 78, 80, 82, 83, 88, 89, 90, 91, 93, 94, 96, 98, 99, 100, 101, 102, 106, 107, 108, 109, 113, 116, 117, 118, 119, 124, 126, 130, 133, 134, 135, 137, 138, 144, 145, 146, 150, 151, 153, 154, 158 ]


wazasOfSparkGreatSword1 =
    Set.fromList
        [ 16, 17, 18, 20, 21, 22, 23, 24, 26, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 42, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 62, 63, 66, 69, 70, 72, 73, 74, 75, 76, 78, 80, 82, 83, 88, 89, 90, 91, 93, 94, 96, 98, 99, 100, 101, 105, 106, 107, 108, 109, 113, 116, 117, 118, 121, 124, 126, 130, 133, 134, 135, 137, 138, 140, 142, 144, 145, 146, 150, 151, 152, 153, 154, 156, 161 ]


wazasOfSparkGreatSword2 =
    Set.fromList
        [ 16, 17, 21, 22, 23, 24, 26, 29, 30, 31, 32, 33, 34, 35, 36, 37, 42, 43, 44, 45, 47, 48, 50, 51, 52, 54, 55, 56, 57, 58, 59, 60, 62, 63, 66, 67, 70, 72, 73, 74, 75, 76, 78, 80, 82, 83, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 106, 107, 108, 109, 116, 117, 118, 120, 124, 126, 130, 133, 134, 135, 137, 138, 144, 145, 146, 150, 151, 153, 154, 155 ]


wazasOfSparkAxe =
    Set.fromList
        [ 16, 19, 21, 22, 23, 24, 29, 30, 31, 32, 33, 34, 35, 36, 37, 43, 44, 45, 47, 48, 54, 55, 56, 57, 58, 59, 60, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 80, 81, 82, 83, 84, 87, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 106, 107, 108, 109, 116, 117, 118, 124, 126, 130, 133, 134, 135, 137, 138, 144, 145, 146, 150, 151, 153, 154, 155 ]


wazasOfSparkSpearAxe =
    Set.fromList
        [ 16, 19, 21, 22, 23, 24, 26, 29, 30, 31, 32, 33, 34, 35, 36, 37, 43, 44, 45, 47, 48, 51, 54, 55, 56, 57, 58, 59, 60, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 80, 82, 83, 84, 85, 87, 88, 89, 90, 91, 93, 94, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 113, 115, 116, 117, 118, 119, 124, 126, 130, 133, 134, 135, 137, 144, 145, 146, 150, 151, 153, 154, 155, 161 ]


wazasOfSparkMace =
    Set.fromList
        [ 16, 19, 21, 22, 23, 24, 29, 30, 31, 32, 33, 34, 35, 36, 37, 43, 44, 47, 48, 54, 55, 56, 57, 58, 59, 60, 62, 63, 66, 70, 72, 73, 74, 75, 76, 78, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 106, 107, 108, 109, 116, 117, 118, 124, 126, 130, 133, 134, 137, 144, 145, 146, 150, 151, 152, 153, 154, 155 ]


wazasOfSparkSpear =
    Set.fromList
        [ 16, 21, 22, 23, 24, 29, 30, 31, 32, 33, 34, 35, 36, 37, 43, 44, 47, 48, 54, 55, 56, 57, 58, 59, 60, 62, 63, 66, 70, 72, 73, 74, 75, 76, 78, 80, 82, 83, 88, 89, 90, 91, 93, 94, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 116, 117, 118, 120, 124, 126, 130, 133, 134, 137, 144, 145, 146, 150, 151, 153, 154, 155, 161 ]


wazasOfSparkShortSword =
    Set.fromList
        [ 16, 21, 22, 23, 24, 25, 26, 29, 30, 31, 32, 33, 34, 35, 36, 37, 44, 47, 48, 54, 55, 56, 57, 58, 59, 60, 62, 63, 72, 73, 74, 75, 76, 78, 80, 82, 83, 88, 89, 90, 91, 93, 94, 97, 98, 99, 100, 101, 103, 106, 107, 108, 109, 113, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126, 130, 133, 134, 136, 137, 138, 143, 144, 145, 146, 150, 151, 153, 154, 155, 158, 159 ]


wazasOfSparkBow =
    Set.fromList
        [ 16, 21, 22, 23, 24, 26, 29, 30, 31, 32, 33, 34, 35, 36, 37, 44, 47, 48, 54, 55, 56, 57, 58, 59, 60, 62, 63, 72, 73, 74, 75, 76, 80, 82, 83, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 106, 107, 108, 109, 116, 117, 118, 121, 124, 126, 130, 133, 134, 135, 136, 137, 138, 140, 141, 142, 143, 144, 145, 146, 150, 151, 153, 154, 155 ]


wazasOfSparkMartialSkill1 =
    Set.fromList
        [ 16, 21, 22, 23, 24, 29, 43, 44, 46, 47, 48, 52, 62, 63, 66, 67, 70, 80, 82, 83, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 102, 104, 116, 117, 118, 133, 134, 135, 137, 142, 144, 145, 146, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 161, 162, 196 ]


wazasOfSparkMartialSkill2 =
    Set.fromList
        [ 16, 21, 22, 23, 24, 29, 43, 44, 47, 48, 62, 63, 66, 70, 80, 82, 83, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 116, 117, 118, 133, 134, 135, 137, 144, 145, 146, 150, 151, 153, 154, 155, 156, 157, 158, 159, 160, 162, 196 ]


wazasOfSparkGeneral =
    Set.fromList
        [ 16, 19, 21, 22, 23, 24, 26, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 43, 44, 47, 48, 51, 54, 55, 56, 57, 58, 59, 60, 62, 63, 66, 70, 72, 73, 74, 75, 76, 80, 81, 82, 83, 85, 88, 89, 90, 91, 93, 94, 97, 98, 99, 100, 101, 103, 104, 106, 107, 108, 109, 116, 117, 118, 120, 124, 126, 130, 133, 134, 135, 137, 144, 145, 146, 150, 151, 153, 154, 155 ]


wazasOfSparkSpell =
    Set.fromList
        [ 16, 21, 22, 23, 24, 29, 30, 31, 32, 33, 34, 35, 36, 37, 43, 44, 47, 48, 54, 55, 56, 57, 58, 59, 60, 62, 63, 66, 70, 72, 73, 74, 75, 76, 80, 82, 83, 88, 89, 90, 91, 93, 94, 98, 99, 100, 101, 106, 107, 108, 109, 116, 117, 118, 124, 126, 130, 133, 134, 135, 137, 144, 145, 146, 150, 151, 153, 154 ]


wazasOfSparkNothing =
    Set.fromList
        [ 16, 29, 30, 31, 32, 33, 34, 35, 36, 37, 44, 54, 55, 56, 57, 58, 59, 60, 72, 73, 74, 75, 76, 88, 89, 90, 91, 93, 100, 106, 107, 108, 109, 117, 124, 126, 130, 144, 145, 146, 151, 153 ]


type alias WazaDeriviation_ =
    { fromId : Int -- 派生元の技ID
    , toId : Int -- 派生先の技ID
    , sparkLevel : Int -- 閃き難度
    }


wazaDeriviations_ : List WazaDeriviation_
wazaDeriviations_ =
    [ WazaDeriviation_ 0 17 8
    , WazaDeriviation_ 0 18 19
    , WazaDeriviation_ 0 19 15
    , WazaDeriviation_ 0 20 27
    , WazaDeriviation_ 0 21 18
    , WazaDeriviation_ 0 24 25
    , WazaDeriviation_ 0 25 49
    , WazaDeriviation_ 0 27 30
    , WazaDeriviation_ 0 28 45
    , WazaDeriviation_ 0 29 7
    , WazaDeriviation_ 0 35 13
    , WazaDeriviation_ 0 30 20
    , WazaDeriviation_ 0 31 10
    , WazaDeriviation_ 0 32 31
    , WazaDeriviation_ 0 33 16
    , WazaDeriviation_ 0 34 17
    , WazaDeriviation_ 0 36 23
    , WazaDeriviation_ 0 37 35
    , WazaDeriviation_ 1 42 9
    , WazaDeriviation_ 1 43 12
    , WazaDeriviation_ 1 45 20
    , WazaDeriviation_ 1 46 40
    , WazaDeriviation_ 1 47 26
    , WazaDeriviation_ 1 48 25
    , WazaDeriviation_ 1 50 24
    , WazaDeriviation_ 1 51 41
    , WazaDeriviation_ 1 52 32
    , WazaDeriviation_ 1 53 44
    , WazaDeriviation_ 1 54 16
    , WazaDeriviation_ 1 55 14
    , WazaDeriviation_ 1 56 17
    , WazaDeriviation_ 1 57 35
    , WazaDeriviation_ 1 58 22
    , WazaDeriviation_ 1 59 19
    , WazaDeriviation_ 1 60 29
    , WazaDeriviation_ 1 29 12
    , WazaDeriviation_ 2 62 11
    , WazaDeriviation_ 2 63 6
    , WazaDeriviation_ 2 64 19
    , WazaDeriviation_ 2 65 45
    , WazaDeriviation_ 2 66 15
    , WazaDeriviation_ 2 67 27
    , WazaDeriviation_ 2 68 24
    , WazaDeriviation_ 2 69 36
    , WazaDeriviation_ 2 70 40
    , WazaDeriviation_ 2 71 46
    , WazaDeriviation_ 2 72 10
    , WazaDeriviation_ 2 73 25
    , WazaDeriviation_ 2 74 30
    , WazaDeriviation_ 2 75 28
    , WazaDeriviation_ 2 76 31
    , WazaDeriviation_ 3 78 5
    , WazaDeriviation_ 3 80 23
    , WazaDeriviation_ 3 81 25
    , WazaDeriviation_ 3 82 18
    , WazaDeriviation_ 3 83 15
    , WazaDeriviation_ 3 85 34
    , WazaDeriviation_ 3 86 26
    , WazaDeriviation_ 3 88 8
    , WazaDeriviation_ 3 89 10
    , WazaDeriviation_ 3 90 12
    , WazaDeriviation_ 3 91 13
    , WazaDeriviation_ 3 55 20
    , WazaDeriviation_ 3 93 15
    , WazaDeriviation_ 4 94 6
    , WazaDeriviation_ 4 96 22
    , WazaDeriviation_ 4 97 15
    , WazaDeriviation_ 4 98 18
    , WazaDeriviation_ 4 99 8
    , WazaDeriviation_ 4 101 20
    , WazaDeriviation_ 4 102 27
    , WazaDeriviation_ 4 103 48
    , WazaDeriviation_ 4 104 51
    , WazaDeriviation_ 4 105 40
    , WazaDeriviation_ 4 106 17
    , WazaDeriviation_ 4 107 24
    , WazaDeriviation_ 4 108 48
    , WazaDeriviation_ 4 109 32
    , WazaDeriviation_ 5 114 14
    , WazaDeriviation_ 5 115 25
    , WazaDeriviation_ 5 116 27
    , WazaDeriviation_ 5 118 30
    , WazaDeriviation_ 5 119 19
    , WazaDeriviation_ 5 121 25
    , WazaDeriviation_ 5 122 40
    , WazaDeriviation_ 5 124 15
    , WazaDeriviation_ 5 126 36
    , WazaDeriviation_ 5 130 23
    , WazaDeriviation_ 5 120 38
    , WazaDeriviation_ 6 133 21
    , WazaDeriviation_ 6 134 6
    , WazaDeriviation_ 6 135 10
    , WazaDeriviation_ 6 136 16
    , WazaDeriviation_ 6 137 26
    , WazaDeriviation_ 6 138 12
    , WazaDeriviation_ 6 140 33
    , WazaDeriviation_ 6 141 40
    , WazaDeriviation_ 6 142 22
    , WazaDeriviation_ 6 143 46
    , WazaDeriviation_ 6 144 19
    , WazaDeriviation_ 6 145 13
    , WazaDeriviation_ 10 152 5
    , WazaDeriviation_ 10 154 13
    , WazaDeriviation_ 10 155 20
    , WazaDeriviation_ 10 156 24
    , WazaDeriviation_ 10 158 26
    , WazaDeriviation_ 10 161 45
    , WazaDeriviation_ 15 18 15
    , WazaDeriviation_ 15 22 14
    , WazaDeriviation_ 15 23 20
    , WazaDeriviation_ 15 26 40
    , WazaDeriviation_ 17 20 23
    , WazaDeriviation_ 20 19 12
    , WazaDeriviation_ 20 24 30
    , WazaDeriviation_ 23 26 28
    , WazaDeriviation_ 24 25 35
    , WazaDeriviation_ 24 27 25
    , WazaDeriviation_ 31 32 25
    , WazaDeriviation_ 42 45 16
    , WazaDeriviation_ 43 46 34
    , WazaDeriviation_ 43 54 12
    , WazaDeriviation_ 43 57 25
    , WazaDeriviation_ 45 46 37
    , WazaDeriviation_ 46 51 37
    , WazaDeriviation_ 48 49 38
    , WazaDeriviation_ 50 47 21
    , WazaDeriviation_ 50 52 25
    , WazaDeriviation_ 59 60 21
    , WazaDeriviation_ 63 65 20
    , WazaDeriviation_ 63 71 38
    , WazaDeriviation_ 63 73 5
    , WazaDeriviation_ 64 69 28
    , WazaDeriviation_ 64 70 36
    , WazaDeriviation_ 66 67 20
    , WazaDeriviation_ 66 68 15
    , WazaDeriviation_ 67 68 14
    , WazaDeriviation_ 70 76 15
    , WazaDeriviation_ 79 80 16
    , WazaDeriviation_ 80 87 43
    , WazaDeriviation_ 82 81 20
    , WazaDeriviation_ 82 87 39
    , WazaDeriviation_ 83 84 29
    , WazaDeriviation_ 95 105 38
    , WazaDeriviation_ 96 107 14
    , WazaDeriviation_ 97 106 12
    , WazaDeriviation_ 98 103 39
    , WazaDeriviation_ 98 108 45
    , WazaDeriviation_ 99 102 20
    , WazaDeriviation_ 99 104 36
    , WazaDeriviation_ 103 108 38
    , WazaDeriviation_ 113 119 15
    , WazaDeriviation_ 114 116 20
    , WazaDeriviation_ 114 120 27
    , WazaDeriviation_ 114 124 5
    , WazaDeriviation_ 118 119 13
    , WazaDeriviation_ 118 130 17
    , WazaDeriviation_ 133 143 36
    , WazaDeriviation_ 134 137 16
    , WazaDeriviation_ 134 141 25
    , WazaDeriviation_ 136 142 22
    , WazaDeriviation_ 136 144 9
    , WazaDeriviation_ 137 146 37
    , WazaDeriviation_ 138 140 20
    , WazaDeriviation_ 149 150 12
    , WazaDeriviation_ 149 157 28
    , WazaDeriviation_ 150 157 21
    , WazaDeriviation_ 150 160 30
    , WazaDeriviation_ 151 159 19
    , WazaDeriviation_ 153 196 15
    , WazaDeriviation_ 154 156 13
    , WazaDeriviation_ 154 161 35
    , WazaDeriviation_ 158 162 43
    , WazaDeriviation_ 0 16 5
    , WazaDeriviation_ 1 44 5
    , WazaDeriviation_ 4 100 9
    , WazaDeriviation_ 5 117 11
    , WazaDeriviation_ 10 151 8
    , WazaDeriviation_ 10 153 3
    ]


type alias FromWaza =
    { fromWaza : Waza -- 派生元の技
    , sparkLevel : Int -- 閃き難度
    }


type alias WazaDeriviation =
    { toWaza : Waza -- 派生先の技
    , fromWazas : List FromWaza -- 派生元の技と閃き難度
    }


{-| 指定した技に対する「派生元の技」と「閃き難度」の組み合わせのリストを返す。
-}
findWazaDeriviations : Waza -> WazaDeriviation
findWazaDeriviations toWaza =
    wazaDeriviations_
        |> List.filterMap
            (\{ fromId, toId, sparkLevel } ->
                if toId == toWaza.id then
                    -- 指定された技 (toWaza) を閃く派生パターンが存在した場合、
                    -- wazas から派生元の技 (fromWaza) を解決して
                    -- WazaDeriviation を作成する
                    --
                    -- Maybe.map の結果が Nothing になった場合はデータ不備
                    -- あるべき技が wazas に含まれていない or
                    -- 無効な技の ID が wazaDeriviations_ に含まれている
                    ListEx.find (.id >> (==) fromId) wazas
                        |> Maybe.map
                            (\fromWaza ->
                                FromWaza fromWaza sparkLevel
                            )

                else
                    Nothing
            )
        |> WazaDeriviation toWaza


type EnemyTypeSymbol
    = EnemySkeleton -- 骸骨
    | EnemyUndead -- ゾンビ
    | EnemyDemiHuman -- 獣人
    | EnemyWinged -- 有翼
    | EnemyDemon -- 悪魔
    | EnemyBeast -- 獣
    | EnemyInsect -- 虫
    | EnemySnake -- 蛇
    | EnemyFish -- 魚
    | EnemyPlant -- 植物
    | EnemyAquatic -- 水棲
    | EnemySlime -- 無機質
    | EnemySprite -- 精霊
    | EnemyHuman -- 人間
    | EnemyGhost -- 霊体
    | EnemyReptile -- 爬虫類
    | EnemyDragon -- 竜
    | EnemyGiant -- 巨人
    | EnemyBoss -- ボス


enemyTypeToName : EnemyTypeSymbol -> String
enemyTypeToName symbol =
    case symbol of
        EnemySkeleton ->
            "骸骨"

        EnemyUndead ->
            "ゾンビ"

        EnemyDemiHuman ->
            "獣人"

        EnemyWinged ->
            "有翼"

        EnemyDemon ->
            "悪魔"

        EnemyBeast ->
            "獣"

        EnemyInsect ->
            "虫"

        EnemySnake ->
            "蛇"

        EnemyFish ->
            "魚"

        EnemyPlant ->
            "植物"

        EnemyAquatic ->
            "水棲"

        EnemySlime ->
            "無機質"

        EnemySprite ->
            "精霊"

        EnemyHuman ->
            "人間"

        EnemyGhost ->
            "霊体"

        EnemyReptile ->
            "爬虫類"

        EnemyDragon ->
            "竜"

        EnemyGiant ->
            "巨人"

        EnemyBoss ->
            "ボス"


type alias Enemy =
    { id : Int
    , name : String
    , wazaLevel : Int
    , enemyType : EnemyTypeSymbol
    , rank : Int
    }


enemies : List Enemy
enemies =
    -- 骸骨
    [ Enemy 0 "ボーンヘッド" 4 EnemySkeleton 1
    , Enemy 1 "獄門鳥" 7 EnemySkeleton 2
    , Enemy 2 "ロトンビースト" 8 EnemySkeleton 3
    , Enemy 3 "フライアー" 6 EnemySkeleton 4
    , Enemy 4 "腐骨鳥" 10 EnemySkeleton 5
    , Enemy 5 "スケルトン" 14 EnemySkeleton 6
    , Enemy 6 "ウインガー" 14 EnemySkeleton 7
    , Enemy 7 "スパイクヘッド" 18 EnemySkeleton 8
    , Enemy 8 "スカルデーモン" 20 EnemySkeleton 9
    , Enemy 9 "ボーンドレイク" 24 EnemySkeleton 10
    , Enemy 10 "ヘルタスケルター" 24 EnemySkeleton 11
    , Enemy 11 "ドレッドナイト" 33 EnemySkeleton 12
    , Enemy 12 "アドバード" 34 EnemySkeleton 13
    , Enemy 13 "チャリオット" 36 EnemySkeleton 14
    , Enemy 14 "スカルロード" 39 EnemySkeleton 15
    , Enemy 15 "ヘルビースト" 41 EnemySkeleton 16

    -- ゾンビ
    , Enemy 16 "コープス" 4 EnemyUndead 1
    , Enemy 17 "屍食鬼" 6 EnemyUndead 2
    , Enemy 18 "ボーンバイター" 8 EnemyUndead 3
    , Enemy 19 "ゾンビ" 6 EnemyUndead 4
    , Enemy 20 "屍竜" 9 EnemyUndead 5
    , Enemy 21 "ノスフェラン" 17 EnemyUndead 6
    , Enemy 22 "レブナント" 16 EnemyUndead 7
    , Enemy 23 "吸精鬼" 17 EnemyUndead 8
    , Enemy 24 "デュラハン" 23 EnemyUndead 9
    , Enemy 25 "ブレインイーター" 21 EnemyUndead 10
    , Enemy 26 "腐竜" 28 EnemyUndead 11
    , Enemy 27 "ブラッドサッカー" 29 EnemyUndead 12
    , Enemy 28 "寄生鬼" 36 EnemyUndead 13
    , Enemy 29 "ヴァンパイア(女)" 37 EnemyUndead 14
    , Enemy 30 "ヴァンパイア(男)" 37 EnemyUndead 15
    , Enemy 31 "獄竜" 41 EnemyUndead 16

    -- 獣人
    , Enemy 32 "ゲットー" 4 EnemyDemiHuman 1
    , Enemy 33 "ゴブリン" 6 EnemyDemiHuman 2
    , Enemy 34 "ホブリン" 7 EnemyDemiHuman 3
    , Enemy 35 "ウオッチマン" 8 EnemyDemiHuman 4
    , Enemy 36 "人狼" 9 EnemyDemiHuman 5
    , Enemy 37 "オーガ" 14 EnemyDemiHuman 6
    , Enemy 38 "ドビー" 13 EnemyDemiHuman 7
    , Enemy 39 "ミノタウロス" 18 EnemyDemiHuman 8
    , Enemy 40 "オーガバトラー" 21 EnemyDemiHuman 9
    , Enemy 41 "チャンピオン" 25 EnemyDemiHuman 10
    , Enemy 42 "百獣王" 28 EnemyDemiHuman 11
    , Enemy 43 "スフィンクス" 30 EnemyDemiHuman 12
    , Enemy 44 "マッドオーガ" 33 EnemyDemiHuman 13
    , Enemy 45 "ビーストメア" 35 EnemyDemiHuman 14
    , Enemy 46 "ロビンハット" 39 EnemyDemiHuman 15
    , Enemy 47 "ラルヴァクィーン" 41 EnemyDemiHuman 16

    -- 有翼
    , Enemy 48 "バルチャー" 5 EnemyWinged 1
    , Enemy 49 "サイレン" 5 EnemyWinged 2
    , Enemy 50 "シムルグ" 7 EnemyWinged 3
    , Enemy 51 "スポイラー" 8 EnemyWinged 4
    , Enemy 52 "ソニック" 10 EnemyWinged 5
    , Enemy 53 "フライマンバ" 14 EnemyWinged 6
    , Enemy 54 "アズテック" 16 EnemyWinged 7
    , Enemy 55 "ストーマー" 18 EnemyWinged 8
    , Enemy 56 "クレイジーサン" 21 EnemyWinged 9
    , Enemy 57 "ワイバーン" 24 EnemyWinged 10
    , Enemy 58 "ウィズゴブリン" 27 EnemyWinged 11
    , Enemy 59 "コカトリス" 30 EnemyWinged 12
    , Enemy 60 "ブレイザー" 33 EnemyWinged 13
    , Enemy 61 "スノーウィルム" 37 EnemyWinged 14
    , Enemy 62 "ナイトフォーク" 40 EnemyWinged 15
    , Enemy 63 "フォージウィルム" 39 EnemyWinged 16

    -- 悪魔
    , Enemy 64 "ジャム" 4 EnemyDemon 1
    , Enemy 65 "フィーンド" 7 EnemyDemon 2
    , Enemy 66 "ナイト" 9 EnemyDemon 3
    , Enemy 67 "ゼノ" 6 EnemyDemon 4
    , Enemy 68 "インプ" 7 EnemyDemon 5
    , Enemy 69 "クローラー" 14 EnemyDemon 6
    , Enemy 70 "ガーゴイル" 14 EnemyDemon 7
    , Enemy 71 "カルト" 17 EnemyDemon 8
    , Enemy 72 "マジシャン" 20 EnemyDemon 9
    , Enemy 73 "ウイングメア" 26 EnemyDemon 10
    , Enemy 74 "青鬼" 21 EnemyDemon 11
    , Enemy 75 "ジョーカー" 28 EnemyDemon 12
    , Enemy 76 "ヒューリオン" 35 EnemyDemon 13
    , Enemy 77 "赤鬼" 26 EnemyDemon 14
    , Enemy 78 "ナックラビー" 41 EnemyDemon 15
    , Enemy 79 "ディアブロ" 42 EnemyDemon 16

    -- 獣
    , Enemy 80 "マイザー" 3 EnemyBeast 1
    , Enemy 81 "バファロー" 5 EnemyBeast 2
    , Enemy 82 "ムスタング" 7 EnemyBeast 3
    , Enemy 83 "大河馬" 8 EnemyBeast 4
    , Enemy 84 "リンクス" 9 EnemyBeast 5
    , Enemy 85 "ヘルハウンド" 15 EnemyBeast 6
    , Enemy 86 "ワンプス" 15 EnemyBeast 7
    , Enemy 87 "レイバーホーン" 19 EnemyBeast 8
    , Enemy 88 "トリケプス" 20 EnemyBeast 9
    , Enemy 89 "キマイラ" 26 EnemyBeast 10
    , Enemy 90 "バク" 27 EnemyBeast 11
    , Enemy 91 "ゴルゴン" 29 EnemyBeast 12
    , Enemy 92 "河馬人間" 33 EnemyBeast 13
    , Enemy 93 "ガルム" 34 EnemyBeast 14
    , Enemy 94 "ヌエ" 40 EnemyBeast 15
    , Enemy 95 "トウテツ" 42 EnemyBeast 16

    -- 虫
    , Enemy 96 "ビー" 3 EnemyInsect 1
    , Enemy 97 "妖虫" 4 EnemyInsect 2
    , Enemy 98 "センチペタ" 5 EnemyInsect 3
    , Enemy 99 "マンターム" 10 EnemyInsect 4
    , Enemy 100 "ピアス" 6 EnemyInsect 5
    , Enemy 101 "クラブロブスター" 12 EnemyInsect 6
    , Enemy 102 "毒虫" 12 EnemyInsect 7
    , Enemy 103 "アンワーム" 16 EnemyInsect 8
    , Enemy 104 "タランテラ" 21 EnemyInsect 9
    , Enemy 105 "タームソルジャー" 23 EnemyInsect 10
    , Enemy 106 "シザースパイダー" 28 EnemyInsect 11
    , Enemy 107 "マンティスゴッド" 30 EnemyInsect 12
    , Enemy 108 "ブラックウィドウ" 34 EnemyInsect 13
    , Enemy 109 "シャークピード" 33 EnemyInsect 14
    , Enemy 110 "タームバトラー" 37 EnemyInsect 15
    , Enemy 111 "カイザーアント" 41 EnemyInsect 16

    -- 蛇
    , Enemy 112 "飛蛇" 5 EnemySnake 1
    , Enemy 113 "ヴァイパー" 6 EnemySnake 2
    , Enemy 114 "パイソン" 8 EnemySnake 3
    , Enemy 115 "砂竜" 12 EnemySnake 4
    , Enemy 116 "害蛇" 10 EnemySnake 5
    , Enemy 117 "オピオン" 13 EnemySnake 6
    , Enemy 118 "デューンウォーム" 18 EnemySnake 7
    , Enemy 119 "コウアトル" 18 EnemySnake 8
    , Enemy 120 "フューザー" 23 EnemySnake 9
    , Enemy 121 "サンドバイター" 24 EnemySnake 10
    , Enemy 122 "パイロヒドラ" 31 EnemySnake 11
    , Enemy 123 "リリス" 32 EnemySnake 12
    , Enemy 124 "ラットラー" 34 EnemySnake 13
    , Enemy 125 "エレキテル" 36 EnemySnake 14
    , Enemy 126 "メドゥサ" 39 EnemySnake 15
    , Enemy 127 "ヴリトラ" 41 EnemySnake 16

    -- 魚
    , Enemy 128 "咬魚" 3 EnemyFish 1
    , Enemy 129 "人食いザメ" 7 EnemyFish 2
    , Enemy 130 "スノーレディ" 8 EnemyFish 3
    , Enemy 131 "アルケパイン" 7 EnemyFish 4
    , Enemy 132 "竜金" 11 EnemyFish 5
    , Enemy 133 "牙魚" 13 EnemyFish 6
    , Enemy 134 "ハンマヘッド" 17 EnemyFish 7
    , Enemy 135 "ヘクトアイ" 18 EnemyFish 8
    , Enemy 136 "ネプトゥーネ" 23 EnemyFish 9
    , Enemy 137 "クロイドン" 24 EnemyFish 10
    , Enemy 138 "スティンガー" 28 EnemyFish 11
    , Enemy 139 "スカーレット" 30 EnemyFish 12
    , Enemy 140 "トリトーン" 34 EnemyFish 13
    , Enemy 141 "人面ザメ" 36 EnemyFish 14
    , Enemy 142 "チェスタトン" 38 EnemyFish 15
    , Enemy 143 "アルビオン" 43 EnemyFish 16

    -- 植物
    , Enemy 144 "サラ" 4 EnemyPlant 1
    , Enemy 145 "マンドレーク" 3 EnemyPlant 2
    , Enemy 146 "クリーパー" 7 EnemyPlant 3
    , Enemy 147 "ウッドノイド" 10 EnemyPlant 4
    , Enemy 148 "スプリッツァー" 11 EnemyPlant 5
    , Enemy 149 "お化けキノコ" 17 EnemyPlant 6
    , Enemy 150 "ナスティペタル" 13 EnemyPlant 7
    , Enemy 151 "グラスホッパー" 18 EnemyPlant 8
    , Enemy 152 "ナイトシェード" 20 EnemyPlant 9
    , Enemy 153 "シグナルツリー" 19 EnemyPlant 10
    , Enemy 154 "ブラディマリー" 25 EnemyPlant 11
    , Enemy 155 "ラッフルツリー" 31 EnemyPlant 12
    , Enemy 156 "トーチャー" 32 EnemyPlant 13
    , Enemy 157 "アルラウネ" 35 EnemyPlant 14
    , Enemy 158 "ナイトヘッド" 28 EnemyPlant 15
    , Enemy 159 "マルガリータ" 38 EnemyPlant 16

    -- 水棲
    , Enemy 160 "ウミウシ" 4 EnemyAquatic 1
    , Enemy 161 "オクトパス" 6 EnemyAquatic 2
    , Enemy 162 "サベイジクラブ" 8 EnemyAquatic 3
    , Enemy 163 "ニクサー" 14 EnemyAquatic 4
    , Enemy 164 "ニクシー" 17 EnemyAquatic 5
    , Enemy 165 "アメ降らし" 11 EnemyAquatic 6
    , Enemy 166 "メーベルワーゲン" 13 EnemyAquatic 7
    , Enemy 167 "装甲竜" 16 EnemyAquatic 8
    , Enemy 168 "グレートシザー" 18 EnemyAquatic 9
    , Enemy 169 "チューブウォーム" 22 EnemyAquatic 10
    , Enemy 170 "大海竜" 25 EnemyAquatic 11
    , Enemy 171 "ディープワン" 19 EnemyAquatic 12
    , Enemy 172 "ペグパウラー" 32 EnemyAquatic 13
    , Enemy 173 "クラブライダー" 36 EnemyAquatic 14
    , Enemy 174 "首長竜" 40 EnemyAquatic 15
    , Enemy 175 "ベインサーペント" 41 EnemyAquatic 16

    -- 無機質
    , Enemy 176 "ジェル" 3 EnemySlime 1
    , Enemy 177 "溶解獣" 4 EnemySlime 2
    , Enemy 178 "スライム" 5 EnemySlime 3
    , Enemy 179 "大ヒル" 7 EnemySlime 4
    , Enemy 180 "ディノバブル" 8 EnemySlime 5
    , Enemy 181 "ゼラチナスマター" 11 EnemySlime 6
    , Enemy 182 "ゼリー" 14 EnemySlime 7
    , Enemy 183 "ムドメイン" 15 EnemySlime 8
    , Enemy 184 "サイケビースト" 17 EnemySlime 9
    , Enemy 185 "ブロッブ" 21 EnemySlime 10
    , Enemy 186 "ウーズ" 22 EnemySlime 11
    , Enemy 187 "毒液獣" 27 EnemySlime 12
    , Enemy 188 "ベインパープル" 31 EnemySlime 13
    , Enemy 189 "毒ヒル" 32 EnemySlime 14
    , Enemy 190 "アゾート" 33 EnemySlime 15
    , Enemy 191 "ゴールドバウム" 35 EnemySlime 16

    -- 精霊
    , Enemy 192 "シー" 3 EnemySprite 1
    , Enemy 193 "アムネジア" 8 EnemySprite 2
    , Enemy 194 "リキッド" 10 EnemySprite 3
    , Enemy 195 "エアー" 10 EnemySprite 4
    , Enemy 196 "フレイム" 10 EnemySprite 5
    , Enemy 197 "ソイル" 10 EnemySprite 6
    , Enemy 198 "バルキリー" 14 EnemySprite 7
    , Enemy 199 "水の精霊" 15 EnemySprite 8
    , Enemy 200 "土の精霊" 18 EnemySprite 9
    , Enemy 201 "シュラーク" 22 EnemySprite 10
    , Enemy 202 "風の精霊" 27 EnemySprite 11
    , Enemy 203 "ジャン" 29 EnemySprite 12
    , Enemy 204 "パザティブ" 27 EnemySprite 13
    , Enemy 205 "火の精霊" 33 EnemySprite 14
    , Enemy 206 "マーリド" 36 EnemySprite 15
    , Enemy 207 "セフィラス" 39 EnemySprite 16

    -- 人間
    , Enemy 208 "アデプト" 5 EnemyHuman 1
    , Enemy 209 "影" 7 EnemyHuman 2
    , Enemy 210 "ノービス" 4 EnemyHuman 3
    , Enemy 211 "シニアー" 8 EnemyHuman 4
    , Enemy 212 "ガリアンブルー" 11 EnemyHuman 5
    , Enemy 213 "ヴァイカー" 14 EnemyHuman 6
    , Enemy 214 "キラーマシン" 17 EnemyHuman 7
    , Enemy 215 "ドラフトレッド" 19 EnemyHuman 8
    , Enemy 216 "エルダー" 19 EnemyHuman 9
    , Enemy 217 "マスター" 20 EnemyHuman 10
    , Enemy 218 "グレート" 24 EnemyHuman 11
    , Enemy 219 "シルバービート" 29 EnemyHuman 12
    , Enemy 220 "ラーマ" 33 EnemyHuman 13
    , Enemy 221 "ブラックレギオン" 38 EnemyHuman 14
    , Enemy 222 "ドクター" 32 EnemyHuman 15
    , Enemy 223 "ミスティック" 42 EnemyHuman 16

    -- 霊体
    , Enemy 224 "生魂" 2 EnemyGhost 1
    , Enemy 225 "人魂" 2 EnemyGhost 2
    , Enemy 226 "ハウント" 4 EnemyGhost 3
    , Enemy 227 "レインイーター" 5 EnemyGhost 4
    , Enemy 228 "火魂" 6 EnemyGhost 5
    , Enemy 229 "ハロウィーン" 11 EnemyGhost 6
    , Enemy 230 "ストームイーター" 12 EnemyGhost 7
    , Enemy 231 "フューリー" 19 EnemyGhost 8
    , Enemy 232 "ロア" 19 EnemyGhost 9
    , Enemy 233 "素魂" 13 EnemyGhost 10
    , Enemy 234 "ポイゾンイーター" 24 EnemyGhost 11
    , Enemy 235 "ソロウ" 28 EnemyGhost 12
    , Enemy 236 "ゴーメンガスト" 32 EnemyGhost 13
    , Enemy 237 "ジン" 31 EnemyGhost 14
    , Enemy 238 "パトス" 37 EnemyGhost 15
    , Enemy 239 "フィア" 39 EnemyGhost 16

    -- 爬虫類
    , Enemy 240 "タータラ" 5 EnemyReptile 1
    , Enemy 241 "かえるの王様" 6 EnemyReptile 2
    , Enemy 242 "ワニゲータ" 7 EnemyReptile 3
    , Enemy 243 "ウェアフロッグ" 7 EnemyReptile 4
    , Enemy 244 "リザード" 9 EnemyReptile 5
    , Enemy 245 "かえるの王子様" 12 EnemyReptile 6
    , Enemy 246 "リザードマン" 16 EnemyReptile 7
    , Enemy 247 "リザードレディ" 16 EnemyReptile 8
    , Enemy 248 "パイロレクス" 21 EnemyReptile 9
    , Enemy 249 "ホーンリザード" 25 EnemyReptile 10
    , Enemy 250 "トードマスター" 27 EnemyReptile 11
    , Enemy 251 "バジリスク" 29 EnemyReptile 12
    , Enemy 252 "ケロリアン" 29 EnemyReptile 13
    , Enemy 253 "ラムリザード" 36 EnemyReptile 14
    , Enemy 254 "かえるの殿様" 38 EnemyReptile 15
    , Enemy 255 "リザードロード" 40 EnemyReptile 16

    -- 竜
    , Enemy 300 "火竜" 33 EnemyDragon 40
    , Enemy 301 "氷竜" 31 EnemyDragon 40
    , Enemy 302 "雷竜" 34 EnemyDragon 40
    , Enemy 303 "黒竜" 37 EnemyDragon 40
    , Enemy 304 "水龍" 32 EnemyDragon 40
    , Enemy 305 "金龍" 39 EnemyDragon 40

    -- 巨人
    , Enemy 400 "巨人" 25 EnemyGiant 30
    , Enemy 401 "サイクロプス" 24 EnemyGiant 30
    , Enemy 402 "スプリガン" 19 EnemyGiant 30
    , Enemy 403 "守護者" 31 EnemyGiant 30

    -- ボス
    , Enemy 500 "ミミック" 9 EnemyBoss 20
    , Enemy 501 "キング" 8 EnemyBoss 20
    , Enemy 502 "門" 1 EnemyBoss 20
    , Enemy 503 "ザ・ドラゴン" 5 EnemyBoss 20
    , Enemy 504 "バイキング" 8 EnemyBoss 20
    , Enemy 505 "ギャロン" 15 EnemyBoss 20
    , Enemy 506 "ギャロン(亡霊)" 16 EnemyBoss 20
    , Enemy 507 "サイフリート" 12 EnemyBoss 20
    , Enemy 508 "亡霊兵士" 12 EnemyBoss 20
    , Enemy 509 "ゲオルグ" 13 EnemyBoss 20
    , Enemy 510 "セキシュウサイ" 16 EnemyBoss 20
    , Enemy 511 "岩" 1 EnemyBoss 20
    , Enemy 512 "魔道士(冥術)" 16 EnemyBoss 20
    , Enemy 513 "魔道士(通常)" 16 EnemyBoss 20
    , Enemy 514 "海の主" 21 EnemyBoss 20
    , Enemy 515 "クィーン" 14 EnemyBoss 20
    , Enemy 516 "リアルクィーン" 23 EnemyBoss 20

    -- ボス(七英雄)
    , Enemy 600 "クジンシー0" 6 EnemyBoss 50
    , Enemy 601 "クジンシー1" 8 EnemyBoss 50
    , Enemy 602 "クジンシー2" 31 EnemyBoss 50
    , Enemy 603 "ダンターグ1" 20 EnemyBoss 50
    , Enemy 604 "ダンターグ2" 23 EnemyBoss 50
    , Enemy 605 "ダンターグ3" 25 EnemyBoss 50
    , Enemy 606 "ダンターグ4" 31 EnemyBoss 50
    , Enemy 607 "ボクオーン1" 21 EnemyBoss 50
    , Enemy 608 "ボクオーン2" 26 EnemyBoss 50
    , Enemy 609 "ロックブーケ1" 23 EnemyBoss 50
    , Enemy 610 "ロックブーケ2" 28 EnemyBoss 50
    , Enemy 611 "ノエル1" 26 EnemyBoss 50
    , Enemy 612 "ノエル2" 29 EnemyBoss 50
    , Enemy 613 "ノエル1(怒り)" 26 EnemyBoss 50
    , Enemy 614 "ノエル2(怒り)" 32 EnemyBoss 50
    , Enemy 615 "スービエ1" 21 EnemyBoss 50
    , Enemy 616 "スービエ2" 21 EnemyBoss 50
    , Enemy 617 "ワグナス1" 20 EnemyBoss 50
    , Enemy 618 "ワグナス2" 25 EnemyBoss 50
    , Enemy 619 "七英雄" 36 EnemyBoss 50
    ]


type alias EnemyWithSparkRatio =
    { enemy : Enemy
    , sparkRatio : Float
    }


findEnemiesForSpark : Int -> List EnemyWithSparkRatio
findEnemiesForSpark sparkLevel =
    let
        -- ソート条件1：閃き率、降順
        -- ソート条件2：敵のランク、昇順
        --   閃き率が同じ場合は弱い敵 (≒ランクが低い敵) を先に表示したい
        -- ソート条件3：敵の ID 、昇順
        compareEnemy : EnemyWithSparkRatio -> EnemyWithSparkRatio -> Order
        compareEnemy e1 e2 =
            case compare e1.sparkRatio e2.sparkRatio of
                LT ->
                    GT

                EQ ->
                    case compare e1.enemy.rank e2.enemy.rank of
                        LT ->
                            LT

                        EQ ->
                            compare e1.enemy.id e2.enemy.id

                        GT ->
                            GT

                GT ->
                    LT
    in
    enemies
        -- 閃き率が 0% の場合はあらかじめ除外しておく
        |> List.filter (\enemy -> enemy.wazaLevel > sparkLevel - 6)
        |> List.map
            (\enemy ->
                EnemyWithSparkRatio enemy <|
                    calcSparkRatio sparkLevel enemy.wazaLevel
            )
        |> List.sortWith compareEnemy


calcSparkRatio : Int -> Int -> Float
calcSparkRatio sparkLevel wazaLevel =
    let
        diff =
            wazaLevel - sparkLevel
    in
    if diff >= 6 then
        -- 6 以上は 9.80% で固定
        9.8

    else
        case diff of
            5 ->
                -- 厳密には 9.41
                9.4

            4 ->
                -- 厳密には 9.41
                9.4

            3 ->
                -- 厳密には 8.63
                8.6

            2 ->
                -- 厳密には 8.63
                8.6

            1 ->
                -- 厳密には 7.84
                7.8

            0 ->
                -- 閃き難度と技レベルが一致する場合に閃き率は最大になる
                20.4

            n ->
                -- 負値をパターンマッチさせようとするとコンパイルで
                -- パースエラーになるため、やむを得ずこの形
                case negate n of
                    1 ->
                        5.1

                    2 ->
                        -- 厳密には 2.35
                        2.4

                    3 ->
                        -- 厳密には 1.57
                        1.6

                    4 ->
                        -- 厳密には 0.78
                        0.8

                    5 ->
                        -- 厳密には 0.39
                        0.4

                    _ ->
                        -- -6 以下は閃かない
                        0.0
