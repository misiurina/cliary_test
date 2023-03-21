import 'package:flutter/material.dart';

class CliaryInputDecoration {
  static InputDecoration none({hintText}) {
    return InputDecoration(
      isDense: true,
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      hintText: hintText,
    );
  }
}