{{^is_bloc}}import 'dart:async';

{{/is_bloc}}import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{package}}/app/di/injection.dart';
import 'package:{{package}}/features/{{name}}/presentation/{{type}}/{{name}}_{{type}}.dart';
import 'package:{{package}}/shared/ui/ui.dart';

class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
{{#is_bloc}}      create: (_) => getIt<{{name.pascalCase()}}Bloc>()..add(const {{name.pascalCase()}}Requested()),
{{/is_bloc}}{{^is_bloc}}      create: (_) {
        final cubit = getIt<{{name.pascalCase()}}Cubit>();
        unawaited(cubit.load());
        return cubit;
      },
{{/is_bloc}}      child: const _{{name.pascalCase()}}View(),
    );
  }
}

class _{{name.pascalCase()}}View extends StatelessWidget {
  const _{{name.pascalCase()}}View();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '{{name.titleCase()}}',
      body: BlocBuilder<{{name.pascalCase()}}{{type.pascalCase()}}, {{name.pascalCase()}}State>(
        builder: (context, state) => switch (state) {
          {{name.pascalCase()}}Initial() || {{name.pascalCase()}}Loading() => const AppSkeletonList(),
          {{name.pascalCase()}}Failure(:final failure) => AppErrorView(
            message: failure.message,
            onRetry: () => context.read<{{name.pascalCase()}}{{type.pascalCase()}}>(){{#is_bloc}}.add(const {{name.pascalCase()}}Requested()){{/is_bloc}}{{^is_bloc}}.load(){{/is_bloc}},
          ),
          {{name.pascalCase()}}Loaded(:final items) when items.isEmpty => const AppEmptyView(
            message: 'Nothing here yet.',
          ),
          {{name.pascalCase()}}Loaded(:final items) => ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Gap(AppSpacing.sm),
            itemBuilder: (context, index) => AppCard(title: items[index].name),
          ),
        },
      ),
    );
  }
}
