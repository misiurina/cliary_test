import 'package:flutter/material.dart';

class CliaryInkWell extends StatelessWidget {
  const CliaryInkWell({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.child,
  }) : super(key: key);

  final void Function()? onTap;
  final void Function()? onLongPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        onLongPress: onLongPress ?? () {},
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: child,
      ),
    );
  }
}
