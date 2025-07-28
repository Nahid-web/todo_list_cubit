import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../data/models/todo.dart';
import '../cubit/todo_cubit.dart';

class TodoForm extends StatefulWidget {
  final Todo? initialTodo;
  final VoidCallback? onSuccess;

  const TodoForm({
    super.key,
    this.initialTodo,
    this.onSuccess,
  });

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTodo?.title);
    _descriptionController = TextEditingController(
      text: widget.initialTodo?.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      try {
        if (widget.initialTodo != null) {
          // Update existing todo
          await context.read<TodoCubit>().updateTodo(
                widget.initialTodo!.copyWith(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                ),
              );
        } else {
          // Create new todo
          await context.read<TodoCubit>().createTodo(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
              );
        }

        if (mounted) {
          widget.onSuccess?.call();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter todo title',
            ),
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            enabled: !_isSubmitting,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: ThemeConstants.spacing_lg),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Enter todo description',
            ),
            textCapitalization: TextCapitalization.sentences,
            enabled: !_isSubmitting,
            maxLines: 3,
          ),
          const SizedBox(height: ThemeConstants.spacing_xl),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: ThemeConstants.spacing_md,
              ),
            ),
            child: _isSubmitting
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    widget.initialTodo != null ? 'Update Todo' : 'Add Todo',
                  ),
          ),
        ],
      ),
    );
  }
}
