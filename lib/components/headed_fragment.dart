import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class HeadedFragment extends StatelessWidget {
  const HeadedFragment({
    Key? key,
    required this.header,
    required this.child,
    this.isCentered = false,
  }) : super(key: key);

  final String header;
  final Widget child;
  final bool isCentered;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity,),
          child: Text(
            header,
            textAlign:TextAlign.start,
            style: CliaryTextStyle.get(
              fontSize: 20,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
