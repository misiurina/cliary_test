import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class CountServiceListItem extends StatelessWidget {
  const CountServiceListItem({
    Key? key,
    required this.service,
    required this.count,
    this.isSelected = false,
  }) : super(key: key);

  final Service service;
  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? CliaryColors.cliaryMainBlue : Colors.transparent
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: _buildTextLabel(),
            ),
          ),
          if (count != 0) _buildTimesCount(),
        ],
      ),
    );
  }

  Widget _buildTextLabel() {
    return Text(
      service.displayName,
      style: CliaryTextStyle.get(
        color: isSelected ? Colors.white : CliaryColors.textBlack,
      ),
    );
  }

  Widget _buildTimesCount() {
    final sCount = count.toString();
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Text(
        '$count raz${sCount.lastIndexOf('1') == sCount.length - 1 ? '' : 'y'}',
        style: CliaryTextStyle.get(
          fontSize: 12,
          color: isSelected ? Colors.white.withOpacity(0.8) : CliaryColors.descriptionTextGray,
        ),
      ),
    );
  }
}
