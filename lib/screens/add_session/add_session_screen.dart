import 'dart:math';

import 'package:azlistview/azlistview.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cliary_test/components/az_clients_list.dart';
import 'package:cliary_test/components/cliary_card.dart';
import 'package:cliary_test/components/cliary_day_view.dart';
import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/components/cliary_sliver_app_bar.dart';
import 'package:cliary_test/components/headed_fragment.dart';
import 'package:cliary_test/components/search_bar.dart';
import 'package:cliary_test/components/service_group_header.dart';
import 'package:cliary_test/cubit/all_clients_cubit.dart';
import 'package:cliary_test/cubit/client_cubit.dart';
import 'package:cliary_test/cubit/events_cubit.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/select_services_list.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({
    Key? key,
    this.initialDay,
    this.initialClient,
    this.eventToEdit,
    this.calendarController,
  }) : super(key: key);

  final DateTime? initialDay;
  final Client? initialClient;
  final Event? eventToEdit;
  final EventController<Event>? calendarController;

  @override
  _AddSessionScreenState createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  TextEditingController textEditingController = TextEditingController(text: '');
  final GlobalKey<DayViewState> dayViewState = GlobalKey();
  FocusNode searchFocus = FocusNode();
  bool isEditMode = true;
  List<Client?>? clients;
  List<AZClientData>? azClients;
  List<AZClientData>? clientsToDisplay;
  Client? chosenClient;
  IClientPageState? clientState;
  List<ServiceGroup?>? groups;
  List<Service?> allServices = [];
  List<Service?> favourites = [];
  Map<Service, int> serviceToTimesUsedMap = {};
  Map<Service, bool> selectedServicesMap = {};
  Map<Service, int> serviceToDurationMap = {};
  Map<Service, int> serviceToCostMap = {};
  List<Event> eventsToAdd = [];
  List<CalendarEventData<Event>> eventsOnCalendar = [];
  DateTime? selectedDate;
  int? selectedTime;
  bool isOverwrittenByUser = false;
  ScrollController scrollController = ScrollController();
  CalendarEventData<Event>? cachedEvent;
  Client? cachedClient;
  int? cachedCost;


  @override
  void initState() {
    clients = context.read<AllClientsPageCubit>().state.clients;
    azClients = [
      for (final client in clients!)
        AZClientData(
          displayName: client!.displayName!,
          phoneNumber: client.phoneNumber,
          photo: client.photo,
        )
    ];
    SuspensionUtil.sortListBySuspensionTag(azClients);
    SuspensionUtil.setShowSuspensionStatus(azClients);
    clientsToDisplay = List.from(azClients!);
    searchFocus.addListener(() => setState(() {
          isEditMode = searchFocus.hasFocus;
        }));
    groups = context.read<EditServicesCubit>().state.groups;
    for (final group in groups!) {
      for (final service in group!.services) {
        allServices.add(service);
        selectedServicesMap[service] = false;
        serviceToDurationMap[service] = service.estimatedDuration ?? 30;
        serviceToCostMap[service] = service.estimatedCost ?? 0;
      }
    }

    selectedDate = widget.initialDay ?? _getInitialDate();
    final now = DateTime.now();
    selectedTime = selectedDate!.difference(now).inDays == 0
        ? max(8 * 60, now.hour * 60 + now.minute)
        : 8 * 60;

    chosenClient = widget.initialClient;
    if (widget.eventToEdit != null) {
      final eventToEditOnCalendar = widget.calendarController!.events.firstWhere((element) => element.event!.id == widget.eventToEdit!.id);
      cachedEvent = CalendarEventData<Event>(
        date: _fromDateTime(widget.eventToEdit!.startTime!),
        event: widget.eventToEdit,
        title: widget.eventToEdit!.client.target!.displayName!,
        description: eventToEditOnCalendar.description,
        startTime: _fromDateTime(widget.eventToEdit!.startTime!),
        endTime: _fromDateTime(widget.eventToEdit!.endTime!),
        color: eventToEditOnCalendar.color,
      );
      cachedClient = context.read<AllClientsPageCubit>().state.clients.firstWhere((element) => element!.id == widget.eventToEdit!.client.target!.id);
      cachedCost = widget.eventToEdit!.cost;
      widget.calendarController!.remove(eventToEditOnCalendar);
      chosenClient = widget.eventToEdit!.client.target!;
      eventsToAdd.add(widget.eventToEdit!);
      final startTime = widget.eventToEdit!.startTime!;
      int startTimeInMinutes = startTime.hour * 60 + startTime.minute;
      if (startTimeInMinutes % 5 != 0) {
        startTimeInMinutes = startTimeInMinutes + (5 - startTimeInMinutes % 5);
      }
      selectedTime = startTimeInMinutes;
      isOverwrittenByUser = true;
      final service = widget.eventToEdit!.service.target!;
      allServices.add(service);
      selectedServicesMap[service] = true;
      serviceToDurationMap[service] = widget.eventToEdit!.endTime!.difference(widget.eventToEdit!.startTime!).inMinutes;
      serviceToCostMap[service] = widget.eventToEdit!.cost ?? 0;
      _updateEventsOnDayView();
    }
    if (widget.initialClient != null || widget.eventToEdit != null) {
      isEditMode = false;
    }

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _removeCurrentlyEditedFlags();
        if (widget.eventToEdit != null) {
          widget.eventToEdit!.startTime = cachedEvent!.startTime;
          widget.eventToEdit!.endTime = cachedEvent!.endTime;
          widget.eventToEdit!.client.target = cachedClient;
          widget.eventToEdit!.cost = cachedCost;
          widget.calendarController!.remove(eventsOnCalendar.first);
          widget.calendarController!.add(cachedEvent!);
        }
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: isEditMode ? null : _buildBottomActionButtons(),
        appBar: isEditMode || chosenClient == null ? _buildAppBar() : null,
        body: isEditMode ? _buildClientPicker() : _buildAddSessionView(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: CliaryColors.cliaryMainBlue,
      foregroundColor: Colors.white,
      leading: _buildBackButton(),
      title: Text(
        'Wybierz klienta',
        style: TextStyle(
          fontFamily: 'Varela',
          fontSize: 30,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContainer() {
    return CliaryInkWell(
      onTap: () => setState(() {
        isEditMode = true;
      }),
      child: Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE1E2E6),
            width: 1,
          ),
          color: const Color(0xFFEFF0F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: chosenClient == null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CliaryInkWell(
                    onTap: () => setState(() {
                      isEditMode = true;
                    }),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: CliaryColors.textBlack,
                      ),
                    ),
                  ),
                  Text(
                    'Wyszukaj klienta',
                    style: CliaryTextStyle.get(
                      color: CliaryColors.descriptionTextGray,
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  chosenClient!.displayName!,
                  style: CliaryTextStyle.get(
                    fontSize: 24,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      controller: textEditingController,
      callback: _filter,
      focus: searchFocus,
      autofocus: false,
      onIconTap: () {
        setState(() {
          isEditMode = false;
        });
      },
      icon: Icons.arrow_back,
      hint: 'Wyszukaj klienta',
    );
  }

  Widget _buildClientPicker() {
    return SafeArea(
      child: Column(
        children: [
          _buildSearchBar(),
          AZClientsList(
            clientsToDisplay: clientsToDisplay!,
            itemScrollController: ItemScrollController(),
            itemClickedCallback: _clientsListItemClickedCallback,
          ),
        ],
      ),
    );
  }

  Widget _buildAddSessionView() {
    if (chosenClient != null) {
      clientState =
          ClientPageCubit(chosenClient!, context.read<DatabaseController>())
              .state;
      Map<Service, Service> userServicesToAllServicesMap = {};
      favourites = [];
      for (final group in clientState!.groups) {
        for (final service in group!.services) {
          userServicesToAllServicesMap[service] =
              allServices.firstWhere((element) => element!.id == service.id)!;
          serviceToTimesUsedMap[userServicesToAllServicesMap[service]!] =
              clientState!.serviceToTimesUsedMap[service]!;
        }
      }
      for (final service in clientState!.favouriteServices) {
        favourites.add(userServicesToAllServicesMap[service]);
      }

      if (dayViewState.currentState != null &&
          dayViewState.currentState!.currentDate
                  .difference(selectedDate!)
                  .inDays == 0) {
        dayViewState.currentState!.animateToDate(selectedDate!);
      }

      return NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, isInnerScrolled) {
          return [
            CliarySliverAppBar(
              title: 'Dodaj wydarzenie',
              leading: _buildBackButton(),
            ),
            SliverToBoxAdapter(child: _buildSearchContainer()),
            if (widget.eventToEdit == null) _buildServicesPicker(),
            _buildChosenServicesSettings(),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: CliaryCard(
            child: CliaryDayView(
              header: eventsToAdd.isNotEmpty ? _buildStartTimePicker() : null,
              width: MediaQuery.of(context).size.width - 30,
              startFromToday: true,
              initialDay: selectedDate,
              initialOffset: selectedTime! ~/ 60,
              onPageChange: (date, page) {
                selectedDate = date;

                final now = DateTime.now();
                final isToday = selectedDate!.day == now.day && selectedDate!.month == now.month && selectedDate!.year == now.year;
                int minutesNow = now.hour * 60 + now.minute;
                if (minutesNow % 5 != 0) {
                  minutesNow = minutesNow + (5 - minutesNow % 5);
                }
                if (eventsToAdd.isNotEmpty && !(isOverwrittenByUser && !(isToday && selectedTime! < minutesNow))) {
                  final calculatedStartTime = _calculateBestStartTimeForTheDay(eventsToAdd.first, selectedDate!);
                  final calculatedStartTimeInMinutes = calculatedStartTime.hour * 60 + calculatedStartTime.minute;
                  setState(() {
                    selectedDate = date;
                    selectedTime = isOverwrittenByUser ? minutesNow : calculatedStartTimeInMinutes;
                  });
                }
                _updateEventsOnDayView();
              },
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          _buildSearchContainer(),
          Expanded(
            child: Center(
              child: Text(
                'Najpierw wybierz klienta',
                style: CliaryTextStyle.get(),
              ),
            ),
          ),
        ],
      );
    }
  }

  _buildServicesPicker() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: HeadedFragment(
          header: 'Wybierz usługi:',
          child: SelectServicesList(
            groups: groups!,
            favourites: favourites,
            serviceToTimesUsedMap: serviceToTimesUsedMap,
            selectedItemsMap: selectedServicesMap,
            itemClickedCallback: _toggleService,
          ),
        ),
      ),
    );
  }

  _buildChosenServicesSettings() {
    bool isAnyServiceChosen = false;
    for (final service in allServices) {
      if (widget.eventToEdit != null || selectedServicesMap[service] == true) {
        isAnyServiceChosen = true;
      }
    }
    if (!isAnyServiceChosen) {
      return SliverToBoxAdapter(child: Container());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: HeadedFragment(
          header: widget.eventToEdit != null ? 'Wybrana usługa:' : 'Wybrane usługi:',
          child: Column(
            children: widget.eventToEdit != null
            ? [_buildServiceSettingsCard(widget.eventToEdit!.service.target!)]
            : [
              for (final service in allServices)
                if (selectedServicesMap[service] == true)
                  _buildServiceSettingsCard(service!),
            ],
          ),
        ),
      ),
    );
  }

  _buildServiceSettingsCard(Service service) {
    return CliaryCard(
      child: Column(
        children: [
          ServiceGroupHeader(
            text: service.displayName,
            color: Color(service.group.target!.color),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: _buildServiceTimeAndCostPicker(service),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTimeAndCostPicker(Service service) {
    return Column(
      children: [
        HeadedFragment(
          header: 'Czas trwania:',
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Stack(
              children: [
                Center(
                  child: NumberPicker(
                    value: min(
                        serviceToDurationMap[service]!,
                        min(
                            300,
                            (22 - 8) * 60 -
                                (_calculateTotalDurationInMinutes() -
                                    serviceToDurationMap[service]! +
                                    20))),
                    minValue: 15,
                    maxValue: min(
                        300,
                        (22 - 8) * 60 -
                            (_calculateTotalDurationInMinutes() -
                                serviceToDurationMap[service]! +
                                20)),
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
                      if (eventsToAdd.isNotEmpty &&
                          eventsToAdd.last.endTime!.isAfter(DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                              23,
                              50))) {
                        return;
                      }
                      serviceToDurationMap[service] = value;
                      _updateEventsOnDayView();
                    }),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: CliaryColors.descriptionTextGray),
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
        ),
        const SizedBox(
          height: 25,
        ),
        HeadedFragment(
          header: 'Koszt:',
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Stack(
              children: [
                Center(
                  child: NumberPicker(
                    value: serviceToCostMap[service]!,
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
                      serviceToCostMap[service] = value;
                      _updateEventsOnDayView();
                    }),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: CliaryColors.descriptionTextGray),
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
        ),
      ],
    );
  }

  Widget _buildStartTimePicker() {
    bool isAnyServiceChosen = false;
    for (final service in allServices) {
      if (selectedServicesMap[service] == true) {
        isAnyServiceChosen = true;
      }
    }
    if (!isAnyServiceChosen) {
      return Container();
    }
    final now = DateTime.now();
    final isToday = selectedDate!.day == now.day &&
        selectedDate!.month == now.month &&
        selectedDate!.year == now.year;
    int minutesNow = now.hour * 60 + now.minute;
    if (minutesNow % 5 != 0) {
      minutesNow = minutesNow + (5 - minutesNow % 5);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: HeadedFragment(
        header: 'Wybierz czas rozpoczęcia:',
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: NumberPicker(
              value: selectedTime!,
              minValue: isToday ? minutesNow : 0,
              maxValue: 1440 - 10 - _calculateTotalDurationInMinutes(),
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
                selectedTime = value;
                if (eventsToAdd.isNotEmpty) {
                  final time = _calculateBestStartTimeForTheDay(
                      eventsToAdd.first, selectedDate!);
                  final calculatedBestTime = time.hour * 60 + time.minute;
                  isOverwrittenByUser = selectedTime != calculatedBestTime;
                } else {
                  isOverwrittenByUser = false;
                }
                _updateEventsOnDayView();
              }),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CliaryColors.descriptionTextGray),
              ),
              textMapper: (number) {
                final hours = int.parse(number) ~/ 60;
                final minutes = int.parse(number) % 60;
                return '$hours : ${minutes < 10 ? '0$minutes' : minutes}';
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return BottomActionButtons(
      leftButton: widget.eventToEdit != null
        ? CliaryElevatedButton(
          label: 'Usuń',
          reverseColors: true,
          callback: () {
            context.read<AllEventsCubit>().removeEvent(widget.eventToEdit!);
            _cleanUpCalendar();
            Navigator.pop(context);
          },
        )
        : CliaryElevatedButton(
          label: 'Cofnij',
          reverseColors: true,
          callback: () {
            _cleanUpCalendar();
            Navigator.pop(context);
          },
        ),
      rightButton: CliaryElevatedButton(
        label: 'Zapisz',
        isActive: eventsToAdd.isNotEmpty,
        callback: () {
          for (final event in eventsToAdd) {
            context.read<AllEventsCubit>().saveEvent(event);
          }
          _removeCurrentlyEditedFlags();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _filter(String value) {
    if (value.isEmpty) {
      setState(() {
        clientsToDisplay = List.from(azClients!);
      });
      return;
    }
    setState(() {
      clientsToDisplay = [
        for (final client in azClients!)
          if (_clientContains(client, value)) client
      ];
    });
  }

  bool _clientContains(AZClientData client, String value) {
    if (value.length < 3) {
      return client.displayName.toUpperCase().startsWith(value.toUpperCase()) ||
          client.phoneNumber.toUpperCase().startsWith(value.toUpperCase());
    } else {
      return client.displayName.toUpperCase().contains(value.toUpperCase()) ||
          client.phoneNumber.toUpperCase().contains(value.toUpperCase());
    }
  }

  void _clientsListItemClickedCallback(AZClientData azClient) {
    setState(() {
      isEditMode = false;
      chosenClient = context
          .read<AllClientsPageCubit>()
          .state
          .clients
          .firstWhere(
              (element) => element!.phoneNumber == azClient.phoneNumber);
      for (Event event in eventsToAdd) {
        event.client.target = chosenClient;
      }
      _updateEventsOnDayView();
    });
  }

  void _toggleService(Service service) {
    if (selectedServicesMap[service] == false &&
        _calculateTotalDurationInMinutes() >=
            (22 - 8) * 60 - 20 - (serviceToDurationMap[service] ?? 30)) return;
    setState(() {
      selectedServicesMap[service] = !selectedServicesMap[service]!;
      if (selectedServicesMap[service] == true) {
        final eventToAdd = Event(
          startTime: DateTime.now(),
          endTime: DateTime.now()
              .add(Duration(minutes: serviceToDurationMap[service]!)),
        );
        eventToAdd.client.target = chosenClient;
        eventToAdd.service.target = service;
        eventsToAdd.add(eventToAdd);
      } else if (selectedServicesMap[service] == false &&
          eventsToAdd
              .any((element) => element.service.target!.id == service.id)) {
        eventsToAdd.remove(eventsToAdd
            .firstWhere((element) => element.service.target!.id == service.id));
      }
      _updateEventsOnDayView();
    });
  }

  DateTime _getInitialDate() {
    if (widget.eventToEdit != null) return widget.eventToEdit!.startTime!;

    final initialDate = DateTime.now();
    if (initialDate.weekday == 6) {
      return initialDate.add(const Duration(days: 2));
    }
    if (initialDate.weekday == 7) {
      return initialDate.add(const Duration(days: 1));
    }
    return initialDate;
  }

  DateTime _calculateBestStartTimeForTheDay(Event event, DateTime day) {
    final setEvents = context.read<AllEventsCubit>().state.events;
    final now = DateTime.now();
    final startOfTheDay = DateTime(
      day.year,
      day.month,
      day.day,
      day.day == now.day ? max(8, now.hour + 1) : 8,
      day.day == now.day && now.hour + 1 >= 8
          ? (now.minute + now.minute % 10 == 0 ? 0 : (10 - now.minute % 10))
          : 0,
    );
    final endOfTheDay = DateTime(
      day.year,
      day.month,
      day.day,
      22,
    );
    int totalDurationInMinutes = _calculateTotalDurationInMinutes();
    // if (totalDurationInMinutes != 0) {
    totalDurationInMinutes += 15;
    // }
    Duration totalDuration = Duration(minutes: totalDurationInMinutes);
    DateTime startTime = DateTime(
      startOfTheDay.year,
      startOfTheDay.month,
      startOfTheDay.day,
      startOfTheDay.hour,
      startOfTheDay.minute,
    );
    bool isTimeSet = false;
    while (!isTimeSet) {
      final endTime = startTime.add(totalDuration);
      if (endTime.isAfter(endOfTheDay)) {
        return _calculateBestStartTimeForTheDay(
            event, day.add(const Duration(days: 1)));
      }
      isTimeSet = true;
      for (final setEvent in setEvents) {
        if (max(setEvent!.startTime!.millisecondsSinceEpoch,
                startTime.millisecondsSinceEpoch) <
            min(setEvent.endTime!.millisecondsSinceEpoch,
                endTime.millisecondsSinceEpoch)) {
          startTime = setEvent.endTime!.add(const Duration(minutes: 15));
          isTimeSet = false;
          break;
        }
      }
    }
    int serviceOffsetInMinutes = 0;
    int serviceIndex = 0;
    for (final eventToAdd in eventsToAdd) {
      serviceIndex = eventsToAdd.indexOf(eventToAdd);
      if (eventToAdd != event) {
        serviceOffsetInMinutes +=
            serviceToDurationMap[eventToAdd.service.target!]!;
      } else {
        break;
      }
    }
    return startTime
        .add(Duration(minutes: serviceOffsetInMinutes + serviceIndex));
  }

  DateTime _calculateUserOverwrittenTimeForEvent(Event event) {
    DateTime startTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime! ~/ 60,
      selectedTime! % 60,
    );

    int serviceOffsetInMinutes = 0;
    int serviceIndex = 0;
    for (final eventToAdd in eventsToAdd) {
      serviceIndex = eventsToAdd.indexOf(eventToAdd);
      if (eventToAdd != event) {
        serviceOffsetInMinutes +=
            serviceToDurationMap[eventToAdd.service.target!]!;
      } else {
        break;
      }
    }
    return startTime
        .add(Duration(minutes: serviceOffsetInMinutes + serviceIndex));
  }

  int _calculateTotalDurationInMinutes() {
    int totalDurationInMinutes = 0;
    for (final event in eventsToAdd) {
      totalDurationInMinutes += serviceToDurationMap[event.service.target!]!;
    }
    return totalDurationInMinutes;
  }

  void _updateEventsOnDayView() {
    EventController<Event> calendarController = widget.calendarController ??
        CalendarControllerProvider.of<Event>(context).controller;

    for (final event in eventsOnCalendar) {
      calendarController.remove(event);
    }
    eventsOnCalendar = [];

    for (final event in eventsToAdd) {
      final eventStart = isOverwrittenByUser || widget.eventToEdit != null
          ? _calculateUserOverwrittenTimeForEvent(event)
          : _calculateBestStartTimeForTheDay(event, selectedDate!);
      event.startTime = eventStart;
      event.endTime = eventStart
          .add(Duration(minutes: serviceToDurationMap[event.service.target]!));
      event.cost = serviceToCostMap[event.service.target]! != 0
          ? serviceToCostMap[event.service.target]
          : null;
      event.isCurrentlyEdited = true;
      final calendarEvent = CalendarEventData<Event>(
        date: eventStart,
        event: event,
        title: event.service.target!.displayName,
        description: event.client.target!.displayName!,
        startTime: event.startTime!,
        endTime: event.endTime!,
        color: Color(event.service.target!.group.target!.color),
      );
      calendarController.add(calendarEvent);
      eventsOnCalendar.add(calendarEvent);
    }

    if (eventsToAdd.isNotEmpty && !isOverwrittenByUser) {
      final firstEventStart =
          _calculateBestStartTimeForTheDay(eventsToAdd.first, selectedDate!);
      selectedTime = firstEventStart.hour * 60 + firstEventStart.minute;
    }
  }

  void _cleanUpCalendar() {
    for (final event in eventsOnCalendar) {
      EventController<Event> calendarController =
          CalendarControllerProvider.of<Event>(context).controller;
      calendarController.remove(event);
    }
  }

  void _removeCurrentlyEditedFlags() {
    for (final event in eventsToAdd) {
      event.isCurrentlyEdited = false;
    }
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () {
        _removeCurrentlyEditedFlags();
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  DateTime _fromDateTime(DateTime src, {year, month, day, hour, minute, second, millisecond}) {
    return DateTime(
        year ?? src.year,
        month ?? src.month,
        day ?? src.day,
        hour ?? src.hour,
        minute ?? src.minute,
        second ?? src.second,
        millisecond ?? src.millisecond
    );
  }
}
