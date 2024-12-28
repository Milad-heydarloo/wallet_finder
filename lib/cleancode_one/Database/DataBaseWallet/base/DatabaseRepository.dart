import '../../../Model/ItemEntity.dart';
import '../../../Model/MachineEntity.dart';

abstract class DatabaseRepository {
  Future<void> insertMachine(MachineEntity machine);

  Future<List<MachineEntity>> getMachineEntitiesWithoutPriceAndColor();

  Future<List<MachineEntity>> getMachineWithItems();

  Future<MachineEntity?> getMachineById(String machineId);

  Future<void> updateItemPriceAndColor(
      String machineId, List<ItemEntity> items);

  Future<void> deleteMachine(String machineId);
}