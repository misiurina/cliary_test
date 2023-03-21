import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/components/cliary_scroll_view.dart';
import 'package:cliary_test/components/cliary_sliver_app_bar.dart';
import 'package:cliary_test/components/headed_fragment.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_input_decoration.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({
    Key? key,
    required this.cubit,
    required this.service,
  }) : super(key: key);

  final EditServicesCubit cubit;
  final Service service;

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool isNameEditMode = false;
  bool isDescriptionEditMode = false;
  final nameFocus = FocusNode();
  final descriptionFocus = FocusNode();
  TextEditingController? nameController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.service.displayName,
    );
    descriptionController = TextEditingController(
      text: widget.service.description,
    );
    nameFocus.addListener(() => setState(() {
          isNameEditMode = nameFocus.hasFocus;
        }));
    descriptionFocus.addListener(() => setState(() {
          isDescriptionEditMode = descriptionFocus.hasFocus;
        }));
  }

  @override
  void dispose() {
    nameController!.dispose();
    descriptionController!.dispose();
    nameFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const CliarySliverAppBar(
            title: 'Usługa',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            _buildNameField(),
                            _buildDescriptionField(),
                            const Padding(padding: EdgeInsets.only(bottom: 40)),
                            _buildEstimatedDurationPicker(),
                            const Padding(padding: EdgeInsets.only(bottom: 40)),
                            _buildEstimatedPricePicker(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // if (state.futureEvents.isNotEmpty)
          //   SliverToBoxAdapter(
          //     child: Padding(
          //         padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          //         child: HeadedFragment(
          //             header: 'Zaplanowane wizyty', child: Container())),
          //   ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //         (context, i) {
          //       if (i == 0 ||
          //           state.futureEvents[i]!.startTime!.day !=
          //               state.futureEvents[i - 1]!.startTime!.day) {
          //         return Column(
          //           children: [
          //             ListSectionHeader(
          //               text:
          //               '${state.futureEvents[i]!.startTime!.day} ${CliaryStrings.monthsGenitive[state.futureEvents[i]!.startTime!.month]}${state.futureEvents[i]!.startTime!.year == DateTime.now().year ? '' : ', ${state.futureEvents[i]!.startTime!.year}'} ',
          //             ),
          //             EventListItem(
          //               title: state
          //                   .futureEvents[i]!.service.target!.displayName,
          //               time:
          //               '${state.futureEvents[i]!.startTime!.hour}:${state.futureEvents[i]!.startTime!.minute < 10 ? '0${state.futureEvents[i]!.startTime!.minute}' : '${state.futureEvents[i]!.startTime!.minute}'} - ${state.futureEvents[i]!.endTime!.hour}:${state.futureEvents[i]!.endTime!.minute < 10 ? '0${state.futureEvents[i]!.endTime!.minute}' : '${state.futureEvents[i]!.endTime!.minute}'}',
          //               duration: state.futureEvents[i]!.endTime!
          //                   .difference(state.futureEvents[i]!.startTime!)
          //                   .inMinutes,
          //               cost: state.futureEvents[i]!.cost,
          //               color: state.futureEvents[i]!.service.target!.group
          //                   .target!.color,
          //             ),
          //           ],
          //         );
          //       } else {
          //         return EventListItem(
          //           title: state.futureEvents[i]!.service.target!.displayName,
          //           time:
          //           '${state.futureEvents[i]!.startTime!.hour}:${state.futureEvents[i]!.startTime!.minute < 10 ? '0${state.futureEvents[i]!.startTime!.minute}' : '${state.futureEvents[i]!.startTime!.minute}'} - ${state.futureEvents[i]!.endTime!.hour}:${state.futureEvents[i]!.endTime!.minute < 10 ? '0${state.futureEvents[i]!.endTime!.minute}' : '${state.futureEvents[i]!.endTime!.minute}'}',
          //           duration: state.futureEvents[i]!.endTime!
          //               .difference(state.futureEvents[i]!.startTime!)
          //               .inMinutes,
          //           cost: state.futureEvents[i]!.cost,
          //           color: state
          //               .futureEvents[i]!.service.target!.group.target!.color,
          //         );
          //       }
          //     },
          //     childCount: state.futureEvents.length,
          //   ),
          // ),
          // if (state.pastEvents.isNotEmpty)
          //   SliverToBoxAdapter(
          //     child: Padding(
          //         padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          //         child: HeadedFragment(
          //             header: 'Poprzednie wizyty', child: Container())),
          //   ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //         (context, i) {
          //       if (i == 0 ||
          //           state.pastEvents[i]!.startTime!.day !=
          //               state.pastEvents[i - 1]!.startTime!.day) {
          //         return Column(
          //           children: [
          //             ListSectionHeader(
          //               text:
          //               '${state.pastEvents[i]!.startTime!.day} ${CliaryStrings.monthsGenitive[state.pastEvents[i]!.startTime!.month]}${state.pastEvents[i]!.startTime!.year == DateTime.now().year ? '' : ', ${state.pastEvents[i]!.startTime!.year}'} ',
          //             ),
          //             EventListItem(
          //               title:
          //               state.pastEvents[i]!.service.target!.displayName,
          //               time:
          //               '${state.pastEvents[i]!.startTime!.hour}:${state.pastEvents[i]!.startTime!.minute < 10 ? '0${state.pastEvents[i]!.startTime!.minute}' : '${state.pastEvents[i]!.startTime!.minute}'} - ${state.pastEvents[i]!.endTime!.hour}:${state.pastEvents[i]!.endTime!.minute < 10 ? '0${state.pastEvents[i]!.endTime!.minute}' : '${state.pastEvents[i]!.endTime!.minute}'}',
          //               duration: state.pastEvents[i]!.endTime!
          //                   .difference(state.pastEvents[i]!.startTime!)
          //                   .inMinutes,
          //               cost: state.pastEvents[i]!.cost,
          //               color: state.pastEvents[i]!.service.target!.group
          //                   .target!.color,
          //             ),
          //           ],
          //         );
          //       } else {
          //         return EventListItem(
          //           title: state.pastEvents[i]!.service.target!.displayName,
          //           time:
          //           '${state.pastEvents[i]!.startTime!.hour}:${state.pastEvents[i]!.startTime!.minute < 10 ? '0${state.pastEvents[i]!.startTime!.minute}' : '${state.pastEvents[i]!.startTime!.minute}'} - ${state.pastEvents[i]!.endTime!.hour}:${state.pastEvents[i]!.endTime!.minute < 10 ? '0${state.pastEvents[i]!.endTime!.minute}' : '${state.pastEvents[i]!.endTime!.minute}'}',
          //           duration: state.pastEvents[i]!.endTime!
          //               .difference(state.pastEvents[i]!.startTime!)
          //               .inMinutes,
          //           cost: state.pastEvents[i]!.cost,
          //           color: state
          //               .pastEvents[i]!.service.target!.group.target!.color,
          //         );
          //       }
          //     },
          //     childCount: state.pastEvents.length,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return ConstrainedBox(
      constraints: const BoxConstraints(),
      child: isNameEditMode
          ? TextField(
              controller: nameController,
              focusNode: nameFocus,
              onSubmitted: _submitName,
              cursorColor: const Color(0xFF1565C0),
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              style: CliaryTextStyle.get(fontSize: 22),
              decoration: CliaryInputDecoration.none(hintText: 'Nazwa usługi'),
            )
          : CliaryInkWell(
              onTap: () => setState(() {
                isNameEditMode = true;
                nameFocus.requestFocus();
              }),
              child: Text(
                widget.service.displayName,
                textAlign: TextAlign.center,
                style: CliaryTextStyle.get(fontSize: 22),
              ),
            ),
    );
  }

  Widget _buildDescriptionField() {
    return ConstrainedBox(
      constraints: const BoxConstraints(),
      child: isDescriptionEditMode
          ? TextField(
              controller: descriptionController,
              focusNode: descriptionFocus,
              onSubmitted: _submitDescription,
              cursorColor: const Color(0xFF1565C0),
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              style:
                  CliaryTextStyle.get(color: CliaryColors.descriptionTextGray),
              decoration: CliaryInputDecoration.none(hintText: 'Dodaj opis'),
            )
          : CliaryInkWell(
              onTap: () => setState(() {
                isDescriptionEditMode = true;
                descriptionFocus.requestFocus();
              }),
              child: Text(
                widget.service.description == null
                    ? 'Dodaj opis'
                    : widget.service.description!,
                textAlign: TextAlign.center,
                style: CliaryTextStyle.get(
                    color: CliaryColors.descriptionTextGray),
              ),
            ),
    );
  }

  Widget _buildEstimatedDurationPicker() {
    return HeadedFragment(
      header: 'Szacowany czas trwania',
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            Center(
              child: NumberPicker(
                value: widget.service.estimatedDuration ?? 0,
                minValue: 0,
                maxValue: 300,
                step: 5,
                itemHeight: 30,
                itemWidth: 80,
                haptics: true,
                axis: Axis.horizontal,
                textStyle: CliaryTextStyle.get(
                  color: CliaryColors.descriptionTextGray.withOpacity(0.5),
                ),
                selectedTextStyle: CliaryTextStyle.get(
                  fontSize: 20,
                  color: CliaryColors.cliaryMainBlue,
                ),
                onChanged: (value) => setState(() {
                  widget.service.estimatedDuration = value != 0 ? value : null;
                  widget.cubit.saveService(widget.service);
                }),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CliaryColors.descriptionTextGray),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Text(
                'min',
                textAlign: TextAlign.end,
                style: CliaryTextStyle.get(
                  color: CliaryColors.cliaryMainBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatedPricePicker() {
    return HeadedFragment(
      header: 'Szacowany koszt',
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            Center(
              child: NumberPicker(
                value: widget.service.estimatedCost ?? 0,
                minValue: 0,
                maxValue: 10000,
                step: 5,
                itemHeight: 30,
                itemWidth: 80,
                haptics: true,
                axis: Axis.horizontal,
                textStyle: CliaryTextStyle.get(
                  color: CliaryColors.descriptionTextGray.withOpacity(0.5),
                ),
                selectedTextStyle: CliaryTextStyle.get(
                  fontSize: 20,
                  color: CliaryColors.cliaryMainBlue,
                ),
                onChanged: (value) => setState(() {
                  widget.service.estimatedCost = value != 0 ? value : null;
                  widget.cubit.saveService(widget.service);
                }),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CliaryColors.descriptionTextGray),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Text(
                'PLN',
                textAlign: TextAlign.end,
                style: CliaryTextStyle.get(
                  color: CliaryColors.cliaryMainBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitName(String value) {
    if (value.isEmpty) return;
    widget.service.displayName = value;
    widget.cubit.saveService(widget.service);
  }

  void _submitDescription(String value) {
    if (value.isEmpty) return;
    widget.service.description = value;
    widget.cubit.saveService(widget.service);
  }
}
