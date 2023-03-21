import 'dart:math';

import 'package:flutter/material.dart';

class CliaryColors {
  static const List<int> pastelColors = [
    0xFF97C1A9,
    0xFFB7CFB7,
    0xFFCCE2CB,
    0xFFEAEAEA,
    0xFFC7DBDA,
    0xFFFFE1E9,
    0xFFFDD7C2,
    0xFFF6EAC2,
    0xFFFFB8B1,
    0xFFFFDAC1,
    0xFFE2F0CB,
    0xFFB5EAD6,
    0xFF55CBCD,
    0xFFA3E1DC,
    0xFFEDEAE5,
    0xFFFFDBCC,
    0xFF9AB7D3,
    0xFFF5D2D3,
    0xFFF7E1D3,
    0xFFDFCCF1
  ];

  static const cliaryMainBlue = Color(0xFF1565C0);
  static const cliaryMainDarkBlue = Color(0xFF104D90);

  static const textBlack = Color(0xFF333333);
  static const descriptionTextGray = Color(0x99000000);

  static int getRandomPastelColor() {
    final length = CliaryColors.pastelColors.length;
    return CliaryColors.pastelColors[Random().nextInt(length)];
  }
}
