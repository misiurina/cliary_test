import 'package:flutter/material.dart';

class CliaryCard extends StatelessWidget {
  const CliaryCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(
          color: Color(0xFFCCCCCC),
          width: 0.5,
        ),
      ),
      elevation: 3,
      child: child,
    );
  }
}
