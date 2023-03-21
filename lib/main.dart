import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/notifications/notification_helper.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/screens/add_clients_from_contacts/add_clients_from_contacts_screen.dart';
import 'package:cliary_test/screens/add_session/add_session_screen.dart';
import 'package:cliary_test/cubit/all_clients_cubit.dart';
import 'package:cliary_test/screens/all_clients/all_clients_screen.dart';
import 'package:cliary_test/screens/client/client_screen.dart';
import 'package:cliary_test/screens/main/main_screen.dart';
import 'package:cliary_test/screens/set_up_clients/set_up_clients_screen.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:cliary_test/screens/set_up_services/set_up_services_screen.dart';
import 'package:cliary_test/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'cubit/events_cubit.dart';
import 'model/models.dart';
import 'objectbox.g.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF104D90),
    statusBarIconBrightness: Brightness.light,
  ));

  final dir = await getApplicationDocumentsDirectory();
  final dbPath = '${dir.path}/objectbox';
  final store = Store(
    getObjectBoxModel(),
    directory: dbPath,
  );

  runApp(Cliary(store));
}

class Cliary extends StatelessWidget {
  const Cliary(this.store, {Key? key}) : super(key: key);

  final Store store;

  @override
  Widget build(BuildContext context) {
    final databaseController = DatabaseController(store);
    final eventController = EventController<Event>();

    List<CalendarEventData<Event>> events = [
      for (final event in databaseController.getAllEvents())
        CalendarEventData(
          date: event!.startTime!,
          event: event,
          title: event.service.target!.displayName,
          description: event.client.target!.displayName!,
          startTime: event.startTime!,
          endTime: event.endTime!,
          color: Color(event.service.target!.group.target!.color),
        ),
    ];

    eventController.addAll(events);

    return MultiProvider(
      providers: [
        Provider<DatabaseController>(create: (_) => databaseController),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => EditServicesCubit(databaseController)),
          BlocProvider(create: (_) => AllClientsPageCubit(databaseController)),
          BlocProvider(create: (_) => AllEventsCubit(databaseController)),
        ],
        child: CalendarControllerProvider(
          controller: eventController,
          child: MaterialApp(
            title: 'cliary',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              appBarTheme: Theme.of(context)
                  .appBarTheme
                  .copyWith(brightness: Brightness.light),
            ),
            home: DatabaseController(store).isInitialSetupDone()
                ? WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: const MainScreen())
                : const WelcomeScreen(),

            // home: const WelcomeScreen(),

            // home: const SetUpServicesScreen(),
            // home: const AddClientsFromContactsScreen(),
            // home: const AddSessionScreen(),
            // home: ClientScreen(client: DatabaseController(store).getAllClients()[2]!),
            // home: const SetUpClientsScreen(),
          ),
        ),
      ),
    );
  }
}
