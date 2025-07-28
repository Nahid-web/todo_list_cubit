import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/todo.dart';
import '../../../data/repositories/todo_repository.dart';

// States
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;
  final String? searchQuery;
  final bool isOffline;

  const TodosLoaded({
    required this.todos,
    this.searchQuery,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [todos, searchQuery, isOffline];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repository;
  StreamSubscription? _todosSubscription;
  String? _currentSearchQuery;

  TodoCubit({TodoRepository? repository})
      : _repository = repository ?? TodoRepository(),
        super(TodoInitial()) {
    _initialize();
  }

  void _initialize() {
    emit(TodoLoading());
    _setupTodoSubscription();
    _repository.syncWithRemote().catchError((e) {
      emit(TodoError('Failed to sync: $e'));
    });
    _repository.setupRealtimeSync();
  }

  void _setupTodoSubscription() {
    _todosSubscription?.cancel();
    _todosSubscription = _repository.todoStream.listen(
      (todos) {
        if (state is TodoError) return; // Don't update if in error state
        _updateTodosList(todos);
      },
      onError: (error) {
        emit(TodoError('Stream error: $error'));
      },
    );
  }

  void _updateTodosList(List<Todo> todos) {
    if (_currentSearchQuery?.isNotEmpty ?? false) {
      final filteredTodos = _filterTodos(todos, _currentSearchQuery!);
      emit(TodosLoaded(
        todos: filteredTodos,
        searchQuery: _currentSearchQuery,
      ));
    } else {
      emit(TodosLoaded(todos: todos));
    }
  }

  List<Todo> _filterTodos(List<Todo> todos, String query) {
    final lowercaseQuery = query.toLowerCase();
    return todos.where((todo) {
      return todo.title.toLowerCase().contains(lowercaseQuery) ||
          (todo.description?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Public methods
  Future<void> createTodo({
    required String title,
    String? description,
  }) async {
    try {
      await _repository.createTodo(
        title: title,
        description: description,
      );
    } catch (e) {
      emit(TodoError('Failed to create todo: $e'));
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _repository.updateTodo(todo);
    } catch (e) {
      emit(TodoError('Failed to update todo: $e'));
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _repository.deleteTodo(id);
    } catch (e) {
      emit(TodoError('Failed to delete todo: $e'));
    }
  }

  Future<void> toggleTodoStatus(String id) async {
    try {
      await _repository.toggleTodoStatus(id);
    } catch (e) {
      emit(TodoError('Failed to toggle todo status: $e'));
    }
  }

  Future<void> searchTodos(String query) async {
    _currentSearchQuery = query;
    if (state is TodosLoaded) {
      final todos = (state as TodosLoaded).todos;
      final filteredTodos = _filterTodos(todos, query);
      emit(TodosLoaded(
        todos: filteredTodos,
        searchQuery: query,
      ));
    }
  }

  Future<void> clearSearch() async {
    _currentSearchQuery = null;
    if (state is TodosLoaded) {
      final todos = await _repository.getAllTodos();
      emit(TodosLoaded(todos: todos));
    }
  }

  Future<void> syncWithRemote() async {
    try {
      emit(TodoLoading());
      await _repository.syncWithRemote();
    } catch (e) {
      emit(TodoError('Failed to sync: $e'));
    }
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    _repository.dispose();
    return super.close();
  }
}
