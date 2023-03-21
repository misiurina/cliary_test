import 'package:flutter/material.dart';

class SeparatedColumn extends StatelessWidget {
  const SeparatedColumn({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          for (var child in children) ...[
            child,
            if (child != children.last) const Divider(
              thickness: 1,
              height: 1,
              indent: 5,
              endIndent: 5,
            ),
          ],
        ],
      ),
    );
  }
}
