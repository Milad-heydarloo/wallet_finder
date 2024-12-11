//
//
// class BalanceRecord {
//   final String bnb;
//   final String btcNative;
//   final String btcLegacy;
//   final String eth;
//   final String busd;
//   final String trx;
//   final String usdt;
//   final String mnemonic;
//
//   BalanceRecord({
//     required this.bnb,
//     required this.btcNative,
//     required this.btcLegacy,
//     required this.eth,
//     required this.busd,
//     required this.trx,
//     required this.usdt,
//     required this.mnemonic,
//   });
//
//   factory BalanceRecord.fromJson(Map<String, dynamic> json) {
//     return BalanceRecord(
//       bnb: json['bnb'],
//       btcNative: json['btc_n'],
//       btcLegacy: json['btc_o'],
//       eth: json['eth'],
//       busd: json['busd'],
//       trx: json['trx'],
//       usdt: json['usdt'],
//       mnemonic: json['memonic'],
//     );
//   }
// }
// class BalanceRecord {
//   final String bnb;
//   final String btcNative;
//   final String btcLegacy;
//   final String eth;
//   final String busd;
//   final String trx;
//   final String usdt;
//   final String mnemonic;
//
//   BalanceRecord({
//     required this.bnb,
//     required this.btcNative,
//     required this.btcLegacy,
//     required this.eth,
//     required this.busd,
//     required this.trx,
//     required this.usdt,
//     required this.mnemonic,
//   });
//
//   factory BalanceRecord.fromJson(Map<String, dynamic> json) {
//     return BalanceRecord(
//       bnb: json['bnb'] ?? '',
//       btcNative: json['btc_n'] ?? '',
//       btcLegacy: json['btc_o'] ?? '',
//       eth: json['eth'] ?? '',
//       busd: json['busd'] ?? '',
//       trx: json['trx'] ?? '',
//       usdt: json['usdt'] ?? '',
//       mnemonic: json['memonic'] ?? '',
//     );
//   }
//   // تبدیل شیء به JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'bnb': bnb,
//       'btc_n': btcNative,
//       'btc_o': btcLegacy,
//       'eth': eth,
//       'busd': busd,
//       'trx': trx,
//       'usdt': usdt,
//       'memonic': mnemonic,
//     };
//   }
// }
class BalanceRecord {
  final String id; // افزودن ID به مدل
  final String bnb;
  final String btcNative;
  final String btcLegacy;
  final String eth;
  final String busd;
  final String trx;
  final String usdt;
  final String mnemonic;

  BalanceRecord({
    required this.id,
    required this.bnb,
    required this.btcNative,
    required this.btcLegacy,
    required this.eth,
    required this.busd,
    required this.trx,
    required this.usdt,
    required this.mnemonic,
  });

  factory BalanceRecord.fromJson(Map<String, dynamic> json) {
    return BalanceRecord(
      id: json['id'] ?? '', // مقدار ID از JSON
      bnb: json['bnb'] ?? '',
      btcNative: json['btc_n'] ?? '',
      btcLegacy: json['btc_o'] ?? '',
      eth: json['eth'] ?? '',
      busd: json['busd'] ?? '',
      trx: json['trx'] ?? '',
      usdt: json['usdt'] ?? '',
      mnemonic: json['memonic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // اضافه کردن ID به JSON
      'bnb': bnb,
      'btc_n': btcNative,
      'btc_o': btcLegacy,
      'eth': eth,
      'busd': busd,
      'trx': trx,
      'usdt': usdt,
      'memonic': mnemonic,
    };
  }
}
