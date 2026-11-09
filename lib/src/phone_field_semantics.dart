import 'package:flutter/material.dart';

/// Will talk back the following:
/// "Editbox, Phone number, detected text: +1 650 555 1234", ...
/// It will not give access to the country selection button, as the
/// user can just type the full phone number inside the text field
class PhoneFieldSemantics extends StatelessWidget {
  final Widget child;
  final bool hasFocus;
  final bool enabled;
  final InputDecoration inputDecoration;

  const PhoneFieldSemantics({
    super.key,
    required this.child,
    required this.hasFocus,
    required this.enabled,
    required this.inputDecoration,
  });

  // The inner TextField already exposes its label (from the decoration) and its value to
  // assistive tech. Wrapping it in ExcludeSemantics hid the real editable node, so on Flutter
  // web with semantics enabled typing and paste never reached the field.
  @override
  Widget build(BuildContext context) => child;
}
