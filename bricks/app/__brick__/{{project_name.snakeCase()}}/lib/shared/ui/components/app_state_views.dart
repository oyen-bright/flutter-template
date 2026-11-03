import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:{{project_name.snakeCase()}}/shared/ui/components/app_button.dart';
import 'package:{{project_name.snakeCase()}}/shared/ui/theme/app_tokens.dart';

/// Loading placeholder for lists. Use instead of a centered spinner.
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const Gap(AppSpacing.sm),
        itemBuilder: (_, _) => const ListTile(
          leading: Bone.circle(size: 40),
          title: Bone.text(words: 3),
          subtitle: Bone.text(words: 5),
        ),
      ),
    );
  }
}

/// Wraps real content in a skeleton while [loading] is true.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({required this.loading, required this.child, super.key});

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Skeletonizer(enabled: loading, child: child);
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({required this.message, super.key, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? LucideIcons.inbox, size: 40, color: context.colors.mutedForeground),
          const Gap(AppSpacing.md),
          Text(message, style: context.text.muted, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, super.key, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.circleAlert, size: 40, color: context.colors.destructive),
          const Gap(AppSpacing.md),
          Text(message, style: context.text.muted, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const Gap(AppSpacing.lg),
            AppButton.outline(label: 'Try again', onPressed: onRetry),
          ],
        ],
      ),
    );
  }
}
