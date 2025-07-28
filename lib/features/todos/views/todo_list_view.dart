import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../data/models/todo.dart';
import '../cubit/todo_cubit.dart';
import '../widgets/todo_item.dart';
import 'add_todo_view.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // TODO: Implement theme toggle
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<TodoCubit>().syncWithRemote();
            },
          ),
        ],
      ),
      body: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodosLoaded) {
            return _ResponsiveTodoList(todos: state.todos);
          }

          return const Center(child: Text('No todos found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ResponsiveTodoList extends StatelessWidget {
  final List<Todo> todos;

  const _ResponsiveTodoList({required this.todos});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtils.isDesktop(context)) {
          return _buildDesktopLayout(context);
        } else if (ResponsiveUtils.isTablet(context)) {
          return _buildTabletLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: ThemeConstants.spacing_md.h,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) => TodoItem(todo: todos[index]),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(ThemeConstants.spacing_md.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: ThemeConstants.spacing_md.w,
        mainAxisSpacing: ThemeConstants.spacing_md.h,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) => TodoItem(todo: todos[index]),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getContentMaxWidth(context),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(ThemeConstants.spacing_lg.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.3,
            crossAxisSpacing: ThemeConstants.spacing_lg.w,
            mainAxisSpacing: ThemeConstants.spacing_lg.h,
          ),
          itemCount: todos.length,
          itemBuilder: (context, index) => TodoItem(todo: todos[index]),
        ),
      ),
    );
  }
}
