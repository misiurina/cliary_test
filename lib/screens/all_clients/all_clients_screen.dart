import 'package:azlistview/azlistview.dart';
import 'package:cliary_test/components/az_clients_list.dart';
import 'package:cliary_test/screens/add_clients_from_contacts/add_clients_from_contacts_screen.dart';
import 'package:cliary_test/cubit/client_cubit.dart';
import 'package:cliary_test/screens/navigation/cliary_drawer.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/cubit/all_clients_cubit.dart';
import 'package:cliary_test/screens/client/client_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/components/search_bar.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:flutter/material.dart';

class AllClientsScreen extends StatefulWidget {
  const AllClientsScreen({
    Key? key,
    this.hasDrawer = false,
  }) : super(key: key);

  final bool hasDrawer;

  @override
  State<AllClientsScreen> createState() => _AllClientsScreenState();
}

class _AllClientsScreenState extends State<AllClientsScreen> {
  TextEditingController controller = TextEditingController(text: '');
  ItemScrollController itemScrollController = ItemScrollController();

  List<AZClientData>? clients;
  List<AZClientData>? clientsToDisplay;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.hasDrawer
      ? const CliaryDrawer(
        selected: SelectedDrawerItem.clients,
      )
      : null,
      appBar: AppBar(
        backgroundColor: CliaryColors.cliaryMainBlue,
        foregroundColor: Colors.white,
        title: Text(
          'Twoje klienci',
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            SearchBar(
              controller: controller,
              callback: _filter,
              hint: 'Wyszukaj klienta',
            ),
            BlocBuilder<AllClientsPageCubit, IAllClientsPageState>(
              builder: (context, state) {
                clients = _prepareAZClients(
                  context.read<AllClientsPageCubit>().state.clients,
                );
                SuspensionUtil.sortListBySuspensionTag(clients);
                SuspensionUtil.setShowSuspensionStatus(clients);
                clientsToDisplay = List.from(clients!);

                return AZClientsList(
                  clientsToDisplay: clientsToDisplay!,
                  itemScrollController: itemScrollController,
                  itemClickedCallback: _itemClickedCallback,
                );
              }
            ),
            _buildBottomActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return BottomActionButtons(
      leftButton: CliaryElevatedButton(
        label: 'Dodaj kontakty',
        reverseColors: true,
        icon: const Icon(Icons.account_box),
        callback: () async {
          final List<Client>? contacts = await Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddClientsFromContactsScreen(
              alreadyInContacts: context.read<AllClientsPageCubit>().state.clients,
            ),
          ));
          if (contacts != null) context.read<AllClientsPageCubit>().putClientsFromContacts(contacts);
        },
      ),
      rightButton: CliaryElevatedButton(
        label: 'Dodaj klienta',
        icon: const Icon(Icons.add),
        callback: () {
          final client = Client(
            displayName: '',
            phoneNumber: '',
          );
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => ClientPageCubit(client, context.read<DatabaseController>()),
              child: const ClientScreen(
                isNew: true,
              ),
            ),
          ));
        },
      ),
    );
  }

  List<AZClientData> _prepareAZClients(List<Client?> clients) {
    return [
      for (final client in clients) AZClientData(
        displayName: client!.displayName!,
        phoneNumber: client.phoneNumber,
        photo: client.photo,
      )
    ];
  }

  void _filter(String value) {
    if (value.isEmpty) {
      setState(() {
        clientsToDisplay = List.from(clients!);
      });
      return;
    }
    setState(() {
      clientsToDisplay = [
        for (final client in clients!)
          if (_contactContains(client, value)) client
      ];
    });
  }

  bool _contactContains(AZClientData contact, String value) {
    if (value.length < 3) {
      return contact.displayName.toUpperCase().startsWith(value.toUpperCase()) ||
          contact.phoneNumber.toUpperCase().startsWith(value.toUpperCase());
    } else {
      return contact.displayName.toUpperCase().contains(value.toUpperCase()) ||
          contact.phoneNumber.toUpperCase().contains(value.toUpperCase());
    }
  }

  void _itemClickedCallback(AZClientData azClient) {
    final client = context.read<AllClientsPageCubit>().state.clients.firstWhere((element) => element!.phoneNumber == azClient.phoneNumber);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (_) => ClientPageCubit(client!, context.read<DatabaseController>()),
        child: const ClientScreen(),
      ),
    ));
  }
}
