import 'package:flutter/material.dart';

class CliarySliverAppBar extends StatelessWidget {
  const CliarySliverAppBar({
    Key? key,
    this.leading,
    required this.title,
    this.actions,
  }) : super(key: key);

  final Widget? leading;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF1565C0),
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Varela',
          fontSize: 30,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
      ),
      actions: actions,
    );
  }
}
