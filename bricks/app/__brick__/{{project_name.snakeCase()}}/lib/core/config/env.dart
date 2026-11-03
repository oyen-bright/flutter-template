/// Compile-time configuration. Pass values with
/// `flutter run --dart-define-from-file=env/dev.json`.
abstract final class Env {
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
}
