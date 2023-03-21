import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class ListSectionHeader extends StatelessWidget {
  const ListSectionHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(19.5, 0, 30, 0),
      height: 40,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            text,
            style: CliaryTextStyle.get(
              color: CliaryColors.cliaryMainBlue,
            ),
          ),
          const Expanded(
              child: Divider(
                height: 0,
                indent: 10,
              ))
        ],
      ),
    );
  }
}
