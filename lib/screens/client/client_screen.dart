import 'package:calendar_view/calendar_view.dart';
import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/components/cliary_sliver_app_bar.dart';
import 'package:cliary_test/components/confirmation_dialog.dart';
import 'package:cliary_test/components/headed_fragment.dart';
import 'package:cliary_test/components/list_section_header.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_strings.dart';
import 'package:cliary_test/cubit/all_clients_cubit.dart';
import 'package:cliary_test/cubit/client_cubit.dart';
import 'package:cliary_test/screens/add_session/add_session_screen.dart';
import 'package:cliary_test/screens/client/components/client_info.dart';
import 'package:cliary_test/screens/client/components/clients_services_list.dart';
import 'package:cliary_test/screens/client/components/event_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({
    Key? key,
    this.isNew = false,
    this.isInitialSetup = false,
  }) : super(key: key);

  final bool isNew;
  final bool isInitialSetup;

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  TextEditingController? nameController;
  TextEditingController? phoneController;
  Client? client;
  FocusNode nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    client = context.read<ClientPageCubit>().state.client;
    nameController = TextEditingController(
      text: context.read<ClientPageCubit>().state.client.displayName,
    );
    phoneController = TextEditingController(
      text: context.read<ClientPageCubit>().state.client.phoneNumber,
    );
    nameController!.addListener(() => setState(() {}));
    phoneController!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController!.dispose();
    phoneController!.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ClientPageCubit, IClientPageState>(
          builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CliarySliverAppBar(
              title: 'Klient',
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: ClientInfo(
                    name: state.client.displayName!,
                    phoneNumber: state.client.phoneNumber,
                    info: state.client.description,
                    nameController: nameController!,
                    nameFocus: nameFocus,
                    phoneController: phoneController!,
                  ),
                ),
                if (state.favouriteServices.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: HeadedFragment(
                      header: 'Używane usługi:',
                      child: ClientsServicesList(
                        groups: state.groups,
                        favourites: state.favouriteServices,
                        serviceToTimesUsedMap: state.serviceToTimesUsedMap,
                        isGroupUsedMap: state.isGroupUsedMap,
                      ),
                    ),
                  ),
              ]),
            ),
            if (state.futureEvents.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                    child: HeadedFragment(
                        header: 'Zaplanowane wizyty', child: Container())),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i == 0 ||
                      state.futureEvents[i]!.startTime!.day !=
                          state.futureEvents[i - 1]!.startTime!.day) {
                    return Column(
                      children: [
                        ListSectionHeader(
                          text:
                              '${state.futureEvents[i]!.startTime!.day} ${CliaryStrings.monthsGenitive[state.futureEvents[i]!.startTime!.month]}${state.futureEvents[i]!.startTime!.year == DateTime.now().year ? '' : ', ${state.futureEvents[i]!.startTime!.year}'} ',
                        ),
                        EventListItem(
                          title: state
                              .futureEvents[i]!.service.target!.displayName,
                          time:
                              '${state.futureEvents[i]!.startTime!.hour}:${state.futureEvents[i]!.startTime!.minute < 10 ? '0${state.futureEvents[i]!.startTime!.minute}' : '${state.futureEvents[i]!.startTime!.minute}'} - ${state.futureEvents[i]!.endTime!.hour}:${state.futureEvents[i]!.endTime!.minute < 10 ? '0${state.futureEvents[i]!.endTime!.minute}' : '${state.futureEvents[i]!.endTime!.minute}'}',
                          duration: state.futureEvents[i]!.endTime!
                              .difference(state.futureEvents[i]!.startTime!)
                              .inMinutes,
                          cost: state.futureEvents[i]!.cost,
                          color: state.futureEvents[i]!.service.target!.group
                              .target!.color,
                        ),
                      ],
                    );
                  } else {
                    return EventListItem(
                      title: state.futureEvents[i]!.service.target!.displayName,
                      time:
                          '${state.futureEvents[i]!.startTime!.hour}:${state.futureEvents[i]!.startTime!.minute < 10 ? '0${state.futureEvents[i]!.startTime!.minute}' : '${state.futureEvents[i]!.startTime!.minute}'} - ${state.futureEvents[i]!.endTime!.hour}:${state.futureEvents[i]!.endTime!.minute < 10 ? '0${state.futureEvents[i]!.endTime!.minute}' : '${state.futureEvents[i]!.endTime!.minute}'}',
                      duration: state.futureEvents[i]!.endTime!
                          .difference(state.futureEvents[i]!.startTime!)
                          .inMinutes,
                      cost: state.futureEvents[i]!.cost,
                      color: state
                          .futureEvents[i]!.service.target!.group.target!.color,
                    );
                  }
                },
                childCount: state.futureEvents.length,
              ),
            ),
            if (state.pastEvents.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                    child: HeadedFragment(
                        header: 'Poprzednie wizyty', child: Container())),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i == 0 ||
                      state.pastEvents[i]!.startTime!.day !=
                          state.pastEvents[i - 1]!.startTime!.day) {
                    return Column(
                      children: [
                        ListSectionHeader(
                          text:
                              '${state.pastEvents[i]!.startTime!.day} ${CliaryStrings.monthsGenitive[state.pastEvents[i]!.startTime!.month]}${state.pastEvents[i]!.startTime!.year == DateTime.now().year ? '' : ', ${state.pastEvents[i]!.startTime!.year}'} ',
                        ),
                        EventListItem(
                          title:
                              state.pastEvents[i]!.service.target!.displayName,
                          time:
                              '${state.pastEvents[i]!.startTime!.hour}:${state.pastEvents[i]!.startTime!.minute < 10 ? '0${state.pastEvents[i]!.startTime!.minute}' : '${state.pastEvents[i]!.startTime!.minute}'} - ${state.pastEvents[i]!.endTime!.hour}:${state.pastEvents[i]!.endTime!.minute < 10 ? '0${state.pastEvents[i]!.endTime!.minute}' : '${state.pastEvents[i]!.endTime!.minute}'}',
                          duration: state.pastEvents[i]!.endTime!
                              .difference(state.pastEvents[i]!.startTime!)
                              .inMinutes,
                          cost: state.pastEvents[i]!.cost,
                          color: state.pastEvents[i]!.service.target!.group
                              .target!.color,
                        ),
                      ],
                    );
                  } else {
                    return EventListItem(
                      title: state.pastEvents[i]!.service.target!.displayName,
                      time:
                          '${state.pastEvents[i]!.startTime!.hour}:${state.pastEvents[i]!.startTime!.minute < 10 ? '0${state.pastEvents[i]!.startTime!.minute}' : '${state.pastEvents[i]!.startTime!.minute}'} - ${state.pastEvents[i]!.endTime!.hour}:${state.pastEvents[i]!.endTime!.minute < 10 ? '0${state.pastEvents[i]!.endTime!.minute}' : '${state.pastEvents[i]!.endTime!.minute}'}',
                      duration: state.pastEvents[i]!.endTime!
                          .difference(state.pastEvents[i]!.startTime!)
                          .inMinutes,
                      cost: state.pastEvents[i]!.cost,
                      color: state
                          .pastEvents[i]!.service.target!.group.target!.color,
                    );
                  }
                },
                childCount: state.pastEvents.length,
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomActionButtons(
        leftButton: widget.isNew
            ? CliaryElevatedButton(
                label: 'Cofnij',
                reverseColors: true,
                callback: () {
                  final client = context.read<ClientPageCubit>().client;
                  if (client.displayName != null &&
                      client.displayName!.isNotEmpty &&
                      client.phoneNumber.isNotEmpty) {
                    context
                        .read<ClientPageCubit>()
                        .removeClient(context.read<AllClientsPageCubit>());
                  }
                  Navigator.pop(context);
                },
              )
            : CliaryElevatedButton(
                label: 'Usuń',
                reverseColors: true,
                callback: () async {
                  final clientCubit = context.read<ClientPageCubit>();
                  final allClientsCubit = context.read<AllClientsPageCubit>();
                  final calendarController = CalendarControllerProvider.of<Event>(context).controller;
                  await showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      title: 'Czy na pewno chcesz usunąć klienta?',
                      actionText: 'Usuń',
                      action: () {
                        clientCubit.removeClient(allClientsCubit);
                        final eventsOnCalendar = calendarController.events;
                        final eventsToRemove = eventsOnCalendar.where((element) => element.event!.client.targetId == client!.id);
                        for (final event in eventsToRemove) {
                          calendarController.remove(event);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
        rightButton: widget.isNew
            ? BlocBuilder<ClientPageCubit, IClientPageState>(
                builder: (context, state) {
                return CliaryElevatedButton(
                  label: 'Zapisz',
                  isActive: nameController!.text.isNotEmpty &&
                      phoneController!.text.isNotEmpty,
                  callback: () {
                    Navigator.pop(context);
                  },
                );
              })
            : widget.isInitialSetup
                ? CliaryElevatedButton(
                    label: 'Edytuj',
                    callback: () async {
                      FocusScope.of(context).requestFocus(nameFocus);
                      nameFocus.requestFocus();
                    },
                  )
                : CliaryElevatedButton(
                    label: 'Dodaj wydarzenie',
                    callback: () async {
                      List<CalendarEventData<Event>>? eventsToAdd =
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSessionScreen(
                                  initialClient: client,
                                ),
                              ));
                      if (eventsToAdd != null) {
                        EventController<Event> calendarController =
                            CalendarControllerProvider.of<Event>(context)
                                .controller;
                        setState(() {
                          calendarController.addAll(eventsToAdd);
                        });
                      }
                      // FocusScope.of(context).requestFocus(nameFocus);
                      // nameFocus.requestFocus();
                    },
                  ),
      ),
    );
  }
}
