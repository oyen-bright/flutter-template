/// The ONLY UI import features use: `import '.../shared/ui/ui.dart';`
///
/// Features must not import `package:shadcn_ui` directly. If a shadcn
/// component is not wrapped yet, run
/// `mason make ui_component --name <name> --base <ShadWidget>` first.
library;

export 'package:gap/gap.dart';
export 'package:shadcn_ui/shadcn_ui.dart' show LucideIcons, ShadApp, ShadForm, ShadFormState;

export 'components/app_button.dart';
export 'components/app_card.dart';
export 'components/app_scaffold.dart';
export 'components/app_state_views.dart';
export 'components/app_text_field.dart';
export 'components/app_toast.dart';
// [ui-exports] - `mason make ui_component` inserts exports above this line.
export 'theme/app_theme.dart';
export 'theme/app_tokens.dart';
