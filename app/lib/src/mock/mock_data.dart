import 'dart:math' as math;

import '../models.dart';

/// モックユーザーは「anchor（中心点）からの相対距離」で配置する。
/// anchor には実 GPS で取得した現在地が入り、どこにいても近くの走りとも候補が並ぶ。
class _MockSpec {
  final String id;
  final String nickname;
  final String decade;
  final String gender;
  final String iconCategoryId;
  final List<String> interestIds;
  final String bio;
  final double northKm; // anchor からの北方向距離
  final double eastKm; // anchor からの東方向距離

  const _MockSpec(this.id, this.nickname, this.decade, this.gender,
      this.iconCategoryId, this.interestIds, this.bio, this.northKm,
      this.eastKm);
}

const List<_MockSpec> _specs = [
  _MockSpec(
    'u-jdm-ken',
    'JDM好きのけん',
    '30代',
    'male',
    'jdm',
    ['jdm', 'drift', 'photo'],
    '国産スポーツを所有。週末は峠よりサーキット派です。整備も自分でやります。',
    0.6,
    0.2,
  ),
  _MockSpec(
    'u-import-akira',
    '旧い外車のあきら',
    '40代',
    'male',
    'import',
    ['import', 'classic', 'touring'],
    '往年の欧州車を2台保有。日曜の早朝ドライブが習慣です。',
    -0.3,
    -0.1,
  ),
  _MockSpec(
    'u-drift-nana',
    'ドリフトのなな',
    '20代',
    'female',
    'drift',
    ['drift', 'jdm', 'photo'],
    'ドリフト走行会に月1で参加。練習風景の動画撮影もやっています。',
    0.15,
    -0.4,
  ),
  _MockSpec(
    'u-touge-sora',
    '峠好きのそら',
    '20代',
    'undisclosed',
    'touge',
    ['touge', 'classic', 'jdm'],
    '山林道の景色を眺めに行くのが好きです（安全運転）。',
    -0.7,
    0.5,
  ),
  _MockSpec(
    'u-bike-miu',
    'バイクのみう',
    '20代',
    'female',
    'bike',
    ['bike', 'touring', 'photo'],
    '大型二輪でツーリングが趣味。道の駅カフェ巡りもしています。',
    1.2,
    -0.9,
  ),
  _MockSpec(
    'u-wash-kei',
    '洗車マニアのけい',
    '30代',
    'undisclosed',
    'wash',
    ['wash', 'jdm', 'maint'],
    '週1洗車、月1コーティング。近所で洗車会も開いています。',
    -1.1,
    1.0,
  ),
  _MockSpec(
    'u-maint-hina',
    '整備士のひな',
    '30代',
    'female',
    'maint',
    ['maint', 'classic', 'event'],
    '整備士です。旧車のプラグ調整から何でも。教えるのが好きです。',
    0.9,
    0.35,
  ),
  _MockSpec(
    'u-photo-kyo',
    '撮影担当のきょう',
    '40代',
    'male',
    'photo',
    ['photo', 'event', 'jdm'],
    '走り系のカメラ担当です。サーキット撮影歴10年。撮るのも撮られるのも両方。',
    0.45,
    -1.3,
  ),
];

class _BusinessSpec {
  final String id;
  final String nickname;
  final String iconCategoryId;
  final String storeType;
  final String bio;
  final double northKm;
  final double eastKm;

  const _BusinessSpec(this.id, this.nickname, this.iconCategoryId,
      this.storeType, this.bio, this.northKm, this.eastKm);
}

const List<_BusinessSpec> _businessSpecs = [
  _BusinessSpec(
    'b-pit-screw',
    'ピットクルー スクリュー',
    'maint',
    'カーショップ・整備工場',
    '現車調整からオイル交換まで幅広く承ります。走行会前の点検もどうぞ。',
    0.8,
    0.9,
  ),
  _BusinessSpec(
    'b-gas-rock',
    'ガソリンスタンド ロック',
    'jdm',
    'ガソリンスタンド',
    '深夜もセルフ対応中。ハイオクも揃っています。給油の待ち時間にコーヒーもどうぞ。',
    -0.5,
    1.1,
  ),
  _BusinessSpec(
    'b-parts-market',
    'パーツマーケット246',
    'maint',
    'カー用品店',
    'マフラー、サスペンション等の在庫多数。取り付けは当店の整備班へ。',
    1.5,
    -0.6,
  ),
  _BusinessSpec(
    'b-michi-ekimachi',
    '道の駅 はしりや橋',
    'touring',
    'ドライブイン・道の駅',
    '地元食材の食堂と24時間の仮眠スペース。ツーリングの中休みにどうぞ。',
    -1.4,
    -0.8,
  ),
];

