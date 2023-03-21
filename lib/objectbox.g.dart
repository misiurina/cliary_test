// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'model/models.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(2, 7858000002332696468),
      name: 'Client',
      lastPropertyId: const IdUid(5, 8713708801141357832),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5929301492391423601),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7462075976197345642),
            name: 'displayName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4704352412841395173),
            name: 'phoneNumber',
            type: 9,
            flags: 2080,
            indexId: const IdUid(1, 7058097791555081263)),
        ModelProperty(
            id: const IdUid(4, 5944446533857376676),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8713708801141357832),
            name: 'photo',
            type: 23,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 5986989267032981236),
      name: 'Event',
      lastPropertyId: const IdUid(7, 5010579150738566980),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 552024388860596863),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 978845601943891946),
            name: 'startTime',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8492841146878164181),
            name: 'endTime',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1974889304505305180),
            name: 'clientId',
            type: 11,
            flags: 520,
            indexId: const IdUid(2, 8479733603081046725),
            relationTarget: 'Client'),
        ModelProperty(
            id: const IdUid(5, 7465947421009140914),
            name: 'cost',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5010579150738566980),
            name: 'serviceId',
            type: 11,
            flags: 520,
            indexId: const IdUid(5, 1218152188618020143),
            relationTarget: 'Service')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 2349529481251455066),
      name: 'Service',
      lastPropertyId: const IdUid(6, 4635353596580364256),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7694650519314026232),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 513786454057094554),
            name: 'displayName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1705023455806929211),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5430593442897697857),
            name: 'estimatedDuration',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2614327810556541974),
            name: 'estimatedCost',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4635353596580364256),
            name: 'groupId',
            type: 11,
            flags: 520,
            indexId: const IdUid(3, 2114908763062324416),
            relationTarget: 'ServiceGroup')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 8519039065006200059),
      name: 'ServiceGroup',
      lastPropertyId: const IdUid(3, 3504474936364026234),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3543549027683507018),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4931024184957992925),
            name: 'color',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3504474936364026234),
            name: 'displayName',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'services', srcEntity: 'Service', srcField: 'group')
      ])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(6, 8519039065006200059),
      lastIndexId: const IdUid(5, 1218152188618020143),
      lastRelationId: const IdUid(3, 3805822948179382408),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [690219955158701390, 8336667537215309158],
      retiredIndexUids: const [3186782043160850315],
      retiredPropertyUids: const [
        1678877411499546538,
        5112320231776418031,
        5117668165051323989,
        5600567590177575493,
        4865501842123126049
      ],
      retiredRelationUids: const [3805822948179382408],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Client: EntityDefinition<Client>(
        model: _entities[0],
        toOneRelations: (Client object) => [],
        toManyRelations: (Client object) => {},
        getId: (Client object) => object.id,
        setId: (Client object, int id) {
          object.id = id;
        },
        objectToFB: (Client object, fb.Builder fbb) {
          final displayNameOffset = object.displayName == null
              ? null
              : fbb.writeString(object.displayName!);
          final phoneNumberOffset = fbb.writeString(object.phoneNumber);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final photoOffset =
              object.photo == null ? null : fbb.writeListInt8(object.photo!);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, displayNameOffset);
          fbb.addOffset(2, phoneNumberOffset);
          fbb.addOffset(3, descriptionOffset);
          fbb.addOffset(4, photoOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final photoValue = const fb.ListReader<int>(fb.Int8Reader())
              .vTableGetNullable(buffer, rootOffset, 12);
          final object = Client(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              displayName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              phoneNumber:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              photo:
                  photoValue == null ? null : Uint8List.fromList(photoValue));

          return object;
        }),
    Event: EntityDefinition<Event>(
        model: _entities[1],
        toOneRelations: (Event object) => [object.client, object.service],
        toManyRelations: (Event object) => {},
        getId: (Event object) => object.id,
        setId: (Event object, int id) {
          object.id = id;
        },
        objectToFB: (Event object, fb.Builder fbb) {
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.startTime?.millisecondsSinceEpoch);
          fbb.addInt64(2, object.endTime?.millisecondsSinceEpoch);
          fbb.addInt64(3, object.client.targetId);
          fbb.addInt64(4, object.cost);
          fbb.addInt64(6, object.service.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final startTimeValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 6);
          final endTimeValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8);
          final object = Event(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              startTime: startTimeValue == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(startTimeValue),
              endTime: endTimeValue == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(endTimeValue),
              cost: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 12));
          object.client.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.client.attach(store);
          object.service.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          object.service.attach(store);
          return object;
        }),
    Service: EntityDefinition<Service>(
        model: _entities[2],
        toOneRelations: (Service object) => [object.group],
        toManyRelations: (Service object) => {},
        getId: (Service object) => object.id,
        setId: (Service object, int id) {
          object.id = id;
        },
        objectToFB: (Service object, fb.Builder fbb) {
          final displayNameOffset = fbb.writeString(object.displayName);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, displayNameOffset);
          fbb.addOffset(2, descriptionOffset);
          fbb.addInt64(3, object.estimatedDuration);
          fbb.addInt64(4, object.estimatedCost);
          fbb.addInt64(5, object.group.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Service(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              displayName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              estimatedDuration: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              estimatedCost: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 12));
          object.group.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          object.group.attach(store);
          return object;
        }),
    ServiceGroup: EntityDefinition<ServiceGroup>(
        model: _entities[3],
        toOneRelations: (ServiceGroup object) => [],
        toManyRelations: (ServiceGroup object) => {
              RelInfo<Service>.toOneBacklink(
                      6, object.id, (Service srcObject) => srcObject.group):
                  object.services
            },
        getId: (ServiceGroup object) => object.id,
        setId: (ServiceGroup object, int id) {
          object.id = id;
        },
        objectToFB: (ServiceGroup object, fb.Builder fbb) {
          final displayNameOffset = fbb.writeString(object.displayName);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.color);
          fbb.addOffset(2, displayNameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ServiceGroup(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              displayName:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              color:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          InternalToManyAccess.setRelInfo(
              object.services,
              store,
              RelInfo<Service>.toOneBacklink(
                  6, object.id, (Service srcObject) => srcObject.group),
              store.box<ServiceGroup>());
          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Client] entity fields to define ObjectBox queries.
class Client_ {
  /// see [Client.id]
  static final id = QueryIntegerProperty<Client>(_entities[0].properties[0]);

  /// see [Client.displayName]
  static final displayName =
      QueryStringProperty<Client>(_entities[0].properties[1]);

  /// see [Client.phoneNumber]
  static final phoneNumber =
      QueryStringProperty<Client>(_entities[0].properties[2]);

  /// see [Client.description]
  static final description =
      QueryStringProperty<Client>(_entities[0].properties[3]);

  /// see [Client.photo]
  static final photo =
      QueryByteVectorProperty<Client>(_entities[0].properties[4]);
}

/// [Event] entity fields to define ObjectBox queries.
class Event_ {
  /// see [Event.id]
  static final id = QueryIntegerProperty<Event>(_entities[1].properties[0]);

  /// see [Event.startTime]
  static final startTime =
      QueryIntegerProperty<Event>(_entities[1].properties[1]);

  /// see [Event.endTime]
  static final endTime =
      QueryIntegerProperty<Event>(_entities[1].properties[2]);

  /// see [Event.client]
  static final client =
      QueryRelationToOne<Event, Client>(_entities[1].properties[3]);

  /// see [Event.cost]
  static final cost = QueryIntegerProperty<Event>(_entities[1].properties[4]);

  /// see [Event.service]
  static final service =
      QueryRelationToOne<Event, Service>(_entities[1].properties[5]);
}

/// [Service] entity fields to define ObjectBox queries.
class Service_ {
  /// see [Service.id]
  static final id = QueryIntegerProperty<Service>(_entities[2].properties[0]);

  /// see [Service.displayName]
  static final displayName =
      QueryStringProperty<Service>(_entities[2].properties[1]);

  /// see [Service.description]
  static final description =
      QueryStringProperty<Service>(_entities[2].properties[2]);

  /// see [Service.estimatedDuration]
  static final estimatedDuration =
      QueryIntegerProperty<Service>(_entities[2].properties[3]);

  /// see [Service.estimatedCost]
  static final estimatedCost =
      QueryIntegerProperty<Service>(_entities[2].properties[4]);

  /// see [Service.group]
  static final group =
      QueryRelationToOne<Service, ServiceGroup>(_entities[2].properties[5]);
}

/// [ServiceGroup] entity fields to define ObjectBox queries.
class ServiceGroup_ {
  /// see [ServiceGroup.id]
  static final id =
      QueryIntegerProperty<ServiceGroup>(_entities[3].properties[0]);

  /// see [ServiceGroup.color]
  static final color =
      QueryIntegerProperty<ServiceGroup>(_entities[3].properties[1]);

  /// see [ServiceGroup.displayName]
  static final displayName =
      QueryStringProperty<ServiceGroup>(_entities[3].properties[2]);
}
