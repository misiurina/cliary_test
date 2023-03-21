import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_input_decoration.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddServiceListItem extends StatefulWidget {
  const AddServiceListItem({
    Key? key,
    required this.group,
    this.isEditMode = false,
  }) : super(key: key);

  final ServiceGroup group;
  final bool isEditMode;

  @override
  State<AddServiceListItem> createState() => _AddServiceListItemState();
}

class _AddServiceListItemState extends State<AddServiceListItem> {
  bool? isEditMode;
  final focus = FocusNode();
  final controller = TextEditingController();

  @override
  void initState() {
    isEditMode = widget.isEditMode;
    super.initState();
    focus.addListener(() {
      setState(() {
        isEditMode = focus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CliaryInkWell(
      onTap: () => setState(() {
        isEditMode = true;
        focus.requestFocus();
      }),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Icon(
              Icons.add,
              color: Color(0x99000000),
              size: 20,
            ),
            isEditMode!
                ? Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focus,
                      autofocus: widget.isEditMode,
                      onSubmitted: _submitField,
                      cursorColor: CliaryColors.cliaryMainBlue,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      style: CliaryTextStyle.get(),
                      decoration: CliaryInputDecoration.none(
                        hintText: 'Dodaj usługę',
                      ),
                    ),
                  )
                : controller.text.isEmpty
                    ? Text(
                        'Dodaj usługę',
                        style: CliaryTextStyle.get(
                          color: CliaryColors.descriptionTextGray,
                        ),
                      )
                    : Text(
                        controller.text,
                        style: CliaryTextStyle.get(),
                      ),
          ],
        ),
      ),
    );
  }

  void _submitField(String value) {
    if (value.isEmpty) return;
    context.read<EditServicesCubit>().addService(widget.group, value);
  }
}
