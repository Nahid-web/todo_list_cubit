import 'dart:async';

import 'package:uuid/uuid.dart';

import '../datasources/local/hive_storage.dart';
import '../datasources/remote/supabase_client.dart';
import '../models/todo.dart';

class TodoRepository {
  final _uuid = const Uuid();
  StreamController<List<Todo>>? _todoStreamController;

  // Singleton instance
  static final TodoRepository _instance = TodoRepository._internal();
  factory TodoRepository() => _instance;
  TodoRepository._internal();

  // Stream of todos for real-time updates
  Stream<List<Todo>> get todoStream {
    _todoStreamController ??= StreamController<List<Todo>>.broadcast();
    return _todoStreamController!.stream;
  }

  // CRUD Operations with sync
  Future<Todo> createTodo({
    required String title,
    String? description,
  }) async {
    final todo = Todo.create(
      id: _uuid.v4(),
      title: title,
      description: description,
    );

    // Save locally first
    await HiveStorage.saveTodo(todo);
    _notifyListeners();

    try {
      // Then sync with remote
      final remoteTodo = await SupabaseClientHelper.createTodo(todo);
      await HiveStorage.updateTodo(
          remoteTodo); // Update local with remote changes
      _notifyListeners();
      return remoteTodo;
    } catch (e) {
      // Keep local changes if remote fails
      return todo;
    }
  }

  Future<Todo?> getTodo(String id) async {
    return HiveStorage.getTodo(id);
  }

  Future<List<Todo>> getAllTodos() async {
    return HiveStorage.getAllTodos();
  }

  Future<Todo> updateTodo(Todo todo) async {
    // Update locally first
    await HiveStorage.updateTodo(todo);
    _notifyListeners();

    try {
      // Then sync with remote
      final remoteTodo = await SupabaseClientHelper.updateTodo(todo);
      await HiveStorage.updateTodo(remoteTodo);
      _notifyListeners();
      return remoteTodo;
    } catch (e) {
      // Keep local changes if remote fails
      return todo;
    }
  }

  Future<void> deleteTodo(String id) async {
    // Delete locally first
    await HiveStorage.deleteTodo(id);
    _notifyListeners();

    try {
      // Then sync with remote
      await SupabaseClientHelper.deleteTodo(id);
    } catch (_) {
      // Ignore remote deletion failures
    }
  }

  Future<void> toggleTodoStatus(String id) async {
    final todo = await getTodo(id);
    if (todo != null) {
      final updatedTodo =
          todo.isCompleted ? todo.markIncomplete() : todo.markComplete();
      await updateTodo(updatedTodo);
    }
  }

  // Sync operations
  Future<void> syncWithRemote() async {
    try {
      final remoteTodos = await SupabaseClientHelper.getAllTodos();
      final localTodos = HiveStorage.getAllTodos();

      // Update local storage with remote changes
      for (final remoteTodo in remoteTodos) {
        final localTodo = HiveStorage.getTodo(remoteTodo.id);
        if (localTodo == null ||
            remoteTodo.createdAt.isAfter(localTodo.createdAt)) {
          await HiveStorage.saveTodo(remoteTodo);
        }
      }

      // Push local changes to remote
      final localOnlyTodos = localTodos.where(
        (local) => !remoteTodos.any((remote) => remote.id == local.id),
      );
      if (localOnlyTodos.isNotEmpty) {
        await SupabaseClientHelper.batchCreateTodos(localOnlyTodos.toList());
      }

      await SupabaseClientHelper.updateLastSyncTimestamp();
      _notifyListeners();
    } catch (e) {
      // Handle sync errors
      print('Sync failed: $e');
    }
  }

  // Setup real-time updates
  void setupRealtimeSync() {
    SupabaseClientHelper.todoStream().listen((remoteTodos) async {
      // Update local storage with remote changes
      for (final todo in remoteTodos) {
        await HiveStorage.saveTodo(todo);
      }
      _notifyListeners();
    });
  }

  // Notify listeners of changes
  void _notifyListeners() {
    if (_todoStreamController?.hasListener ?? false) {
      _todoStreamController?.add(HiveStorage.getAllTodos());
    }
  }

  // Cleanup
  void dispose() {
    _todoStreamController?.close();
    _todoStreamController = null;
  }
}
