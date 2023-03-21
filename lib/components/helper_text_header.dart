import 'package:flutter/material.dart';

class HelperTextHeader extends StatelessWidget {
  const HelperTextHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Varela',
          color: Color(0x99000000),
          fontSize: 15,
        ),
      ),
    );
  }
}
