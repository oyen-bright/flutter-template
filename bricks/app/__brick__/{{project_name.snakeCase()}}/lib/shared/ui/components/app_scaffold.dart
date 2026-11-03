import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/shared/ui/theme/app_tokens.dart';

/// Root widget of every page. Owns background, safe area and page padding.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.bottomBar,
    this.floatingAction,
    this.padded = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;

  /// Sticky bottom area, e.g. a primary `AppButton`.
  final Widget? bottomBar;
  final Widget? floatingAction;

  /// Applies [AppSpacing.page] horizontal padding to [body].
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!, style: context.text.large),
              backgroundColor: colors.background,
              foregroundColor: colors.foreground,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              actions: actions,
            ),
      floatingActionButton: floatingAction,
      body: SafeArea(
        child: padded ? Padding(padding: AppSpacing.page, child: body) : body,
      ),
      bottomNavigationBar: bottomBar == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: bottomBar,
              ),
            ),
    );
  }
}
