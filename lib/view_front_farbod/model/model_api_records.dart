// class API_Record {
//   final String bscScanApi;
//   final String etherscanApi;
//   final String infuraApi;
//   final String polygonScanApi;
//   final String id;
//
//
//   API_Record({
//     required this.bscScanApi,
//     required this.etherscanApi,
//     required this.infuraApi,
//     required this.polygonScanApi,
//     required this.id,
//
//   });
//
//   // Factory method to create an object from a JSON map
//   factory API_Record.fromJson(Map<String, dynamic> json) {
//     return API_Record(
//       bscScanApi: json['BscScan_API'] ?? '',
//       etherscanApi: json['Etherscan_API'] ?? '',
//       infuraApi: json['Infura_API'] ?? '',
//       polygonScanApi: json['PolygonScan_API'] ?? '',
//       id: json['id'] ?? '',
//     );
//   }
//
//   // Method to convert the object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       'BscScan_API': bscScanApi,
//       'Etherscan_API': etherscanApi,
//       'Infura_API': infuraApi,
//       'PolygonScan_API': polygonScanApi,
//       'id': id,
//     };
//   }
// }
class API_Record {
  final String bscScanApi;
  final String etherscanApi;
  final String infuraApi;
  final String polygonScanApi;
  final String id;

  API_Record({
    required this.bscScanApi,
    required this.etherscanApi,
    required this.infuraApi,
    required this.polygonScanApi,
    required this.id,
  });

  factory API_Record.fromJson(Map<String, dynamic> json) {
    return API_Record(
      bscScanApi: json['BscScan_API'] ?? '',
      etherscanApi: json['Etherscan_API'] ?? '',
      infuraApi: json['Infura_API'] ?? '',
      polygonScanApi: json['PolygonScan_API'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BscScan_API': bscScanApi,
      'Etherscan_API': etherscanApi,
      'Infura_API': infuraApi,
      'PolygonScan_API': polygonScanApi,
      'id': id,
    };
  }
}
