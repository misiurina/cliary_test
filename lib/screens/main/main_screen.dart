import 'package:calendar_view/calendar_view.dart';
import 'package:cliary_test/components/cliary_day_view.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/screens/add_session/add_session_screen.dart';
import 'package:cliary_test/screens/navigation/cliary_drawer.dart';
import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/cliary_sliver_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/src/day_view/day_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<DayViewState>? dayViewState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CliaryDrawer(
        selected: SelectedDrawerItem.calendar,
      ),
      floatingActionButton: CliaryElevatedButton(
        label: 'Dodaj wydarzenie',
        icon: const Icon(Icons.add),
        callback: () async {
          final selectedDate = dayViewState!.currentState!.currentDate;
          await Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddSessionScreen(
              initialDay: selectedDate.difference(DateTime.now()).inDays <= 0 ? null : selectedDate,
            ),
          ));
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, isInnerScrolled) {
          return [
            CliarySliverAppBar(
              title: 'cliary',
              actions: [
                IconButton(
                  icon: const Icon(Icons.today),
                  onPressed: () {
                    dayViewState!.currentState!.animateToDate(DateTime.now());
                  },
                ),
              ],
            ),
          ];
        },
        body: CliaryDayView(
          dayViewState: dayViewState,
          onEventTap: (event) async {
            if (event.startTime!.isBefore(DateTime.now())) return;

            EventController<Event> calendarController = CalendarControllerProvider.of<Event>(context).controller;
            await Navigator.push(context, MaterialPageRoute(
              builder: (context) => AddSessionScreen(
                eventToEdit: event.event,
                calendarController: calendarController,
              ),
            ));
            setState(() {});
          },
        ),
      ),
    );
  }
}
