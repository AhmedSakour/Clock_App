import 'package:sqflite/sqflite.dart';

import '../../models/alarm_info_model.dart';

const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnPending = 'isPending';
const String columnColorIndex = 'gradientColorIndex';

class AlarmDatabaseService {
  static Database? _database;
  static AlarmDatabaseService? _alarmDatabaseService;

  AlarmDatabaseService._createInstance();
  factory AlarmDatabaseService() {
    _alarmDatabaseService ??= AlarmDatabaseService._createInstance();
    return _alarmDatabaseService!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "${dir}alarm.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending integer,
          $columnColorIndex integer)
        ''');
      },
    );
    return database;
  }

  void insertAlarm(AlarmInfoModel alarmInfoModel) async {
    var db = await database;
    await db.insert(tableAlarm, alarmInfoModel.toMap());
  }

  Future<List<AlarmInfoModel>> getAlarms() async {
    List<AlarmInfoModel> alarms = [];

    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      var alarmInfoModel = AlarmInfoModel.fromMap(element);
      alarms.add(alarmInfoModel);
    }

    return alarms;
  }

  Future<int> deleteAlarm(int? id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
}
