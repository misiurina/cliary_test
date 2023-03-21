import 'package:flutter/material.dart';

import 'cliary_colors.dart';

class CliaryTextStyle {
  static TextStyle get({
    fontFamily = 'Varela',
    fontSize = 16.0,
    color,
    shadows,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize is int ? fontSize.toDouble() : fontSize,
      color: color ?? CliaryColors.textBlack,
      shadows: shadows,
    );
  }
}