const double _kmPerDegLat = 111.32;

AppUser _specToUser(_MockSpec s, double anchorLat, double anchorLng) {
  final cos =
      math.cos(anchorLat * math.pi / 180.0).abs().clamp(0.01, 1.0);
  return AppUser(
    id: s.id,
    nickname: s.nickname,
    decade: s.decade,
    gender: s.gender,
    iconCategoryId: s.iconCategoryId,
    interestIds: s.interestIds,
    bio: s.bio,
    lat: anchorLat + s.northKm / _kmPerDegLat,
    lng: anchorLng + s.eastKm / (_kmPerDegLat * cos),
  );
}

BusinessUser _specToBusiness(
    _BusinessSpec s, double anchorLat, double anchorLng) {
  final cos =
      math.cos(anchorLat * math.pi / 180.0).abs().clamp(0.01, 1.0);
  return BusinessUser(
    id: s.id,
    nickname: s.nickname,
    decade: '経営者',
    gender: 'undisclosed',
    iconCategoryId: s.iconCategoryId,
    interestIds: const [],
    bio: s.bio,
    lat: anchorLat + s.northKm / _kmPerDegLat,
    lng: anchorLng + s.eastKm / (_kmPerDegLat * cos),
    storeType: s.storeType,
  );
}

/// 現在地を中心にモックユーザー（一般 + ビジネス）を配置する。
List<AppUser> buildMockUsers(double anchorLat, double anchorLng) {
  return [
    for (final s in _specs) _specToUser(s, anchorLat, anchorLng),
    for (final s in _businessSpecs) _specToBusiness(s, anchorLat, anchorLng),
  ];
}

/// シード募集（起動時刻からの残り時間で作るので、いつ開いても「今から」感が出る）。
/// host は generalUsers（モック一般ユーザー）から id で引く。
List<Recruitment> seedRecruitments(DateTime now, List<AppUser> generalUsers) {
  Recruitment make({
    required String hostId,
    required String genreId,
    required String title,
    required String body,
    required String meetup,
    required int capacity,
    required int minutesLeft,
  }) {
    return Recruitment(
      id: 'r-$hostId',
      hostId: hostId,
      genreId: genreId,
      title: title,
      body: body,
      meetup: meetup,
      capacity: capacity,
      createdAt: now.subtract(const Duration(minutes: 15)),
      expiresAt: now.add(Duration(minutes: minutesLeft)),
      memberIds: [hostId],
    );
  }

  return [
    make(
      hostId: 'u-jdm-ken',
      genreId: 'run',
      title: '今から海手前のワインディングまで走りませんか',
      body: '国産スポーツでのんびり走ります。先導は私がやります。初心者・現車見学も歓迎。',
      meetup: '料金所手前のコンビニ駐車場',
      capacity: 3,
      minutesLeft: 105,
    ),
    make(
      hostId: 'u-import-akira',
      genreId: 'touring',
      title: '明日の朝イチ、朝ツーしませんか',
      body: '旧い外車で早朝の峠を流しに行きます。途中で道の駅による予定。安全第一で。',
      meetup: '道の駅 はしりや橋 第2駐車場',
      capacity: 3,
      minutesLeft: 70,
    ),
    make(
      hostId: 'u-photo-kyo',
      genreId: 'run',
      title: '今週末の走行会、撮影しませんか',
      body: 'サーキット撮影の同行カメラさんを探しています。データは後日お渡しします。',
      meetup: 'サーキット 正面ゲート前',
      capacity: 4,
      minutesLeft: 160,
    ),
    make(
      hostId: 'u-bike-miu',
      genreId: 'meet',
      title: 'ツーリング後のお茶会しませんか',
      body: '走った後の道の駅カフェでまったりしませんか。バイクの方、車の方どちらも大歓迎。',
      meetup: '道の駅 はしりや橋 喫茶コーナー',
      capacity: 2,
      minutesLeft: 95,
    ),
    make(
      hostId: 'u-drift-nana',
      genreId: 'meet',
      title: '整備・洗車会をやります',
      body: '走行会前の準備で洗車と簡易点検を一緒にやる会です。道具は貸します。',
      meetup: 'ガソリンスタンド ロック 裏の駐車場',
      capacity: 4,
      minutesLeft: 130,
    ),
    make(
      hostId: 'u-maint-hina',
      genreId: 'meet',
      title: '次のミーティング、合同参加しませんか',
      body: '旧車オフ会に合同で参加できそうな方を探しています。整備の相談もできます。',
      meetup: 'イベント会場最寄り駅',
      capacity: 3,
      minutesLeft: 45,
    ),
  ];
}

