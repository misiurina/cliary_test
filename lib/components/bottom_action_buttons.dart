import 'package:flutter/material.dart';

import 'cliary_elevated_button.dart';

class BottomActionButtons extends StatelessWidget {
  const BottomActionButtons({
    Key? key,
    this.leftButton,
    this.rightButton,
  }) : super(key: key);

  final Widget? leftButton, rightButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 5, 5),
            child: leftButton ?? Container(),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 10, 5),
            child: rightButton ?? Container(),
          ),
        ),
      ],
    );
  }
}
