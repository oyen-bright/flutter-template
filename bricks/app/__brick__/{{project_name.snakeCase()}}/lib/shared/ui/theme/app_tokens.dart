import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Spacing scale. Use with `Gap(AppSpacing.md)` or `EdgeInsets.all(...)`.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: lg);
}

abstract final class AppRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 16;
  static const double pill = 999;
}

/// Theme access for widgets: `context.colors.primary`, `context.text.h3`.
extension AppThemeContext on BuildContext {
  ShadThemeData get appTheme => ShadTheme.of(this);
  ShadColorScheme get colors => ShadTheme.of(this).colorScheme;
  ShadTextTheme get text => ShadTheme.of(this).textTheme;
}
