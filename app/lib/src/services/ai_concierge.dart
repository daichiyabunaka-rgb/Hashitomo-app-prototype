import '../models.dart';

/// AI接客のデモ応答ロジック（プロトタイプ用のモック）。
/// 本開発では LLM API に置き換える。このロジックは店舗業態と
/// ユーザーの興味カテゴリからおすすめを案内する最低限のルールベース。
class AiConcierge {
  /// 最初の挨拶（店舗の口調 + ユーザーの興味を踏まえる）
  String greeting(AppUser me, BusinessUser store) {
    final interest = me.interestIds.isNotEmpty ? me.interestIds.first : null;
    final label = interest == null ? null : _categoryLabel(interest);
    final base = '${_opener(store)}'
        '${me.nickname}さん、${store.nickname}（${store.storeType}）のAI接客です。';
    if (label == null) {
      return '$base 走り・整備のことなら何でも聞いてください。';
    }
    return '$base $labelがお好みなんですね。'
        'うちの${_recommend(store)}がおすすめです。';
  }

  /// 店舗タイプごとの口調（本開発では LLM に店舗キャラ設定を渡して生成する）
  String _opener(BusinessUser store) {
    switch (store.storeType) {
      case 'ガソリンスタンド':
        return 'いらっしゃい！給油の待ち時間にコーヒーもどうぞ。';
      case 'カーショップ・整備工場':
        return 'いらっしゃいませ。点検・整備はお任せください。';
      case 'ドライブイン・道の駅':
        return 'こんにちは。休憩スペースと食堂もご案内できますよ。';
      case 'カー用品店':
        return 'いらっしゃい。パーツ探しもお手伝いします。';
      case 'サーキット・走行会場':
        return 'ようこそ。体験走行の枠も案内できますよ。';
      default:
        return 'いらっしゃいませ。';
    }
  }

  /// ユーザー発話への応答
  String reply(String input, AppUser me, BusinessUser store) {
    final text = input.replaceAll(RegExp(r'\s'), '');
    if (text.contains('予約') || text.contains('来店')) {
      return 'ありがとうございます。土日は混み合うため、'
          '平日の午前中でしたらゆっくりご案内できます。'
          'ご希望の時間をメモしておきますね。'
          '（デモのため実際の予約機能は本開発で提供します）';
    }
    if (text.contains('おすすめ') || text.contains('オススメ')) {
      return '今回は${_recommend(store)}がおすすめです。'
          '走行の予定や気になる整備内容があれば教えてください。';
    }
    if (text.contains('整備') || text.contains('オイル') ||
        text.contains('パーツ')) {
      return '初めての方も歓迎しています。'
          'ご希望のメニューに合わせて相談しながら進めます。';
    }
    if (text.contains('料金') || text.contains('いくら') ||
        text.contains('価格')) {
      return 'ご利用内容によって変わりますが、まずは一度お試しいただけます。'
          '詳しいプランは店舗ページをご確認ください（デモの固定値です）。';
    }
    if (text.contains('何時') || text.contains('営業時間')) {
      return '本日は10:00〜18:00で営業しております。'
          '混雑しやすいのは土曜午前です。（デモの固定値です）';
    }
    if (text.contains('トイレ') || text.contains('休憩')) {
      return 'トイレと仮眠スペースを備えています。'
          'お飲み物の自販機もありますので、ご利用ください。';
    }
    return '承知しました。「おすすめ」「料金」「営業時間」「予約」「整備」など、'
        '気になることを聞いていただければ答えます。';
  }

  String _recommend(BusinessUser store) {
    switch (store.storeType) {
      case 'ガソリンスタンド':
        return '洗車機付きの給油セット';
      case 'カーショップ・整備工場':
        return '走行会前のブレーキ点検パック';
      case 'ドライブイン・道の駅':
        return 'ご当地カレーとコーヒーの休憩セット';
      case 'カー用品店':
        return '季節の点検パーツ詰め合わせ';
      case 'サーキット・走行会場':
        return '平日の体験走行プラン';
      default:
        return 'おすすめサービス';
    }
  }

  String _categoryLabel(String id) {
    const labels = {
      'jdm': '国産車',
      'import': '外車・輸入車',
      'classic': '旧車・レストア',
      'sports': 'スポーツカー',
      'drift': 'ドリフト',
      'circuit': 'サーキット',
      'touge': '峠・ワインディング',
      'touring': 'ツーリング',
      'bike': 'バイク',
      'maint': '整備・メンテ',
      'wash': '洗車・ケア',
      'photo': '走り・カー撮影',
    };
    return labels[id] ?? '走りのこと';
  }
}

/// グローバルインスタンス（本開発では DI / LLM API クライアントに置き換える）
final AiConcierge aiConcierge = AiConcierge();
