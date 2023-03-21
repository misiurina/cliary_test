import 'package:bloc/bloc.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/model/models.dart';
import 'package:equatable/equatable.dart';

class AllEventsCubit extends Cubit<IAllEventsState> {
  AllEventsCubit(this.db) : super(AllEventsState(db.getAllEvents()));

  final DatabaseController db;

  void refresh() {
    emit(AllEventsState(db.getAllEvents()));
  }

  void saveEvent(Event event) {
    db.putEvent(event);
  }

  void removeEvent(Event event) {
    db.removeEvent(event);
  }
}

class AllEventsState implements IAllEventsState {
  AllEventsState(this.events)
      : eventsToday = events
            .where((event) =>
                event!.startTime!.year == DateTime.now().year &&
                event.startTime!.month == DateTime.now().month &&
                event.startTime!.day == DateTime.now().day)
            .length;

  @override
  final List<Event?> events;

  @override
  final int eventsToday;

  @override
  List<Object> get props => [events];

  @override
  bool get stringify => true;
}

abstract class IAllEventsState extends Equatable {
  List<Event?> get events;
  int get eventsToday;
}
