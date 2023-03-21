import 'package:analyzer/dart/ast/token.dart';
import 'package:bloc/bloc.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/cubit/all_clients_cubit.dart';
import 'package:equatable/equatable.dart';

class ClientPageCubit extends Cubit<IClientPageState> {
  ClientPageCubit(this.client, this.db) : super(ClientPageState(client, db));

  final Client client;
  final DatabaseController db;

  void removeClient(AllClientsPageCubit allClientsCubit) {
    db.removeClient(client);
    allClientsCubit.refresh();
  }

  void saveClient(AllClientsPageCubit allClientsCubit) {
    db.putClient(client);
    allClientsCubit.refresh();
  }

}

// class InitialState implements IClientPageState {
//   ClientPageState(this.db) : client = Client(),
//
//   @override
//   final Client client;
//   @override
//   final DatabaseController db;
//   @override
//   final List<ServiceGroup?> groups;
//   @override
//   final Map<ServiceGroup, bool> isGroupUsedMap = <ServiceGroup, bool>{};
//   @override
//   final Map<Service, int> serviceToTimesUsedMap = <Service, int>{};
//   @override
//   final List<Service?> favouriteServices = [];
//   @override
//   final List<Event?> pastEvents = [];
//   @override
//   final List<Event?> futureEvents = [];
//
//   @override
//   List<Client?> get props => [client];
//   @override
//   bool get stringify => true;
// }

class ClientPageState implements IClientPageState {
  ClientPageState(this.client, this.db) : groups = db.getAllServiceGroups() {
    final services = [for (final group in groups) ...group!.services];

    final favourites = [];

    for (final service in services) {
      if (client.id == 0) {
        serviceToTimesUsedMap[service] = 0;
        continue;
      }

      final count = db.getTimesUsed(client, service);
      serviceToTimesUsedMap[service] = count;
      if (count != 0) favourites.add(service);
    }

    for (final group in groups) {
      isGroupUsedMap[group!] = false;
      for (final service in group.services) {
        if (serviceToTimesUsedMap[service] != 0) isGroupUsedMap[group] = true;
      }
    }

    favourites.sort((a, b) =>
        serviceToTimesUsedMap[b]!.compareTo(serviceToTimesUsedMap[a]!));
    for (int i = 0; i < favourites.length && i < 3; i++) {
      favouriteServices.add(favourites[i]);
    }

    final events = db.getAllEventsForClient(client);
    for (final event in events) {
      if (event!.endTime!.isBefore(DateTime.now())) {
        pastEvents.add(event);
      } else {
        futureEvents.add(event);
      }
    }
  }

  @override
  final Client client;
  @override
  final DatabaseController db;
  @override
  final List<ServiceGroup?> groups;
  @override
  final Map<ServiceGroup, bool> isGroupUsedMap = <ServiceGroup, bool>{};
  @override
  final Map<Service, int> serviceToTimesUsedMap = <Service, int>{};
  @override
  final List<Service?> favouriteServices = [];
  @override
  final List<Event?> pastEvents = [];
  @override
  final List<Event?> futureEvents = [];

  @override
  List<Client?> get props => [client];
  @override
  bool get stringify => true;
}

abstract class IClientPageState extends Equatable {
  Client get client;
  DatabaseController get db;
  List<ServiceGroup?> get groups;
  Map<ServiceGroup, bool> get isGroupUsedMap;
  Map<Service, int> get serviceToTimesUsedMap;
  List<Service?> get favouriteServices;
  List<Event?> get pastEvents;
  List<Event?> get futureEvents;
}

// class _ClientService {
//   _ClientService({
//     required this.service,
//     required this.timesUsed,
//   });
//
//   Service service;
//   int timesUsed;
// }

// class _DateService {
//   DateTime date;
//   Service
// }
