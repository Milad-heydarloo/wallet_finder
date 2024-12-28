import 'package:get/get.dart';
import 'package:flutter/material.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ماشین‌ها',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MachineView(),
    );
  }
}


class MachineView extends StatelessWidget {
  final MachineController controller = Get.put(MachineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ماشین‌ها')),
      body: Obx(() {
        final currentMachine =
        controller.machines[controller.currentMachineIndex.value];
        final currentPartIndex = controller.currentPartIndex.value;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // کارت نام ماشین
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Card(
                  key: ValueKey(currentMachine.name),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      currentMachine.name,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // دایره با اجزای ماشین
              SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(currentMachine.parts.length, (index) {
                    final part = currentMachine.parts[index];
                    final isActive = index <= currentPartIndex;

                    return Transform.rotate(
                      angle: (index / currentMachine.parts.length) * 2 * 3.14,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedOpacity(
                          opacity: isActive ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue,
                                child: Text(
                                  part.name[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              if (isActive)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('${part.price} تومان'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class Machine {
  final String name;
  final List<MachinePart> parts;

  Machine({required this.name, required this.parts});
}

class MachinePart {
  final String name;
  final double price;

  MachinePart({required this.name, required this.price});
}


class MachineController extends GetxController {
  final RxList<Machine> machines = <Machine>[].obs;
  final RxInt currentMachineIndex = 0.obs;
  final RxInt currentPartIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _loadMachines();
    _startAnimation();
  }

  void _loadMachines() {
    machines.addAll([
      Machine(name: 'ماشین ۱', parts: [
        MachinePart(name: 'لاستیک', price: 500),
        MachinePart(name: 'درها', price: 1500),
        MachinePart(name: 'موتور', price: 10000),
        MachinePart(name: 'بدنه', price: 20000),
      ]),
      Machine(name: 'ماشین ۲', parts: [
        MachinePart(name: 'لاستیک', price: 600),
        MachinePart(name: 'درها', price: 1400),
        MachinePart(name: 'موتور', price: 9000),
        MachinePart(name: 'بدنه', price: 18000),
      ]),
    ]);
  }

  void _startAnimation() async {
    while (true) {
      for (int i = 0; i < machines.length; i++) {
        currentMachineIndex.value = i;
        for (int j = 0; j < machines[i].parts.length; j++) {
          currentPartIndex.value = j;
          await Future.delayed(const Duration(seconds: 1));
        }
        await Future.delayed(const Duration(seconds: 2));
        currentPartIndex.value = -1; // حذف تمام آیتم‌های دایره
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }
}
