import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../widgets/todo_form.dart';

class AddTodoView extends StatelessWidget {
  const AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getHorizontalPadding(context),
            vertical: ThemeConstants.spacing_lg,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveUtils.getDialogWidth(context),
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.spacing_lg),
                child: TodoForm(
                  onSuccess: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
