import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:flutter/material.dart';

class CliaryElevatedButton extends StatelessWidget {
  const CliaryElevatedButton({
    Key? key,
    this.callback,
    this.icon,
    required this.label,
    this.reverseColors = false,
    this.isActive = true,
  }) : super(key: key);

  final void Function()? callback;
  final Icon? icon;
  final String label;
  final bool reverseColors;
  final bool isActive;

  final Color primaryColor = const Color(0xFF1565C0);
  final Color onPrimaryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return (icon != null)
    ? ElevatedButton.icon(
      onPressed: callback ?? () {},
      style: ElevatedButton.styleFrom(
          primary: reverseColors ? onPrimaryColor : primaryColor,
          onPrimary: reverseColors ? primaryColor : onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )
      ),
      icon: icon!,
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Varela',
        ),
      ),
    )
    : ElevatedButton(
      onPressed: isActive ? (callback ?? () {}) : () {},
      style: isActive
        ? ElevatedButton.styleFrom(
          primary: reverseColors ? onPrimaryColor : primaryColor,
          onPrimary: reverseColors ? primaryColor : onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        )
        : ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: CliaryColors.descriptionTextGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Varela',
        ),
      ),
    );
  }
}