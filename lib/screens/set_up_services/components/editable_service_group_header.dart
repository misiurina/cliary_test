import 'package:calendar_view/calendar_view.dart';
import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/cubit/events_cubit.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_input_decoration.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditableServiceGroupHeader extends StatefulWidget {
  const EditableServiceGroupHeader({
    Key? key,
    required this.group,
    this.isEditMode = false,
  }) : super(key: key);

  final ServiceGroup group;
  final bool isEditMode;

  @override
  State<EditableServiceGroupHeader> createState() => _EditableServiceGroupHeaderState();
}

class _EditableServiceGroupHeaderState extends State<EditableServiceGroupHeader> {
  bool? isEditMode;
  final focus = FocusNode();
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.isEditMode;
    controller = TextEditingController(text: widget.group.displayName,);
    focus.addListener(() {
      if (!focus.hasFocus) _submitChange(controller!.text);
      setState(() {
        isEditMode = focus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    controller!.dispose();
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
        decoration: BoxDecoration(
          color: Color(widget.group.color - 0x88000000),
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
                      child: isEditMode! ? _buildTextField() : _buildTextLabel(),
                    ),
                  ),
                  isEditMode! ? _buildDeleteButton() : _buildColorPickerButton(),
                ],
              ),
              const Divider(
                thickness: 1,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      focusNode: focus,
      autofocus: controller!.text.isEmpty && widget.group.services.isEmpty,
      onSubmitted: _submitChange,
      cursorColor: CliaryColors.cliaryMainBlue,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      style: CliaryTextStyle.get(
        fontSize: 18.0,
        shadows: [
          const Shadow(
            color: Colors.white,
            blurRadius: 20,
          ),
        ],
      ),
      decoration: CliaryInputDecoration.none(
        hintText: 'Nazwa grupy',
      ),
    );
  }

  Widget _buildTextLabel() {
    return Text(
      widget.group.displayName,
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

  Widget _buildDeleteButton() {
    return Container(
      margin: const EdgeInsets.only(right: 7),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: () {
            controller!.text = '';
            context.read<EditServicesCubit>().removeGroup(widget.group);
            final calendarController = CalendarControllerProvider.of<Event>(context).controller;
            final eventsOnCalendar = calendarController.events;
            final eventsToRemove = eventsOnCalendar.where((element) => element.event!.service.target!.group.targetId == widget.group.id);
            for (final event in eventsToRemove) {
              calendarController.remove(event);
            }
          },
          highlightColor: Colors.transparent,
          child: const SizedBox(
            width: 25,
            height: 25,
            child: Icon(
              Icons.delete,
              size: 20,
              color: CliaryColors.descriptionTextGray,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPickerButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF555555),
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Color(widget.group.color),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final color = await _showColorPicker(context);
            if (color != null) {
              widget.group.color = color.value;
              context.read<EditServicesCubit>().saveGroupColor(widget.group);
            }
          },
          highlightColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  Future<Color?> _showColorPicker(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wybierz nowy kolor'),
        titleTextStyle: CliaryTextStyle.get(
          fontSize: 20,
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        content: BlockPicker(
          pickerColor: Color(widget.group.color),
          availableColors: [
            for (final color in CliaryColors.pastelColors) Color(color),
          ],
          onColorChanged: (color) {
            Navigator.of(context).pop(color);
          },
        ),
      ),
    );
  }

  void _submitChange(String value) {
    widget.group.displayName = value;
    context.read<EditServicesCubit>().saveGroup(widget.group);
  }
}
