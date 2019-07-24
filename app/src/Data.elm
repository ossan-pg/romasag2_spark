module Data exposing
    ( CharaClassType(..), CharaClass, charaClasses
    , SparkType(..), Chara, charas
    )

{-|

@docs CharaClassType, CharaClass, charaClasses
@docs SparkType, Chara, charas

-}


type CharaClassType
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
    { charaClassType : CharaClassType
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


type SparkType
    = Sword1 -- 剣1
    | Sword2 -- 剣2
    | GreatSword1 -- 大剣1
    | GreatSword2 -- 大剣2
    | Axe -- 斧
    | SpearAxe -- 槍斧
    | Mace -- 棍棒
    | Spear -- 槍
    | ShortSword -- 小剣
    | Bow -- 弓
    | MartialSkill1 --体術1
    | MartialSkill2 --体術2
    | General -- 汎用
    | Spell --術
    | CannotSpark --なし


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
    , charaClassType : CharaClassType -- キャラのクラス
    , charaOrder : Int -- キャラのクラス内での順番
    , sparkType : SparkType -- 閃きタイプ
    }


charas : List Chara
charas =
    -- 帝国重装歩兵
    [ Chara 0 "ベア" 14 16 12 15 12 11 23 3 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 1 General
    , Chara 1 "バイソン" 15 17 12 16 13 11 21 1 -7 1 -7 1 -7 -7 -7 -7 -7 -7 HeavyInfantry 2 General
    , Chara 2 "ウォーラス" 13 16 14 14 10 10 23 1 -7 1 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 3 General
    , Chara 3 "スネイル" 12 15 12 16 13 13 21 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 4 Sword2
    , Chara 4 "ヘッジホッグ" 11 18 12 16 12 11 22 0 0 -7 0 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 5 General
    , Chara 5 "トータス" 12 15 13 15 14 12 22 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 6 General
    , Chara 6 "ライノ" 13 16 14 15 11 13 21 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 7 General
    , Chara 7 "フェルディナント" 10 15 13 16 13 10 23 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 HeavyInfantry 8 General

    -- 帝国軽装歩兵(男)
    , Chara 8 "ジェイムズ" 11 16 15 13 11 17 18 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 1 GreatSword2
    , Chara 9 "ジョン" 13 16 15 14 10 18 17 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 2 GreatSword2
    , Chara 10 "リチャード" 8 17 15 12 12 19 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 3 Sword1
    , Chara 11 "ハーバート" 10 18 16 14 11 17 17 1 1 1 1 -7 -7 -7 -6 -7 -7 -7 LightInfantryM 4 Sword2
    , Chara 12 "ハリー" 11 18 16 16 15 15 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 5 GreatSword2
    , Chara 13 "ロナルド" 9 17 15 14 11 18 18 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 6 General
    , Chara 14 "ドワイト" 8 17 18 13 12 16 17 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryM 7 GreatSword2
    , Chara 15 "フランクリン" 13 18 15 13 13 18 17 1 1 1 1 -7 -7 -5 -7 -7 -7 -7 LightInfantryM 8 Sword2

    -- 帝国軽装歩兵(女)
    , Chara 16 "ライーザ" 11 16 16 16 13 16 17 2 2 2 2 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 1 ShortSword
    , Chara 17 "ジェシカ" 8 16 18 17 10 14 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 2 Sword2
    , Chara 18 "シャーリー" 7 17 15 16 13 17 18 1 1 1 1 -7 -7 -7 -4 -7 -7 -7 LightInfantryF 3 ShortSword
    , Chara 19 "オードリー" 15 18 15 17 11 15 17 2 2 2 2 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 4 Sword2
    , Chara 20 "ジュディ" 10 17 15 16 16 18 18 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 5 Sword1
    , Chara 21 "グレース" 12 18 15 15 15 17 17 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 6 Sword2
    , Chara 22 "イングリット" 8 17 16 15 14 16 18 2 2 2 2 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 7 ShortSword
    , Chara 23 "グレタ" 9 17 15 15 11 17 16 1 1 1 1 -7 -7 -7 -7 -7 -7 -7 LightInfantryF 8 Bow

    -- 帝国猟兵(男)
    , Chara 24 "ヘンリー" 12 13 22 13 11 16 15 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerM 1 Bow
    , Chara 25 "ルイ" 11 14 21 14 11 15 15 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 RangerM 2 Bow
    , Chara 26 "チャールズ" 10 15 20 13 12 15 14 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerM 3 Bow
    , Chara 27 "ウィリアム" 13 13 22 12 10 16 16 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerM 4 Bow
    , Chara 28 "フィリップ" 12 15 21 14 12 14 16 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 -7 RangerM 5 Bow
    , Chara 29 "エドワード" 10 16 20 11 14 17 15 -7 -7 -7 4 -7 -7 -7 -7 -7 -7 -7 RangerM 6 Bow
    , Chara 30 "アレクサンドル" 12 13 22 16 10 15 17 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 -7 RangerM 7 Bow
    , Chara 31 "フリードリッヒ" 15 14 21 13 12 16 15 -7 -7 -7 2 -7 -5 -7 -7 -7 -7 -7 RangerM 8 Bow

    -- 帝国猟兵(女)
    , Chara 32 "テレーズ" 10 13 20 15 10 16 14 -7 2 -7 2 -7 -7 -6 -7 -7 -7 -7 RangerF 1 Bow
    , Chara 33 "メアリー" 8 15 21 14 13 15 13 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerF 2 ShortSword
    , Chara 34 "アグネス" 6 14 20 17 12 16 12 -7 1 -7 1 -7 -7 -5 -7 -7 -5 -7 RangerF 3 Bow
    , Chara 35 "キャサリン" 7 13 22 15 11 15 14 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerF 4 Bow
    , Chara 36 "アン" 9 16 20 14 12 15 13 -7 -7 -7 1 -7 -7 -7 -7 -4 -7 -7 RangerF 5 Bow
    , Chara 37 "ユリアナ" 11 12 23 14 12 13 15 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 RangerF 6 Bow
    , Chara 38 "イザベラ" 7 14 21 19 10 14 12 -7 1 -7 1 -7 -7 -7 -7 -1 -7 -7 RangerF 7 Bow
    , Chara 39 "エリザベス" 8 13 22 15 12 13 15 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 RangerF 8 Bow

    -- 宮廷魔術師(男)
    , Chara 40 "アリエス" 10 12 16 21 11 13 12 -7 -7 -5 -7 -7 -7 1 1 -7 -7 -7 CourtMageM 1 Mace
    , Chara 41 "サジタリウス" 12 10 19 19 10 14 10 -7 -7 -7 0 -7 -7 1 1 -7 -7 -7 CourtMageM 2 Bow
    , Chara 42 "ライブラ" 8 11 16 23 11 12 11 -7 -7 -7 -7 -7 -7 3 3 -7 -7 -7 CourtMageM 3 Spell
    , Chara 43 "タウラス" 11 12 17 21 13 14 10 -7 -7 -7 -7 -7 -7 2 2 -7 -7 -7 CourtMageM 4 Spell
    , Chara 44 "ジェミニ" 10 11 17 20 12 14 13 -7 -7 -7 -7 -7 -7 2 2 -7 -7 -7 CourtMageM 5 Spell
    , Chara 45 "カプリコーン" 9 12 16 19 14 13 12 -7 -7 -4 -7 -7 -7 1 1 -7 -7 -7 CourtMageM 6 Mace
    , Chara 46 "キグナス" 13 13 18 21 14 12 12 -7 -7 -7 -7 -7 -7 2 2 -7 -7 -7 CourtMageM 7 Spell
    , Chara 47 "クラックス" 10 11 17 20 12 15 11 -7 -7 -7 -7 -7 -7 1 1 -7 -7 -7 CourtMageM 8 Spell

    -- 宮廷魔術師(女)
    , Chara 48 "エメラルド" 10 10 17 20 14 16 10 -7 -7 -7 -7 -7 2 -7 2 -7 -7 -7 CourtMageF 1 Spell
    , Chara 49 "アメジスト" 8 10 17 19 13 15 13 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 2 Spell
    , Chara 50 "オニキス" 11 10 18 20 12 16 11 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 3 Spell
    , Chara 51 "トパーズ" 10 11 16 20 15 15 10 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 4 Spell
    , Chara 52 "ガーネット" 8 11 16 21 14 15 11 -7 -7 -7 -7 -7 1 -7 1 -7 -7 -7 CourtMageF 5 Spell
    , Chara 53 "オパール" 12 11 17 20 14 16 11 -7 -7 -7 -7 -7 2 -7 2 -7 -7 -7 CourtMageF 6 Spell
    , Chara 54 "ルビー" 10 11 18 22 15 16 10 -7 -7 -7 -7 -7 3 -7 3 -7 -7 -7 CourtMageF 7 Spell
    , Chara 55 "サファイア" 12 13 17 18 12 17 12 -7 3 -7 -7 -7 2 -7 2 -7 -7 -7 CourtMageF 8 ShortSword

    -- フリーファイター(男)
    , Chara 56 "ヘクター" 13 21 14 12 11 16 18 2 -7 2 -7 -7 -7 -7 -7 -6 -7 -7 MercenaryM 1 GreatSword2
    , Chara 57 "オライオン" 11 20 15 13 10 17 16 3 -7 -7 -7 -7 -6 -7 -7 -7 -7 -7 MercenaryM 2 Sword1
    , Chara 58 "ジェイスン" 11 19 16 14 11 15 17 1 1 1 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryM 3 SpearAxe
    , Chara 59 "シーシアス" 10 20 14 13 10 16 17 1 1 1 -7 -7 -7 -7 -5 -7 -7 -7 MercenaryM 4 SpearAxe
    , Chara 60 "アキリーズ" 13 19 15 14 13 15 19 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryM 5 GreatSword1
    , Chara 61 "ユリシーズ" 12 21 15 13 12 16 17 1 1 1 -7 -7 -7 -5 -7 -7 -7 -7 MercenaryM 6 SpearAxe
    , Chara 62 "パーシアス" 11 18 16 13 12 17 16 2 -7 2 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryM 7 General
    , Chara 63 "ハーキュリーズ" 13 20 17 14 13 14 16 1 -7 1 -7 -7 -7 -7 -7 -7 -6 -7 MercenaryM 8 GreatSword2

    -- フリーファイター(女)
    , Chara 64 "アンドロマケー" 11 19 16 15 11 13 18 1 -7 -7 1 -7 -7 -6 -7 -7 -7 -7 MercenaryF 1 Sword2
    , Chara 65 "シーデー" 10 18 17 15 11 15 16 1 -7 -7 1 1 -7 -7 -7 -7 -5 -7 MercenaryF 2 Bow
    , Chara 66 "メディア" 15 19 16 14 18 14 17 2 -7 2 2 -7 -6 -7 -7 -6 -7 -7 MercenaryF 3 Sword2
    , Chara 67 "ヒッポリュテー" 12 18 15 17 12 13 18 2 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryF 4 SpearAxe
    , Chara 68 "デーイダメイア" 14 19 16 15 10 14 17 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 MercenaryF 5 GreatSword2
    , Chara 69 "ペネロープ" 11 20 16 14 11 13 19 2 -7 -7 -7 -7 -7 -7 -7 -5 -7 -7 MercenaryF 6 Sword2
    , Chara 70 "アンドロメダ" 7 17 18 15 13 15 17 1 -7 -7 1 -7 -7 -7 -6 -7 -7 -7 MercenaryF 7 Bow
    , Chara 71 "ディアネイラ" 10 19 16 14 13 14 18 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 MercenaryF 8 GreatSword2

    -- フリーメイジ(男)
    , Chara 72 "レグルス" 10 12 15 20 15 17 15 -7 -7 -5 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 1 MartialSkill1
    , Chara 73 "アルゴル" 8 12 16 19 13 16 15 -7 -7 -5 -7 -7 -7 2 -7 2 -7 -7 MageForHireM 2 Mace
    , Chara 74 "ポラリス" 10 11 16 21 12 16 16 -7 -7 -7 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 3 Spell
    , Chara 75 "カノープス" 6 12 15 19 14 18 15 -7 -7 -5 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 4 Mace
    , Chara 76 "プロキオン" 8 10 16 20 15 17 15 -7 -7 -4 -7 -7 -7 2 -7 2 -7 -7 MageForHireM 5 Mace
    , Chara 77 "リゲル" 9 11 18 18 14 16 14 -7 -7 -6 -7 -7 -7 2 -7 2 -7 -7 MageForHireM 6 Bow
    , Chara 78 "ヴェガ" 13 12 14 22 12 17 15 -7 -7 -7 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 7 Spell
    , Chara 79 "シリウス" 7 11 17 19 13 16 16 -7 -7 -6 -7 -7 -7 3 -7 3 -7 -7 MageForHireM 8 Mace

    -- フリーメイジ(女)
    , Chara 80 "ローズ" 7 11 17 19 13 17 13 -7 -7 -5 -7 -7 2 -7 -7 2 -7 -7 MageForHireF 1 Spell
    , Chara 81 "リリィ" 8 10 18 20 12 16 12 -7 -7 -4 -7 -7 3 -7 -7 3 -7 -7 MageForHireF 2 ShortSword
    , Chara 82 "デイジー" 10 11 17 18 13 19 13 -7 -7 -7 -7 -7 1 -7 -7 1 -7 -7 MageForHireF 3 Spell
    , Chara 83 "アイリス" 9 10 15 22 17 15 12 -7 -7 -7 -7 -7 1 -7 -7 1 -7 -7 MageForHireF 4 Spell
    , Chara 84 "マグノリア" 11 13 18 19 15 17 14 -7 -7 -5 -7 -7 3 -7 -7 3 -7 -7 MageForHireF 5 MartialSkill2
    , Chara 85 "ヘイゼル" 7 11 17 20 16 16 13 -7 -7 -7 -7 -7 4 -7 -7 4 -7 -7 MageForHireF 6 Spell
    , Chara 86 "アイヴィ" 8 10 17 19 15 18 11 -7 -7 -6 -7 -7 3 -7 -7 3 -7 -7 MageForHireF 7 ShortSword
    , Chara 87 "ウィンドシード" 9 11 17 20 16 17 13 -7 -7 -7 -7 -7 2 -7 -7 2 -7 -7 MageForHireF 8 Spell

    -- インペリアルガード(男)
    , Chara 88 "ワレンシュタイン" 12 23 10 11 10 12 20 3 3 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 1 SpearAxe
    , Chara 89 "タンクレッド" 13 21 12 11 11 11 21 -7 2 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 2 Spear
    , Chara 90 "ダブー" 12 22 10 12 12 14 19 -7 3 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 3 Spear
    , Chara 91 "マールバラ" 14 23 11 13 14 13 18 -7 2 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 4 Spear
    , Chara 92 "ハンニバル" 15 25 12 11 18 11 18 4 4 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 5 SpearAxe
    , Chara 93 "エパミノンダス" 11 22 13 12 13 12 17 -7 2 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 6 Spear
    , Chara 94 "グスタフ" 13 24 10 10 10 11 20 -7 3 -7 -7 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 7 Spear
    , Chara 95 "ベリサリウス" 12 23 11 14 12 13 19 -7 2 -7 2 -7 -7 -7 -7 -7 0 -7 ImperialGuardM 8 SpearAxe

    -- インペリアルガード(女)
    , Chara 96 "ミネルバ" 11 20 12 17 12 10 17 2 2 -7 2 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 1 Sword2
    , Chara 97 "ルナ" 14 21 10 18 13 12 16 -7 2 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 2 SpearAxe
    , Chara 98 "ユノー" 10 23 10 15 12 11 17 -7 3 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 3 General
    , Chara 99 "セレス" 13 22 10 15 13 13 16 2 2 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 4 GreatSword2
    , Chara 100 "オーロラ" 12 21 11 17 15 10 17 -7 3 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 5 SpearAxe
    , Chara 101 "フューリー" 11 19 13 18 15 11 16 -7 2 -7 2 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 6 SpearAxe
    , Chara 102 "ヴィクトリア" 10 21 12 16 14 11 18 -7 3 -7 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 7 Spear
    , Chara 103 "ディアナ" 15 22 11 16 18 11 18 -7 2 2 -7 -7 -7 -7 -7 -7 1 -7 ImperialGuardF 8 Sword1

    -- 軍師
    , Chara 104 "シゲン" 10 10 11 21 12 23 11 -7 -7 -7 -7 -7 -7 3 3 -7 3 -7 Strategist 1 Spell
    , Chara 105 "ハクヤク" 8 10 13 19 12 22 11 -7 -7 -7 -7 -7 3 -7 -7 3 3 -7 Strategist 2 Spell
    , Chara 106 "タンプク" 9 10 11 20 11 24 11 -7 -7 -7 -5 -7 -7 3 -7 3 3 -7 Strategist 3 Spell
    , Chara 107 "チュウタツ" 13 12 12 22 15 22 13 -7 -7 -7 -7 -7 5 -7 5 -7 5 -7 Strategist 4 Spell
    , Chara 108 "コウキン" 11 10 11 21 13 23 10 -7 -7 -7 -7 -7 -7 3 3 -7 3 -7 Strategist 5 Spell
    , Chara 109 "ハクゲン" 13 13 12 20 14 22 12 -4 -7 -7 -7 -7 4 -7 4 -7 4 -7 Strategist 6 GreatSword1
    , Chara 110 "モウトク" 12 11 12 19 12 21 12 -7 -7 -7 -5 -7 -7 3 -7 3 3 -7 Strategist 7 Bow
    , Chara 111 "コウメイ" 5 10 10 25 10 25 10 -7 -7 -7 -7 -7 5 -7 -7 5 5 -7 Strategist 8 Spell

    -- イーストガード
    , Chara 112 "ジュウベイ" 12 18 14 11 23 21 13 3 -7 -7 -7 -7 -7 -7 -6 -7 -7 -7 LevanteGuard 1 GreatSword1
    , Chara 113 "テッシュウ" 14 17 13 13 13 20 11 1 -7 -7 -7 -7 -7 -6 -7 -7 -7 -7 LevanteGuard 2 GreatSword1
    , Chara 114 "シュウサク" 13 16 15 12 14 21 10 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 3 GreatSword1
    , Chara 115 "ガンリュウ" 10 18 10 11 12 21 11 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 4 GreatSword1
    , Chara 116 "トシ" 11 20 12 13 15 20 12 3 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 5 GreatSword1
    , Chara 117 "レンヤ" 13 19 14 12 12 21 10 4 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 6 Sword1
    , Chara 118 "ボクデン" 15 16 12 14 14 22 11 2 -7 -7 2 -7 -7 -7 -6 -7 -7 -7 LevanteGuard 7 GreatSword1
    , Chara 119 "ソウジ" 1 22 12 14 13 24 11 3 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 LevanteGuard 8 GreatSword1

    -- デザートガード
    , Chara 120 "シャールカーン" 12 19 12 17 16 13 18 2 -7 -7 -7 -7 -7 -7 -7 -4 -7 -7 DesertGuard 1 Sword1
    , Chara 121 "ネマーン" 11 20 13 16 14 12 19 1 -7 -7 1 -7 -7 -7 -5 -7 -7 -7 DesertGuard 2 General
    , Chara 122 "ダンダーン" 14 18 15 18 17 12 18 2 -7 -7 -7 -7 -7 -7 -7 -6 -7 -7 DesertGuard 3 General
    , Chara 123 "シャハリヤール" 15 19 13 16 15 13 19 1 -7 -7 1 1 -7 -7 -7 -5 -7 -7 DesertGuard 4 Sword2
    , Chara 124 "アバールハサン" 10 18 14 17 13 14 17 3 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 DesertGuard 5 General
    , Chara 125 "マルザワーン" 12 20 12 16 16 14 18 1 -7 -7 1 -7 -7 -7 -5 -7 -7 -7 DesertGuard 6 General
    , Chara 126 "アルマノス" 14 19 15 18 14 12 16 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 DesertGuard 7 General
    , Chara 127 "スライマーン" 13 19 14 18 13 13 19 2 -7 -7 2 2 -7 -7 -7 -6 -7 -7 DesertGuard 8 Sword1

    -- アマゾネス
    , Chara 128 "ジャンヌ" 11 17 19 13 10 17 19 -7 3 3 3 -7 -7 -7 -7 -7 -7 -7 Amazon 1 SpearAxe
    , Chara 129 "クリームヒルト" 8 15 20 12 14 18 18 -7 2 2 2 -7 -7 -7 -7 -7 -7 -7 Amazon 2 SpearAxe
    , Chara 130 "エカテリーナ" 15 14 18 15 21 16 21 1 -7 -7 1 1 -7 -7 -7 -7 -7 -7 Amazon 3 SpearAxe
    , Chara 131 "テオドラ" 10 17 19 12 16 18 17 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 Amazon 4 Spear
    , Chara 132 "アグリッピナ" 11 15 19 13 15 17 19 -7 2 2 2 -7 -7 -7 -7 -7 -7 -7 Amazon 5 SpearAxe
    , Chara 133 "アルテミシア" 8 15 20 14 14 16 18 -7 -7 -7 5 -7 -7 -7 -7 -7 -6 -7 Amazon 6 Bow
    , Chara 134 "ブコウ" 13 16 17 14 13 15 20 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 Amazon 7 SpearAxe
    , Chara 135 "トモエ" 14 19 18 12 18 17 18 3 3 -7 3 -7 -7 -7 -7 -7 -7 -7 Amazon 8 SpearAxe

    -- ハンター
    , Chara 136 "ハムバ" 10 12 24 10 12 14 15 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 Hunter 1 Bow
    , Chara 137 "クワワ" 12 11 22 12 17 13 16 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 Hunter 2 Bow
    , Chara 138 "ムジュグ" 11 13 24 11 14 15 14 -7 -7 -7 2 2 -7 -7 -7 -7 -7 -7 Hunter 3 Bow
    , Chara 139 "バイ" 8 13 23 10 14 13 15 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 Hunter 4 Bow
    , Chara 140 "オセイ" 9 14 22 11 21 14 16 2 -7 -7 2 -7 -7 -7 -7 -7 -7 -7 Hunter 5 Bow
    , Chara 141 "ランガリ" 10 15 21 11 16 13 14 -7 2 -7 2 -7 -7 -7 -7 -7 -7 -7 Hunter 6 Bow
    , Chara 142 "ケチェワ" 14 12 24 11 13 12 17 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 Hunter 7 Bow
    , Chara 143 "ガダフム" 12 12 25 10 14 14 14 -7 -7 2 2 -7 -7 -7 -7 -7 -7 -7 Hunter 8 Bow

    -- ノーマッド(男)
    , Chara 144 "アルタン" 12 17 19 15 12 17 13 1 1 1 1 -7 -7 -7 -7 -5 -7 -7 NomadM 1 SpearAxe
    , Chara 145 "ガルタン" 11 18 17 15 11 16 14 -7 -7 2 2 2 -7 -7 -7 -7 -7 -7 NomadM 2 Axe
    , Chara 146 "バツー" 13 16 20 16 13 16 13 1 -7 1 1 -7 -7 -7 -7 -7 -7 -7 NomadM 3 Axe
    , Chara 147 "エセン" 9 17 18 16 18 17 12 -7 -7 1 1 1 -7 -7 1 -7 -7 -7 NomadM 4 Sword1
    , Chara 148 "ダヤン" 11 18 18 17 10 15 13 1 -7 1 1 -7 -7 -7 -7 -6 -7 -7 NomadM 5 Axe
    , Chara 149 "アクダ" 10 15 19 18 11 18 12 -7 -7 2 2 2 -7 -7 -7 -7 -7 -7 NomadM 6 Axe
    , Chara 150 "アボキ" 10 17 18 15 13 16 15 -7 -7 1 1 -7 -7 -7 -7 -6 -7 -7 NomadM 7 SpearAxe
    , Chara 151 "ボクトツ" 11 18 16 15 12 17 14 -7 -7 2 2 -7 -7 -7 -7 -7 -7 -7 NomadM 8 Axe

    -- ノーマッド(女)
    , Chara 152 "ファティマ" 8 15 18 18 23 17 13 2 -7 2 2 -7 -7 -7 -7 -5 -7 -7 NomadF 1 Bow
    , Chara 153 "ベスマ" 9 16 17 18 12 16 15 -7 -7 1 1 -7 -6 -7 -7 -7 -7 -7 NomadF 2 Bow
    , Chara 154 "アリア" 9 14 19 20 10 16 13 -7 -7 1 1 -7 -7 -7 -7 -7 -7 -7 NomadF 3 Bow
    , Chara 155 "ミズラ" 10 14 19 17 13 18 14 -7 -7 2 2 -7 -7 -7 -7 -5 -7 -7 NomadF 4 Bow
    , Chara 156 "アズィーザ" 6 14 18 18 11 17 15 -7 -7 1 1 1 -7 -7 -7 -7 -7 -7 NomadF 5 Mace
    , Chara 157 "ドニヤ" 10 15 19 19 13 16 13 -7 -7 2 2 -7 -7 -7 -7 -7 -7 -7 NomadF 6 Sword2
    , Chara 158 "ノーズハトゥ" 11 12 20 16 11 19 14 -7 -7 1 1 -7 -7 -7 -6 -7 -7 -7 NomadF 7 Bow
    , Chara 159 "シャハラザード" 12 14 20 17 12 18 14 -7 -7 2 2 -7 -7 -7 -7 -6 -7 -7 NomadF 8 Bow

    -- ホーリーオーダー(男)
    , Chara 160 "ゲオルグ" 14 21 13 16 10 11 18 5 5 5 -7 -7 -7 4 -7 -7 -7 -7 CrusaderM 1 SpearAxe
    , Chara 161 "ピーター" 13 20 14 15 11 13 17 3 3 -7 -7 -7 -7 -7 2 -7 -7 -7 CrusaderM 2 General
    , Chara 162 "ポール" 15 22 12 15 10 12 19 3 -7 -7 -7 -7 -7 2 -7 -7 -7 -7 CrusaderM 3 SpearAxe
    , Chara 163 "ジェイコブ" 12 21 13 15 10 13 18 2 2 -7 -7 -7 -7 -7 -7 1 -7 -7 CrusaderM 4 SpearAxe
    , Chara 164 "ベネディクト" 13 20 14 18 10 11 17 2 -7 -7 -7 -7 -7 2 -7 -7 -7 -7 CrusaderM 5 Sword1
    , Chara 165 "バランタイン" 15 22 13 17 11 12 16 4 -7 -7 -7 -7 -7 -7 -7 2 -7 -7 CrusaderM 6 General
    , Chara 166 "ウルバン" 12 21 12 15 10 14 17 2 -7 -7 -7 -7 -7 -7 1 -7 1 -7 CrusaderM 7 SpearAxe
    , Chara 167 "クリストフ" 14 21 12 15 10 12 20 3 -7 -7 -7 3 -7 -7 -7 3 -7 -7 CrusaderM 8 Sword2

    -- ホーリーオーダー(女)
    , Chara 168 "ソフィア" 12 12 11 24 13 12 12 -7 -7 1 -7 -7 -7 4 -7 -7 4 -7 CrusaderF 1 Mace
    , Chara 169 "アガタ" 11 13 12 22 13 12 12 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 2 Spell
    , Chara 170 "モニカ" 8 12 12 23 13 11 12 -7 -7 2 -7 -7 -7 2 -7 -7 2 -7 CrusaderF 3 Spell
    , Chara 171 "ガートルード" 13 14 11 22 12 13 11 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 4 Spell
    , Chara 172 "バルバラ" 11 13 10 22 13 14 14 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 5 Mace
    , Chara 173 "マチルダ" 12 14 12 21 12 13 13 -7 -7 2 -7 -7 -7 2 -7 -7 2 -7 CrusaderF 6 Mace
    , Chara 174 "マグダレーナ" 14 13 14 22 12 11 12 -7 -7 1 -7 -7 -7 1 -7 -7 1 -7 CrusaderF 7 Spell
    , Chara 175 "マリア" 12 13 11 23 11 12 13 -7 -7 1 -7 -7 -7 3 -7 -7 3 -7 CrusaderF 8 Mace

    -- 海女
    , Chara 176 "ナタリー" 8 15 16 18 13 19 17 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 1 Spell
    , Chara 177 "マライア" 6 16 14 19 14 18 19 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 2 Spell
    , Chara 178 "ジャニス" 7 14 15 18 11 19 16 -7 -4 -7 -7 -7 -7 -7 4 -7 4 -7 Diver 3 Spell
    , Chara 179 "オリヴィア" 6 15 16 16 12 18 18 -7 -3 -7 -7 -7 -7 -7 1 -7 1 -7 Diver 4 Mace
    , Chara 180 "ケイト" 9 14 17 18 12 20 17 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 5 Spell
    , Chara 181 "サラ" 8 16 14 18 13 17 18 -7 -3 -7 -7 -7 -7 -7 1 -7 1 -7 Diver 6 Spell
    , Chara 182 "デビー" 11 17 15 17 12 19 19 -7 -3 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 7 Spell
    , Chara 183 "リンダ" 8 14 17 18 22 18 17 -7 -4 -7 -7 -7 -7 -7 2 -7 2 -7 Diver 8 Spell

    -- 武装商船団
    , Chara 184 "エンリケ" 13 17 16 12 13 21 15 -7 -7 2 2 -7 -7 -4 -7 -7 -7 -7 ArmedMerchant 1 Axe
    , Chara 185 "マゼラン" 12 18 14 13 16 20 17 -7 -7 3 -7 3 -7 -7 -7 -7 -7 -7 ArmedMerchant 2 SpearAxe
    , Chara 186 "ガマ" 14 17 15 12 15 22 15 2 -7 2 -7 -7 -7 -7 -7 -7 -7 -7 ArmedMerchant 3 Bow
    , Chara 187 "マハン" 11 17 17 11 16 20 16 -7 -7 2 2 -7 -7 -3 -7 -7 -7 -7 ArmedMerchant 4 SpearAxe
    , Chara 188 "フィッシャー" 13 18 14 12 20 20 17 -7 -7 2 -7 2 -7 -7 -7 -7 -7 -7 ArmedMerchant 5 Axe
    , Chara 189 "ティルピッツ" 9 19 15 11 14 21 16 -7 2 2 -7 -7 -7 -7 -7 -7 -7 -7 ArmedMerchant 6 SpearAxe
    , Chara 190 "テイワ" 12 16 18 11 15 20 16 -7 -7 1 1 -7 -7 -3 -7 -7 -7 -7 ArmedMerchant 7 Axe
    , Chara 191 "ドレイク" 15 18 16 10 21 22 15 1 -7 1 1 -7 -7 -7 -2 -7 -7 -7 ArmedMerchant 8 Sword1

    -- サイゴ族
    , Chara 192 "エイリーク" 13 18 14 12 11 12 21 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 -7 SaigoClansman 1 Mace
    , Chara 193 "ハールファグル" 12 19 13 13 10 13 20 -7 -7 1 -7 1 -7 -7 -7 -7 -7 -7 SaigoClansman 2 Mace
    , Chara 194 "パールナ" 14 18 13 11 10 14 21 -7 -7 2 -7 2 -7 -7 -7 -7 -7 -7 SaigoClansman 3 MartialSkill2
    , Chara 195 "アリンビョルン" 12 17 14 12 12 13 22 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 -7 SaigoClansman 4 Mace
    , Chara 196 "エギル" 14 19 11 13 11 15 21 -7 -7 1 -7 1 -7 -7 -7 -7 -7 -7 SaigoClansman 5 MartialSkill1
    , Chara 197 "オーラーヴ" 11 17 13 11 10 11 22 -7 -7 2 -7 2 -7 -7 -7 -7 -7 -7 SaigoClansman 6 Mace
    , Chara 198 "シグルズ" 10 16 14 13 13 12 20 -7 -7 3 -7 -7 -7 -7 -7 -7 -7 -7 SaigoClansman 7 Mace
    , Chara 199 "スノリ" 12 18 12 11 12 14 21 -7 -7 5 -7 5 -7 -7 -7 -7 -7 -7 SaigoClansman 8 MartialSkill1

    -- 格闘家
    , Chara 200 "カール" 16 17 14 11 12 14 23 -7 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 Brawler 1 MartialSkill2
    , Chara 201 "フリッツ" 14 19 11 10 11 15 22 -7 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 Brawler 2 MartialSkill2
    , Chara 202 "ダイナマイト" 28 18 12 10 13 16 21 -7 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 Brawler 3 MartialSkill2
    , Chara 203 "テリー" 13 17 13 11 12 14 23 -7 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 Brawler 4 MartialSkill2
    , Chara 204 "ブルーザー" 14 19 11 10 10 15 24 -7 -7 -7 -7 1 -7 -7 -7 -7 -7 -7 Brawler 5 MartialSkill2
    , Chara 205 "ベイダー" 16 23 10 10 10 10 25 -7 -7 -7 -7 4 -7 -7 -7 -7 -7 -7 Brawler 6 MartialSkill2
    , Chara 206 "ハセ" 19 17 13 11 11 16 23 -7 -7 -7 -7 2 -7 -7 -7 -7 -7 -7 Brawler 7 MartialSkill2
    , Chara 207 "ライガー" 13 18 14 10 11 18 19 -7 -7 -7 -7 3 -7 -7 -7 -7 -7 -7 Brawler 8 MartialSkill1

    -- シティシーフ(男)
    , Chara 208 "スパロー" 12 15 19 12 11 19 15 1 -7 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondM 1 Bow
    , Chara 209 "クロウ" 9 16 18 13 12 21 14 1 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 2 ShortSword
    , Chara 210 "ロビン" 13 15 19 13 11 19 15 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 3 Sword2
    , Chara 211 "ピジョン" 11 16 18 11 13 20 16 1 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 4 Sword2
    , Chara 212 "スターリング" 10 17 18 11 23 19 14 1 1 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 5 Sword1
    , Chara 213 "スイフト" 8 16 17 12 16 20 15 1 1 -7 -7 -7 -7 -7 -7 -3 -7 -7 VagabondM 6 ShortSword
    , Chara 214 "スラッシュ" 7 16 18 14 15 19 14 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondM 7 Sword1
    , Chara 215 "ファルコン" 10 15 17 13 12 21 13 0 0 -7 0 -7 -7 -7 -7 -7 -7 -7 VagabondM 8 Bow

    -- シティシーフ(男)
    , Chara 216 "キャット" 9 15 18 13 24 22 12 -7 1 -7 -7 1 -7 -7 -7 -7 0 -7 VagabondF 1 MartialSkill2
    , Chara 217 "ビーバー" 11 13 18 15 11 19 13 -7 2 -7 -7 -7 -7 -4 -7 -7 -7 -7 VagabondF 2 ShortSword
    , Chara 218 "バジャー" 8 13 17 16 15 18 12 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondF 3 Bow
    , Chara 219 "マウス" 9 13 18 17 12 18 11 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondF 4 ShortSword
    , Chara 220 "ラビット" 7 14 17 13 23 21 10 -7 3 -7 -7 -7 -7 -7 -7 -7 -6 -7 VagabondF 5 Sword1
    , Chara 221 "フェレット" 9 15 18 14 16 19 11 -7 1 -7 -7 -7 -7 -7 2 -7 -7 -7 VagabondF 6 Sword1
    , Chara 222 "ウィーゼル" 6 13 18 15 18 20 10 -7 1 -7 1 -7 -7 -7 -7 -7 -7 -7 VagabondF 7 ShortSword
    , Chara 223 "フォックス" 8 13 20 16 15 19 10 -7 2 -7 -7 -7 -7 -7 -7 -7 -7 -7 VagabondF 8 ShortSword

    -- サラマンダー
    , Chara 224 "ケルート" 13 22 10 18 13 11 20 -7 -7 2 -7 2 3 -7 -7 -7 -7 -7 Salamander 1 Axe
    , Chara 225 "タンボラ" 12 23 11 19 12 10 21 -7 -7 2 -7 2 4 -7 -7 -7 -7 -7 Salamander 2 Mace
    , Chara 226 "ガルンガン" 11 22 10 18 11 12 21 -7 -7 3 -7 3 3 -7 -7 -7 -7 -7 Salamander 3 MartialSkill2
    , Chara 227 "アウ" 14 24 12 17 12 11 20 -7 -7 2 -7 2 5 -7 -7 -7 -7 -7 Salamander 4 MartialSkill2
    , Chara 228 "メラピ" 12 21 11 16 13 10 22 -7 2 2 -7 2 4 -7 -7 -7 -7 -7 Salamander 5 Mace
    , Chara 229 "アグン" 13 22 10 17 16 12 21 -7 -7 2 -7 2 3 -7 -7 -7 -7 -7 Salamander 6 Axe
    , Chara 230 "ソプタン" 11 21 11 19 11 12 22 -7 -7 2 -7 2 2 -7 -7 -7 -7 -7 Salamander 7 GreatSword2
    , Chara 231 "パパンダヤン" 14 21 10 18 12 14 21 -7 -7 3 -7 3 3 -7 -7 -7 -7 -7 Salamander 8 MartialSkill2

    -- モール
    , Chara 232 "シエロ" 12 10 21 18 14 11 22 -7 3 -7 -7 -7 -7 -7 -7 4 -7 -7 Mole 1 ShortSword
    , Chara 233 "レゴ" 13 12 22 19 15 10 20 -7 1 -7 -7 1 -7 -7 -7 3 -7 -7 Mole 2 ShortSword
    , Chara 234 "チェルノ" 15 11 21 18 13 12 21 -7 1 1 -7 -7 -7 -7 -7 2 -7 -7 Mole 3 ShortSword
    , Chara 235 "ポド" 12 10 22 17 12 11 21 -7 0 -7 -7 -7 -7 -7 -7 5 -7 -7 Mole 4 ShortSword
    , Chara 236 "ラト" 14 11 20 20 11 11 22 -7 2 -7 -7 2 -7 -7 -7 3 -7 -7 Mole 5 ShortSword
    , Chara 237 "グライ" 11 12 22 17 12 12 20 -7 1 -7 -7 -7 -7 -7 -7 4 -7 -7 Mole 6 ShortSword
    , Chara 238 "バーティ" 13 10 21 16 19 11 23 -7 1 -7 -7 1 -7 -7 -7 5 -7 -7 Mole 7 ShortSword
    , Chara 239 "ブルニ" 12 11 23 18 14 12 21 -7 2 -7 -7 2 -7 -7 -7 3 -7 -7 Mole 8 ShortSword

    -- ネレイド
    , Chara 240 "テティス" 8 10 22 19 14 21 10 -7 -7 -2 -7 -7 -7 4 -7 -7 -7 -7 Nereid 1 Spell
    , Chara 241 "ペルーサ" 9 10 21 17 13 20 10 -7 -7 -3 -7 -7 -7 5 -7 -7 -7 -7 Nereid 2 Mace
    , Chara 242 "リューシアナッサ" 9 10 23 18 15 22 10 -7 -7 -2 -7 -7 -7 5 -7 -7 -7 -7 Nereid 3 Spell
    , Chara 243 "メリテー" 7 10 22 17 13 21 10 -7 -7 -4 -7 -7 -7 4 -7 -7 -7 -7 Nereid 4 Spell
    , Chara 244 "アムピトリーテ" 10 10 21 20 14 23 10 -7 -7 -3 -7 -7 -7 5 -7 -7 -7 -7 Nereid 5 Spell
    , Chara 245 "ナウシトエ" 9 10 25 17 13 21 10 -7 -7 -2 -7 -7 -7 4 -7 -7 -7 -7 Nereid 6 Spell
    , Chara 246 "サオー" 7 10 21 18 14 22 10 -7 -7 -3 -7 -7 -7 3 -7 -7 -7 -7 Nereid 7 Mace
    , Chara 247 "ガラテイア" 9 10 24 19 18 20 10 -7 -7 -1 -7 -7 -7 5 -7 -7 -7 -7 Nereid 8 Spell

    -- イーリス
    , Chara 248 "ウィンディ" 7 10 17 21 13 20 10 -7 -7 -7 0 -7 -7 -7 5 -7 -7 -7 Iris 1 Bow
    , Chara 249 "クラウディア" 6 10 18 21 12 24 10 -7 -7 -7 -2 -7 -7 -7 3 -7 -7 -7 Iris 2 Bow
    , Chara 250 "スカイア" 8 10 19 24 11 21 10 -7 -7 -7 -7 -7 -7 -7 5 -7 -7 -7 Iris 3 Bow
    , Chara 251 "ブレズィア" 7 10 17 23 13 20 10 -7 -7 -7 -3 -7 -7 -7 4 -7 -7 -7 Iris 4 Bow
    , Chara 252 "ゲイル" 6 10 18 23 15 22 10 -7 -7 -7 -1 -7 -7 -7 4 -7 -7 -7 Iris 5 Bow
    , Chara 253 "エア" 8 10 17 24 12 21 10 -7 -7 -7 -7 -7 -7 -7 6 -7 -7 -7 Iris 6 Bow
    , Chara 254 "ストーミー" 7 10 19 24 15 20 10 -7 -7 -7 -7 -7 -7 -7 7 -7 -7 -7 Iris 7 Bow
    , Chara 255 "ナディール" 9 10 20 23 13 23 10 -7 -7 -7 -7 -7 -7 -7 5 -7 -7 -7 Iris 8 Bow

    -- 特殊
    , Chara 300 "レオン" 19 19 17 20 12 14 20 5 2 0 0 0 0 0 0 0 2 0 SpecialChara 0 CannotSpark
    , Chara 301 "ジェラール" 16 17 22 19 11 20 11 0 0 0 0 0 0 0 0 0 0 0 SpecialChara 0 Spell
    , Chara 302 "コッペリア" 99 20 20 15 15 20 20 15 15 15 15 15 0 0 0 0 0 0 SpecialChara 0 CannotSpark
    , Chara 303 "最終皇帝(男)" 19 25 23 23 15 24 21 10 5 5 5 5 0 0 0 0 10 0 SpecialChara 0 Sword2
    , Chara 304 "最終皇帝(女)" 10 23 24 24 15 25 20 10 5 5 5 5 0 0 0 0 10 0 SpecialChara 0 Sword2
    ]