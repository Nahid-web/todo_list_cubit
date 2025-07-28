import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../models/todo.dart';

class SupabaseClientHelper {
  static SupabaseClient get _client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  // CRUD Operations
  static Future<List<Todo>> getAllTodos() async {
    try {
      final response = await _client
          .from('todos')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((todo) => Todo.fromMap(todo as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  static Future<Todo> createTodo(Todo todo) async {
    try {
      final response =
          await _client.from('todos').insert(todo.toMap()).select();
      return Todo.fromMap(response.first as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create todo: $e');
    }
  }

  static Future<Todo> updateTodo(Todo todo) async {
    try {
      final response = await _client
          .from('todos')
          .update(todo.toMap())
          .eq('id', todo.id)
          .select();
      return Todo.fromMap(response.first as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  static Future<void> deleteTodo(String id) async {
    try {
      await _client.from('todos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  // Realtime subscription for todos
  static Stream<List<Todo>> todoStream() {
    return _client.from('todos').stream(primaryKey: ['id']).map((list) => list
        .map((item) => Todo.fromMap(item as Map<String, dynamic>))
        .toList());
  }

  // Batch operations for sync
  static Future<void> batchCreateTodos(List<Todo> todos) async {
    if (todos.isEmpty) return;

    try {
      await _client.from('todos').insert(
            todos.map((todo) => todo.toMap()).toList(),
          );
    } catch (e) {
      throw Exception('Failed to batch create todos: $e');
    }
  }

  static Future<void> batchUpdateTodos(List<Todo> todos) async {
    if (todos.isEmpty) return;

    try {
      await Future.wait(
        todos.map((todo) =>
            _client.from('todos').update(todo.toMap()).eq('id', todo.id)),
      );
    } catch (e) {
      throw Exception('Failed to batch update todos: $e');
    }
  }

  // Sync helpers
  static Future<DateTime> getLastSyncTimestamp() async {
    try {
      final response =
          await _client.from('sync_info').select('last_sync').single();
      return DateTime.parse(response['last_sync'] as String);
    } catch (e) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  static Future<void> updateLastSyncTimestamp() async {
    final now = DateTime.now().toUtc().toIso8601String();
    try {
      await _client.from('sync_info').upsert({'id': 1, 'last_sync': now});
    } catch (e) {
      throw Exception('Failed to update sync timestamp: $e');
    }
  }
}
