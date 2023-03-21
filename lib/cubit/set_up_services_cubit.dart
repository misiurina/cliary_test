import 'package:bloc/bloc.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:equatable/equatable.dart';

class EditServicesCubit extends Cubit<SetUpServicesState> {
  EditServicesCubit(this.db) : super(InitialState(db.getAllServiceGroups()));

  final DatabaseController db;

  void addGroup() {
    state.groups.add(ServiceGroup(
      displayName: '',
      color: CliaryColors.getRandomPastelColor(),
    ));
    emit(InitialState(state.groups));
  }

  void saveGroup(ServiceGroup group) {
    if (group.services.isNotEmpty) {
      db.putServiceGroup(group);
    } else if(group.id != 0) {
      db.removeServiceGroup(group);
    }
  }

  void saveGroupColor(ServiceGroup group) {
    final stateGroup = _findGroup(group);
    if (stateGroup != null) {
      stateGroup.color = group.color;
    }
    saveGroup(group);
    emit(InitialState(state.groups));
  }

  void removeGroup(ServiceGroup group) {
    db.removeServiceGroup(group);
    state.groups.remove(group);
    emit(InitialState(state.groups));
  }

  void addService(ServiceGroup group, String name) {
    group.services.add(Service(
      displayName: name,
    ));
    db.putServiceGroup(group);
    emit(InitialState(state.groups));
  }

  void removeService(Service service) {
    db.removeService(service);
    final stateGroup = _findGroup(service.group.target!);
    if (stateGroup != null) {
      stateGroup.services.remove(service);
      emit(InitialState(state.groups));
    }
  }

  void saveService(Service service) {
    db.putService(service);
    emit(InitialState(state.groups));
  }

  ServiceGroup? _findGroup(ServiceGroup group) {
    return state.groups.firstWhere((element) => element != null && element.id == group.id);
  }

  // void increment() => emit(state + 1);

  // void decrement() => emit(state - 1);

}

class InitialState implements SetUpServicesState {
  InitialState(this.groups) {
    if (groups.isEmpty) {
      groups.add(ServiceGroup(
        displayName: '',
        color: CliaryColors.getRandomPastelColor(),
      ));
    }
  }

  @override
  final List<ServiceGroup?> groups;

  @override
  List<ServiceGroup?> get props => groups;

  @override
  bool get stringify => true;
}

abstract class SetUpServicesState extends Equatable {
  List<ServiceGroup?> get groups;
}
