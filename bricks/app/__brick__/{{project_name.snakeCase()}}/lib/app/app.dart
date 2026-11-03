import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/shared/ui/ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      title: '{{project_name.titleCase()}}',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
