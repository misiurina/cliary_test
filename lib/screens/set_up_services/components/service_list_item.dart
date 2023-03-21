import 'package:calendar_view/calendar_view.dart';
import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/cubit/events_cubit.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_input_decoration.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/screens/service/service_screen.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceListItem extends StatefulWidget {
  const ServiceListItem({
    Key? key,
    required this.service,
  }) : super(key: key);

  final Service service;

  @override
  State<ServiceListItem> createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<ServiceListItem> {
  bool isEditMode = false;
  final focus = FocusNode();
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.service.displayName,
    );
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
      onLongPress: () {
        final cubit = context.read<EditServicesCubit>();
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ServiceScreen(
            cubit: cubit,
            service: widget.service,
          ),
        ));
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: isEditMode ? _buildTextField() : _buildTextLabel(),
                  ),
                  if (widget.service.description != null)
                    _buildAdditionalInfo(widget.service.description!, true),
                ],
              ),
            ),
            isEditMode
                ? _buildDeleteButton()
                : Column(
                    mainAxisAlignment:
                        (widget.service.estimatedDuration != null &&
                                widget.service.estimatedCost != null)
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.service.estimatedDuration != null)
                        _buildAdditionalInfo(
                            '${widget.service.estimatedDuration!} min', false),
                      if (widget.service.estimatedCost != null)
                        _buildAdditionalInfo(
                            '${widget.service.estimatedCost!} PLN', false)
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      focusNode: focus,
      onSubmitted: _submitChange,
      cursorColor: CliaryColors.cliaryMainBlue,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      style: CliaryTextStyle.get(),
      decoration: CliaryInputDecoration.none(
        hintText: 'Nazwa usugi',
      ),
    );
  }

  Widget _buildTextLabel() {
    return Text(
      widget.service.displayName,
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

  Widget _buildDeleteButton() {
    return Container(
      margin: const EdgeInsets.only(right: 7),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: () {
            controller!.text = '';
            context.read<EditServicesCubit>().removeService(widget.service);
            final calendarController = CalendarControllerProvider.of<Event>(context).controller;
            final eventsOnCalendar = calendarController.events;
            final eventsToRemove = eventsOnCalendar.where((element) => element.event!.service.targetId == widget.service.id);
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

  void _submitChange(String value) {
    if (value.isEmpty) return;
    widget.service.displayName = value;
    context.read<EditServicesCubit>().saveService(widget.service);
  }
}
