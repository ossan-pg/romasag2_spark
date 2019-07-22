module Data exposing (CharaClassType(..), CharaClass, charaClasses)

{-|

@docs CharaClassType, CharaClass, charaClasses

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
