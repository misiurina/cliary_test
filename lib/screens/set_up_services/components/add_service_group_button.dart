import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AddServiceGroupButton extends StatelessWidget {
  const AddServiceGroupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 3,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () => context.read<EditServicesCubit>().addGroup(),
          style: TextButton.styleFrom(
            primary: const Color(0xFF1565C0),
            padding: const EdgeInsets.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(10),
              ),
            )
          ),
          child: Text(
            'Dodaj grupę',
            style: CliaryTextStyle.get(
              fontSize: 18,
              color: CliaryColors.cliaryMainBlue,
            ),
          ),
        ),
      ),
    );
  }
}
