import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteService {
  final _sqlite = databaseFactoryFfi;
  

  Future<String> _getDatabasePath() async {
    try {
      Directory directory;

      if (Platform.isLinux) {
        String? homeDir = Platform.environment['HOME'];
        if (homeDir != null) {
          directory = Directory('$homeDir/ai_chat_client');
        } else {
          directory = await getApplicationSupportDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      return '${directory.path}/data.db';
    } catch (e) {
      print('Error getting database path: $e');
      return 'todo_app.db';
    }
  }

  Future<void> init() async {
    var db = await _sqlite.openDatabase(await _getDatabasePath());
    await db.execute('''
  CREATE TABLE IF NOT EXISTS chat_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES users (id)
  )
  ''');
    await db.execute('''
  CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      username TEXT,
      password TEXT
  )
  ''');
    await db.execute('''
  CREATE TABLE IF NOT EXISTS messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT,
      is_user_message BOOLEAN,
      chat_history_id INTEGER,
      FOREIGN KEY (chat_history_id) REFERENCES chat_history (id)
  )
  ''');
  db.close();
  }

  Future<void> addNewUser(String name, String username, String password) async {
    var db = await _sqlite.openDatabase(await _getDatabasePath());
      await db.insert('users', {
        'name': name,
        'username': username,
        'password': password,
      });
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    var db = await _sqlite.openDatabase(await _getDatabasePath());
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (results.isNotEmpty) {
          db.close();

      return results.first;
    }
    db.close();
    return null;
  }

  Future<void> storeMessage(int chatHistoryId, String content, bool isUserMessage) async {
    var db = await _sqlite.openDatabase(await _getDatabasePath());
    await db.insert('messages', {
      'content': content,
      'is_user_message': isUserMessage ? 1 : 0,
      'chat_history_id': chatHistoryId,
    });
  }

   Future<List<Map<String, dynamic>>> getMessagesForChatHistory(int chatHistoryId) async {
    var db = await _sqlite.openDatabase(await _getDatabasePath());
    return await db.query(
      'messages',
      where: 'chat_history_id = ?',
      whereArgs: [chatHistoryId],
    );
  }

  Future<List<Map<String, dynamic>>> getChatHistoriesForUser(int userId) async {
    var db = await _sqlite.openDatabase(await _getDatabasePath());
    return await db.query(
      'chat_history',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> createChatHistory(String title, int userId) async {
    var db = await _sqlite.openDatabase(await _getDatabasePath());
    await db.insert('chat_history', {
      'title': title,
      'user_id': userId,
    });
  }
}
