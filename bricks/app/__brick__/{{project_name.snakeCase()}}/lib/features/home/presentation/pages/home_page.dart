import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/shared/ui/ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '{{project_name.titleCase()}}',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(AppSpacing.xl),
          Text('Welcome', style: context.text.h2),
          const Gap(AppSpacing.sm),
          Text(
            'Generate your first feature with `make feature NAME=... TYPE=cubit`.',
            style: context.text.muted,
          ),
        ],
      ),
    );
  }
}
