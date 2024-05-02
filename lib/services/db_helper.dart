import 'package:bluetooth_chat/models.dart/message_model.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // Creating a private constructor
  DbHelper._private();

  static final DbHelper db = DbHelper._private();
  Database? _database;

  initDb() async {
    return await openDatabase(('${await getDatabasesPath()}/data.db'),
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Message("
          "Id INTEGER PRIMARY KEY, "
          "User TEXT, "
          "Message TEXT)");
    });
  }

  Future<Database?> get database async {
    _database ??= await initDb();
    return _database;
  }

  // Retrieves user message from the database
  Future<MessageModel?> getSavedMessage() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      'Message',
      orderBy: "Id ASC",
    );

    if (results.isNotEmpty) {
      return MessageModel.fromJson(results[0]);
    }

    return null;
  }
}
