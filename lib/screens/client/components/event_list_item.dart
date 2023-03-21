import 'package:cliary_test/components/cliary_card.dart';
import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key? key,
    required this.title,
    required this.time,
    this.duration,
    this.cost,
    required this.color
  }) : super(key: key);

  final String title;
  final String time;
  final int? duration;
  final int? cost;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(color - 0x88000000),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: CliaryColors.descriptionTextGray,
            width: 0.5,
          ),
        ),
        child: CliaryInkWell(
          // onTap: () => setState(() {
          //   isEditMode = true;
          //   focus.requestFocus();
          // }),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: _buildTitle(),
                      ),
                      _buildAdditionalInfo(time, true),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment:
                  (duration != null && cost != null)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (duration != null)
                      _buildAdditionalInfo('${duration!} min', false),
                    if (cost != null)
                      _buildAdditionalInfo('${cost!} PLN', false)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: CliaryTextStyle.get(),
    );
  }

  Widget _buildAdditionalInfo(String text, bool isOnLeft) {
    return Padding(
      padding: isOnLeft
          ? const EdgeInsets.fromLTRB(5, 0, 5, 5)
          : const EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Text(
        text,
        style: CliaryTextStyle.get(
          fontSize: 12,
          color: CliaryColors.descriptionTextGray,
        ),
      ),
    );
  }

}
