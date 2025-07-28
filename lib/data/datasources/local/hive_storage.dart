import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../models/todo.dart';

class HiveStorage {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(TodoAdapter());

    // Open boxes
    await Hive.openBox(AppConstants.settingsBox);
    await Hive.openBox<Todo>(AppConstants.todosBox);
  }

  // Todos operations
  static Box<Todo> get todosBox => Hive.box<Todo>(AppConstants.todosBox);

  static Future<void> saveTodo(Todo todo) async {
    await todosBox.put(todo.id, todo);
  }

  static Future<void> deleteTodo(String id) async {
    await todosBox.delete(id);
  }

  static Future<void> updateTodo(Todo todo) async {
    await todosBox.put(todo.id, todo);
  }

  static Todo? getTodo(String id) {
    return todosBox.get(id);
  }

  static List<Todo> getAllTodos() {
    return todosBox.values.toList();
  }

  // Settings operations
  static Box get settingsBox => Hive.box(AppConstants.settingsBox);

  static Future<void> saveThemeMode(bool isDark) async {
    await settingsBox.put(AppConstants.themeKey, isDark);
  }

  static bool getThemeMode() {
    return settingsBox.get(AppConstants.themeKey, defaultValue: false);
  }

  // Clear all data
  static Future<void> clearAll() async {
    await todosBox.clear();
    await settingsBox.clear();
  }
}
