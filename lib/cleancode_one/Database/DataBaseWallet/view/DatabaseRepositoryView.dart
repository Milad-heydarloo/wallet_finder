

import '../../../Model/MachineEntity.dart';

abstract class DatabaseRepositoryView {
  Future<void> insertMachine(MachineEntity machine);

  Future<List<MachineEntity>> getMachineWithItems();

  Future<void> deleteMachine(String machineId);
}