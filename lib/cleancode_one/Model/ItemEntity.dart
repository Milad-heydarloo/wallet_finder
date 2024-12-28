

import 'package:wallet_finder/cleancode_one/Model/Entity.dart';

class ItemEntity extends Entity {
  final String name;
  final String code;
  double? price; // قیمت آیتم
  String? color; // رنگ آیتم

  ItemEntity({
    required this.name,
    required this.code,
    this.price,
    this.color,
  });

  // فکتوری برای ساخت آیتم از داده‌های JSON
  factory ItemEntity.fromJson(String name, dynamic value) {
    return ItemEntity(
      name: name, // نام آیتم که از کلید گرفته می‌شود
      code: value.toString(), // مقدار کد که از داده‌های API گرفته می‌شود
    );
  }
}

