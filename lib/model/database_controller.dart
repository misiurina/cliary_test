import 'package:cliary_test/notifications/notification_helper.dart';

import '../objectbox.g.dart';
import 'models.dart';

class DatabaseController {
  DatabaseController(Store store) : _store = store;
  NotificationHelper notificationHelper = NotificationHelper();

  final Store _store;
  late final _Client _client = _initClient();
  late final _Service _service = _initService();
  late final _ServiceGroup _serviceGroup = _initServiceGroup();
  late final _Event _event = _initEvent();

  _Client _initClient() => _Client(_store);
  _Service _initService() => _Service(_store);
  _ServiceGroup _initServiceGroup() => _ServiceGroup(_store);
  _Event _initEvent() => _Event(_store);

  Client? getClient(int index) => _client._box.get(index);
  List<Client?> getClients(List<int> indexes) => _client._box.getMany(indexes);
  List<Client?> getAllClients() => _client._box.getAll();
  void putClient(Client client) => _client._box.put(client);
  void putAllClients(List<Client> clients) => _client._box.putMany(clients);
  void removeClient(Client client) {
    _store.runInTransaction(TxMode.write, () {
      final eventsToRemove = _event._box.getAll().where((element) => element.client.targetId == client.id);
      _event._box.removeMany([for (final event in eventsToRemove) event.id]);
      _client._box.remove(client.id);
    });
  }

  Service? getService(int index) => _service._box.get(index);
  List<Service?> getServices(List<int> indexes) => _service._box.getMany(indexes);
  List<Service?> getAllServices() => _service._box.getAll();
  void putService(Service service) => _service._box.put(service);
  void removeService(Service service) {
    _store.runInTransaction(TxMode.write, () {
      final serviceGroup = service.group.target!;
      final groupSize = serviceGroup.services.length;
      final eventsToRemove = _event._box.getAll().where((element) => element.service.targetId == service.id);
      _event._box.removeMany([for (final event in eventsToRemove) event.id]);
      _service._box.remove(service.id);
      if (groupSize == 1) {
        _serviceGroup._box.remove(serviceGroup.id);
      }
    });
  }

  ServiceGroup? getServiceGroup(int index) => _serviceGroup._box.get(index);
  List<ServiceGroup?> getServiceGroups(List<int> indexes) => _serviceGroup._box.getMany(indexes);
  List<ServiceGroup?> getAllServiceGroups() => _serviceGroup._box.getAll();
  void putServiceGroup(ServiceGroup group) {
    if (group.services.isNotEmpty) _serviceGroup._box.put(group);
  }
  void removeServiceGroup(ServiceGroup group) {
    _store.runInTransaction(TxMode.write, () {
      for (var service in group.services) {
        removeService(service);
      }
      _serviceGroup._box.remove(group.id);
    });
  }

  Event? getEvent(int index) => _event._box.get(index);
  List<Event?> getEvents(List<int> indexes) => _event._box.getMany(indexes);
  List<Event?> getAllEvents() {
    QueryBuilder<Event> builder = _event._box.query();
    builder.order(Event_.startTime, flags: Order.descending);
    Query<Event> query = builder.build();
    return query.find();
  }
  List<Event?> getAllEventsForClient(Client client) {
    QueryBuilder<Event> builder = _event._box.query();
    builder.link(Event_.client, Client_.id.equals(client.id));
    builder.order(Event_.startTime, flags: Order.descending);
    Query<Event> query = builder.build();
    return query.find();
  }
  void putEvent(Event event) {
    _event._box.put(event);
    final id = _event._box.getAll().firstWhere((element) => element.service.targetId == event.service.targetId && element.client.targetId == event.client.targetId && element.startTime!.isAtSameMomentAs(event.startTime!)).id;
    notificationHelper.cancelNotification(id);
    notificationHelper.scheduleNotification(id, event.service.target!.displayName, event.client.target!.displayName!, event.startTime!, event.endTime!, event.cost, 15);
  }
  int getTimesUsed(Client client, Service service) {
    QueryBuilder<Event> builder = _event._box.query(Event_.client.equals(client.id));
    builder.link(Event_.service, Service_.id.equals(service.id));
    Query<Event> query = builder.build();
    return query.count();
  }
  void removeEvent(Event event) {
    _event._box.remove(event.id);

    notificationHelper.cancelNotification(event.id);
  }

  bool isInitialSetupDone() {
    int services = _service._box.query().build().count();
    int clients = _client._box.query().build().count();
    return services != 0 && clients != 0;
  }
}

class _Client {
  _Client(Store store) : _box = store.box<Client>();

  final Box<Client> _box;
}

class _Service {
  _Service(Store store) : _box = store.box<Service>();

  final Box<Service> _box;
}

class _ServiceGroup {
  _ServiceGroup(Store store) : _box = store.box<ServiceGroup>();

  final Box<ServiceGroup> _box;
}

class _Event {
  _Event(Store store) : _box = store.box<Event>();

  final Box<Event> _box;
}