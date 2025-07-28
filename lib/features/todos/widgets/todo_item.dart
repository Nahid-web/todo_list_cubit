import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../data/models/todo.dart';
import '../cubit/todo_cubit.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, y HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacing_md,
        vertical: ThemeConstants.spacing_sm,
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implement edit todo navigation
        },
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.spacing_md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      todo.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      todo.isCompleted
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: todo.isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {
                      context.read<TodoCubit>().toggleTodoStatus(todo.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                  ),
                ],
              ),
              if (todo.description != null && todo.description!.isNotEmpty) ...[
                const SizedBox(height: ThemeConstants.spacing_sm),
                Text(
                  todo.description!,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: ThemeConstants.spacing_md),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: ThemeConstants.spacing_xs),
                  Text(
                    'Created: ${dateFormat.format(todo.createdAt)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  if (todo.completedAt != null) ...[
                    const SizedBox(width: ThemeConstants.spacing_md),
                    Icon(
                      Icons.done_all,
                      size: 16,
                      color: theme.colorScheme.primary.withOpacity(0.6),
                    ),
                    const SizedBox(width: ThemeConstants.spacing_xs),
                    Text(
                      'Completed: ${dateFormat.format(todo.completedAt!)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'DELETE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (context.mounted) {
        context.read<TodoCubit>().deleteTodo(todo.id);
      }
    }
  }
}
