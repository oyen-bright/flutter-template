import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Every single-line or multi-line text input. Base: `ShadInputFormField`.
/// Use inside a `ShadForm`/`Form` for validation.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.placeholder,
    this.description,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.leading,
    this.trailing,
  });

  /// Password field preset.
  const AppTextField.password({
    super.key,
    this.label = 'Password',
    this.placeholder,
    this.description,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.enabled = true,
    this.leading,
    this.trailing,
  }) : obscureText = true,
       keyboardType = TextInputType.visiblePassword,
       maxLines = 1;

  final String? label;
  final String? placeholder;
  final String? description;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ShadInputFormField(
      label: label == null ? null : Text(label!),
      placeholder: placeholder == null ? null : Text(placeholder!),
      description: description == null ? null : Text(description!),
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      leading: leading,
      trailing: trailing,
    );
  }
}
