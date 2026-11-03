import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// The single source of brand styling.
///
/// No design: keep the shadcn defaults (only change the base color scheme).
/// Figma design: override scheme colors here (`primary`, `background`, ...)
/// and add brand colors that shadcn has no slot for to `custom`, with a typed
/// getter in [AppCustomColors]. Never hardcode colors or text styles in features.
abstract final class AppTheme {
  static final ShadThemeData light = ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadZincColorScheme.light(
      custom: {'success': Color(0xFF16A34A), 'warning': Color(0xFFD97706)},
    ),
  );

  static final ShadThemeData dark = ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadZincColorScheme.dark(
      custom: {'success': Color(0xFF22C55E), 'warning': Color(0xFFF59E0B)},
    ),
  );
}

/// Typed access to brand colors: `context.colors.success`.
/// Every key added to `custom` above gets a getter here.
extension AppCustomColors on ShadColorScheme {
  Color get success => custom['success'] ?? primary;
  Color get warning => custom['warning'] ?? primary;
}
