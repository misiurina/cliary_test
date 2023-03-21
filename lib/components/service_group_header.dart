import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class ServiceGroupHeader extends StatelessWidget {
  const ServiceGroupHeader({
    Key? key,
    required this.text,
    required this.color,
    this.icon,
  }) : super(key: key);

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(color.value - 0x88000000),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: _buildTextLabel(),
                  ),
                ),
                if (icon != null) _buildIcon(),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabel() {
    return Text(
      text,
      style: CliaryTextStyle.get(
        fontSize: 18.0,
        shadows: [
          const Shadow(
            color: Colors.white,
            blurRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 7),
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 25,
          height: 25,
          child: Icon(
            icon,
            size: 20,
            color: CliaryColors.textBlack,
          ),
        ),
      ),
    );
  }
}