/// 近況報告のシード。anchor（現在地）からの相対距離で配置する。
/// id が 'cx-seed-' 始まりのものは GPS 更新のたびに再配置される
/// （AppState.applyGps を参照）。
class _ExchangeSeedSpec {
  final String id;
  final String posterId;
  final String kind;
  final String itemDescription;
  final String areaName;
  final String detail;
  final double northKm;
  final double eastKm;
  final Duration age;
  const _ExchangeSeedSpec(this.id, this.posterId, this.kind,
      this.itemDescription, this.areaName, this.detail, this.northKm,
      this.eastKm, this.age);
}

const List<_ExchangeSeedSpec> _exchangeSeedSpecs = [
  _ExchangeSeedSpec(
    'cx-seed-1',
    'u-drift-nana',
    'shoot',
    '夕暮れの海沿いで愛車を撮影してきました',
    '海手前の道の駅 周辺',
    'サンセットの時間帯は反射が綺麗です。'
        '同じ時間帯に撮りに行く仲間を募集しています。',
    0.3,
    -0.6,
    Duration(hours: 2),
  ),
  _ExchangeSeedSpec(
    'cx-seed-2',
    'u-bike-miu',
    'post',
    '今週末はツーリングの予定です',
    '駅裏の駐車場 周辺',
    '整備も終わって準備万端です。'
        '同じルートを走る方がいたら一緒に行きましょう。',
    -0.2,
    0.8,
    Duration(hours: 5),
  ),
  _ExchangeSeedSpec(
    'cx-seed-3',
    'u-maint-hina',
    'event',
    '○○サーキットの走行会に参加してきました',
    '市役所裏の駐車場 周辺',
    '初めての走行会でしたが先輩方に教えてもらえて'
        '勉強になりました。次回も参加予定です。',
    -0.9,
    -0.3,
    Duration(hours: 26),
  ),
];

List<RunReport> buildSeedRunReports(
    DateTime now, double anchorLat, double anchorLng) {
  final cos = (anchorLat * math.pi / 180.0).abs().clamp(0.01, 1.0);
  return [
    for (final s in _exchangeSeedSpecs)
      RunReport(
        id: s.id,
        posterId: s.posterId,
        kind: s.kind,
        itemDescription: s.itemDescription,
        areaName: s.areaName,
        detail: s.detail,
        lat: anchorLat + s.northKm / _kmPerDegLat,
        lng: anchorLng + s.eastKm / (_kmPerDegLat * cos),
        createdAt: now.subtract(s.age),
      ),
  ];
}

/// モックの返信候補（デモの自動応答に使う。本開発では Supabase Realtime に置換）
const List<String> mockReplies = [
  'よろしくお願いします！',
  '次の走行会、楽しみですね。',
  '先に着いて駐車場を取っておきますね。',
  'このワインディングずっと気になっていました。',
];

/// モックの応募メッセージ
const List<String> mockApplyMessages = [
  '参加したいです！走る仲間を探していました。',
  '同じ車種に乗っているので嬉しいです。',
  'この近くをよく走っています。',
];
