import 'package:flutter/material.dart';

import 'cliary_card.dart';

class HeadedCardList extends StatelessWidget {
  const HeadedCardList({
    Key? key,
    required this.header,
    required this.items,
  }) : super(key: key);

  final Widget header;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return CliaryCard(
      child: IntrinsicHeight(
        child: Column(
          children: [
            header,
            for (var item in items) ...[
              item,
              if (item != items.last) const Divider(
                thickness: 1,
                height: 1,
                indent: 5,
                endIndent: 5,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
