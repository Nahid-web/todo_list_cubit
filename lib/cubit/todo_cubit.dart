import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_cubit/models/todo_model.dart';

class TodoCubit extends Cubit<List<TodoModel>> {
  TodoCubit() : super([]);

  void addTodo(String title) {
    if (title.isEmpty) {
      addError('Title cannot be empty!');
      return;
    }
    final todo = TodoModel(
      name: title,
      createdAt: DateTime.now(),
    );

    emit([...state, todo]);
  }

  @override
  void onChange(Change<List<TodoModel>> change) {
    super.onChange(change);
    print('TodoCubit - $change');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print('TodoCubit - $error');
  }
}
