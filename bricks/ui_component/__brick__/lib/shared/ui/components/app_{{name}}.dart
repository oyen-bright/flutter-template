import 'package:flutter/material.dart';
{{#has_base}}// ignore: unused_import - remove this ignore once {{base}} is used.
import 'package:shadcn_ui/shadcn_ui.dart';{{/has_base}}

/// Describe in one line what this is for (keep in sync with COMPONENTS.md).
{{#has_base}}/// Base: `{{base}}`. Expose only the params screens need; keep shadcn defaults.{{/has_base}}
///
/// New looks are named constructors (e.g. `App{{name.pascalCase()}}.compact`),
/// never boolean style flags.
class App{{name.pascalCase()}} extends StatelessWidget {
  const App{{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    {{#has_base}}// Implement with {{base}} - read its constructor in the shadcn_ui source
    // (~/.pub-cache/hosted/pub.dev/shadcn_ui-*/lib/src/components/).
    {{/has_base}}return const SizedBox.shrink();
  }
}
