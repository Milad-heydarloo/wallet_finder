

import '../../view_front_farbod/model/model_api_records.dart';
import '../Model/MachineEntity.dart';

abstract class ApiServiceBase {
  Future<List<MachineEntity>> fetchWalletRecords(String userId);

  Future<double> getEthBalance(String address, String apiKey);

  Future<double> getBnbBalance(String address, String apiKey);

  Future<double> getMaticBalance(String address, String apiKey);

  Future<double> getTrxBalance(String address);

  Future<double> getUsdtBalance(String address, String apiKey);

  Future<double> getBusdBalance(String address, String apiKey);

  Future<API_Record?> fetchAPIRecords();
}
