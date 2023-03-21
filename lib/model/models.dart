import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

@Entity()
class Client {
  Client({
    this.id = 0,
    this.displayName,
    required this.phoneNumber,
    this.description,
    this.photo,
  });

  Client.from(Client other) : id = other.id, phoneNumber = other.phoneNumber {
    displayName = other.displayName;
    description = other.description;
    if (other.photo != null) {
      photo = Uint8List.fromList(other.photo!.toList());
    }
  }

  int id;

  String? displayName;
  @Unique()
  String phoneNumber;
  String? description;
  Uint8List? photo;
}

@Entity()
class Service {
  Service({
    this.id = 0,
    required this.displayName,
    this.description,
    this.estimatedDuration,
    this.estimatedCost,
  });

  Service.from(Service other) : id = other.id, displayName = other.displayName {
    description = other.description;
    estimatedDuration = other.estimatedDuration;
    estimatedCost = other.estimatedCost;
    group.target = ServiceGroup.from(other.group.target!);
  }

  int id;

  String displayName;
  String? description;
  int? estimatedDuration;
  int? estimatedCost;
  final group = ToOne<ServiceGroup>();
}

@Entity()
class ServiceGroup {
  ServiceGroup({
    this.id = 0,
    required this.displayName,
    required this.color,
  });

  ServiceGroup.from(ServiceGroup other) : id = other.id, displayName = other.displayName, color = other.color {
    for (final service in other.services) {
      services.add(Service.from(service));
    }
  }

  int id;

  String displayName;
  @Backlink('group')
  final services = ToMany<Service>();
  int color;
}

@Entity()
class Event {
  Event({
    this.id = 0,
    required this.startTime,
    required this.endTime,
    this.cost,
  });

  Event.from(Event other) : id = other.id {
    startTime = DateTime.fromMillisecondsSinceEpoch(other.startTime!.millisecondsSinceEpoch);
    endTime = DateTime.fromMillisecondsSinceEpoch(other.endTime!.millisecondsSinceEpoch);
    client.target = other.client.target!;
    service.target = other.service.target!;
    cost = other.cost;
  }

  int id;

  DateTime? startTime;
  DateTime? endTime;
  final client = ToOne<Client>();
  final service = ToOne<Service>();
  int? cost;

  @Transient()
  bool isCurrentlyEdited = false;
}