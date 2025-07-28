import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../features/todos/views/add_todo_view.dart';
import '../features/todos/views/todo_list_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.homeRoute,
    debugLogDiagnostics: true,
    routes: [
      // Home route (Todo List)
      GoRoute(
        path: AppConstants.homeRoute,
        builder: (context, state) => const TodoListView(),
      ),

      // Add Todo route
      GoRoute(
        path: AppConstants.addTodoRoute,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AddTodoView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),

      // Edit Todo route
      GoRoute(
        path: '${AppConstants.editTodoRoute}/:id',
        builder: (context, state) {
          final todoId = state.pathParameters['id']!;
          // TODO: Implement edit todo view with todoId
          return const TodoListView();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.error}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    ),
  );
}
