import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Transient feedback. Call from a `BlocListener`, never from a bloc/cubit.
abstract final class AppToast {
  static void success(BuildContext context, String message) {
    ShadToaster.of(context).show(ShadToast(title: Text(message)));
  }

  static void error(BuildContext context, String message) {
    ShadToaster.of(context).show(ShadToast.destructive(title: Text(message)));
  }
}
