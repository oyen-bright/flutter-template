import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Every tappable button in the app. Base: `ShadButton`.
///
/// Add a new look as a named constructor here - never style a button inline
/// in a feature.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : _variant = ShadButtonVariant.primary;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : _variant = ShadButtonVariant.secondary;

  const AppButton.outline({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : _variant = ShadButtonVariant.outline;

  const AppButton.ghost({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : _variant = ShadButtonVariant.ghost;

  const AppButton.destructive({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : _variant = ShadButtonVariant.destructive;

  const AppButton.link({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : _variant = ShadButtonVariant.link;

  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Shows a spinner and blocks taps. Drive it from bloc/cubit state.
  final bool isLoading;

  /// Fill the available width (typical for primary CTAs).
  final bool expand;
  final ShadButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    return ShadButton.raw(
      variant: _variant,
      width: expand ? double.infinity : null,
      onPressed: isLoading ? null : onPressed,
      leading: isLoading
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : (icon == null ? null : Icon(icon, size: 16)),
      child: Text(label),
    );
  }
}
