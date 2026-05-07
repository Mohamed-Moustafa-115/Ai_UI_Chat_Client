import 'package:ai_chat_client/app.dart';
import 'package:ai_chat_client/services/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit(); // ← only here, never inside the service

  await SqliteService().init();
  
  runApp(const AiChatClient());
}
