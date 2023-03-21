import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    Key? key,
    required this.title,
    this.text,
    this.actionText = 'Zatwierdź',
    required this.action,
  }) : super(key: key);

  final String title;
  final String? text;
  final String actionText;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      titleTextStyle: CliaryTextStyle.get(
        fontSize: 20,
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      content: text != null
          ? Text(
            text!,
            style: CliaryTextStyle.get(),
          )
          : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cofnij',
            style: CliaryTextStyle.get(
              color: CliaryColors.descriptionTextGray,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            action();
            Navigator.pop(context);
          },
          child: Text(
            actionText,
            style: CliaryTextStyle.get(
              color: CliaryColors.cliaryMainBlue,
            ),
          ),
        ),
      ],
    );
  }
}
