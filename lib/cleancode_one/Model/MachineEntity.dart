

import 'package:wallet_finder/cleancode_one/Model/Entity.dart';
import 'package:wallet_finder/cleancode_one/Model/ItemEntity.dart';

class MachineEntity extends Entity {
  final String id;
  final String name;
  final String memonic;
  final List<ItemEntity> items;

  MachineEntity({
    required this.id,
    required this.name,
    required this.items,
    required this.memonic,
  });

  // فکتوری برای ساخت ماشین از داده‌های JSON
  factory MachineEntity.fromJson(Map<String, dynamic> json) {
    List<ItemEntity> itemsList = [];

    // تبدیل آیتم‌ها به یک لیست از ItemEntity
    json.forEach((key, value) {
      // بررسی اینکه کلیدهایی مانند 'id', 'collectionName', 'Code', 'collectionId' و موارد مشابه در آیتم‌ها ذخیره نشوند
      if (key != 'collectionName' && // جلوگیری از ذخیره collectionName

          key != 'collectionId' && // جلوگیری از ذخیره collectionId
          key != 'created' &&
          key != 'updated' &&
          key != 'id' &&
          key != 'memonic' &&
          key != 'check') {
        // فقط کلیدهایی که به عنوان آیتم هستند را پردازش می‌کنیم
        itemsList.add(ItemEntity.fromJson(key, value));
      }
    });

    return MachineEntity(
      id: json['id'] ?? '',
      // مقدار پیش‌فرض برای id
      name: json['collectionName'] ?? 'Unknown Machine',
      // مقدار پیش‌فرض برای نام
      memonic: json['memonic'] ?? 'memonic Machine',
      // مقدار پیش‌فرض برای نام
      items: itemsList,
    );
  }
}