import 'package:bloc/bloc.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/model/models.dart';
import 'package:equatable/equatable.dart';

class AllClientsPageCubit extends Cubit<IAllClientsPageState> {
  AllClientsPageCubit(this.db) : super(AllClientsPageState(db.getAllClients()));

  final DatabaseController db;

  void refresh() {
    emit(AllClientsPageState(db.getAllClients()));
  }

  void putClientsFromContacts(List<Client> clients) {
    db.putAllClients(clients);
    state.clients.addAll(clients);
    emit(AllClientsPageState(state.clients));
  }

}

class AllClientsPageState implements IAllClientsPageState {
  AllClientsPageState(this.clients);

  @override
  final List<Client?> clients;

  @override
  List<Object> get props => [clients];

  @override
  bool get stringify => true;
}

abstract class IAllClientsPageState extends Equatable {
  List<Client?> get clients;
}