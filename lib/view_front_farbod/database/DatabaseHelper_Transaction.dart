import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:wallet_finder/view_front_farbod/model/model_balance_record.dart';


class DatabaseHelper_Wallet {
  static final DatabaseHelper_Wallet _instance = DatabaseHelper_Wallet._internal();
  static Database? _database;

  DatabaseHelper_Wallet._internal();

  factory DatabaseHelper_Wallet() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'transactions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          bnb TEXT,
          btc_n TEXT,
          btc_o TEXT,
          busd TEXT,
          eth TEXT,
          memonic TEXT,
          trx TEXT,
          usdt TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertTransactions(List<BalanceRecord> transactions) async {
    final db = await database;
    for (var transaction in transactions) {
      await db.insert(
        'transactions',
        transaction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  Future<void> delete(String id) async{
    final db = await database;
    db.delete('transactions',
      where: 'id = ?',
      whereArgs: [id],);
  }

  Future<List<BalanceRecord>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List<BalanceRecord>.from(
      maps.map((map) => BalanceRecord.fromJson(map)),
    );
  }




}
