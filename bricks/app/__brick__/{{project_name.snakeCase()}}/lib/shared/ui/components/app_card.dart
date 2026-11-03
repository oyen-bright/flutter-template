import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Bordered surface for grouped content. Base: `ShadCard`.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.title,
    this.description,
    this.child,
    this.footer,
    this.leading,
    this.trailing,
    this.padding,
    this.onTap,
  });

  final String? title;
  final String? description;
  final Widget? child;
  final Widget? footer;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = ShadCard(
      title: title == null ? null : Text(title!),
      description: description == null ? null : Text(description!),
      footer: footer,
      leading: leading,
      trailing: trailing,
      padding: padding,
      child: child,
    );
    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}
