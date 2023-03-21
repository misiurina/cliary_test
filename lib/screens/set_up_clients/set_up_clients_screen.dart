import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/screens/add_clients_from_contacts/add_clients_from_contacts_screen.dart';
import 'package:cliary_test/screens/all_clients/all_clients_screen.dart';
import 'package:cliary_test/cubit/client_cubit.dart';
import 'package:cliary_test/screens/main/main_screen.dart';
import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/components/cliary_scroll_view.dart';
import 'package:cliary_test/components/cliary_sliver_app_bar.dart';
import 'package:cliary_test/components/helper_text_header.dart';
import 'package:cliary_test/components/pick_contact_list_item.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/cubit/all_clients_cubit.dart';
import 'package:cliary_test/screens/client/client_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class SetUpClientsScreen extends StatefulWidget {
  const SetUpClientsScreen({Key? key}) : super(key: key);

  @override
  State<SetUpClientsScreen> createState() => _SetUpClientsScreenState();
}

class _SetUpClientsScreenState extends State<SetUpClientsScreen> {
  List<Client?>? clients;
  bool isCheckBoxChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CliaryScrollView(
        appBar: const CliarySliverAppBar(
          title: 'cliary',
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HelperTextHeader(
                text: 'Dodaj swoich klientów. Możesz je zaimportować z listy kontaktów lub dodać za pomocą przycisku "dodaj klienta". Gdy otrzymasz telefon od jednego ze swoich klientów, otrzymasz powiadomienie, aby szybko dodać wydarzenie.',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: _buildClientsList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildAddFromContactsBtn(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildAddClientBtn(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                child: _buildLabeledCheckBox(),
              ),
              const Spacer(),
              _buildBottomActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CliaryInkWell(
      onTap: _headerClickedCallback,
      child: Container(
        decoration: const BoxDecoration(
          color: CliaryColors.cliaryMainBlue,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        'Wszystkie klienci',
                        style: CliaryTextStyle.get(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 7),
                    child: const Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: Icon(
                          Icons.group,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientsList() {
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 2,
        child: SizedBox(
          height: 200,
          child: IntrinsicHeight(
            child: Column(
              children: [
                _buildHeader(),
                BlocBuilder<AllClientsPageCubit, IAllClientsPageState>(
                    builder: (context, state) {
                      clients = context.read<AllClientsPageCubit>().state.clients;

                      if (clients!.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'Dodaj pierwszego klienta',
                              style: CliaryTextStyle.get(),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemCount: clients!.length,
                            itemBuilder: (context, i) {
                              return CliaryInkWell(
                                child: ContactPickerListItem(
                                  name: clients![i]!.displayName!,
                                  phoneNumber: clients![i]!.phoneNumber,
                                  photo: clients![i]!.photo,
                                  isTicked: false,
                                ),
                                onTap: () => _itemClickedCallback(clients![i]!),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 1,
                                indent: 15,
                                endIndent: 15,
                              );
                            },
                          ),
                        );
                      }
                    }
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildAddFromContactsBtn() {
    return SizedBox(
      width: double.infinity,
      child: CliaryElevatedButton(
        label: 'Dodaj z listy kontaktów',
        icon: const Icon(Icons.account_box),
        callback: _getClientsFromContacts,
      ),
    );
  }

  Widget _buildAddClientBtn() {
    return SizedBox(
      width: double.infinity,
      child: CliaryElevatedButton(
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
                isInitialSetup: true,
              ),
            ),
          ));
        },
      ),
    );
  }

  Widget _buildLabeledCheckBox() {
    return CheckboxListTile(
      title: Text(
        'Otrzymuj powiadomienia, gdy odbierasz połączenia z nieznanych numerów',
        style: CliaryTextStyle.get(),
      ),
      value: isCheckBoxChecked,
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: CliaryColors.cliaryMainBlue,
      onChanged: (value) => setState(() {
        isCheckBoxChecked = !isCheckBoxChecked;
      }),
    );
  }

  Widget _buildBottomActionButtons() {
    return BottomActionButtons(
      leftButton: CliaryElevatedButton(
        label: 'Wróć',
        reverseColors: true,
        callback: () => Navigator.pop(context),
      ),
      rightButton: BlocBuilder<AllClientsPageCubit, IAllClientsPageState>(
        builder: (context, state) {
          return CliaryElevatedButton(
            label: 'Dalej',
            callback: () => Navigator.pushAndRemoveUntil(context, PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 100),
              child: const MainScreen(),
            ),
                (route) => false,
            ),
            isActive: state.clients.isNotEmpty,
          );
        }
      ),
    );
  }

  void _getClientsFromContacts() async {
    final List<Client>? contacts = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddClientsFromContactsScreen(
        alreadyInContacts: clients!,
      ),
    ));
    if (contacts != null) context.read<AllClientsPageCubit>().putClientsFromContacts(contacts);
  }

  void _headerClickedCallback() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const AllClientsScreen(),
    ));
  }

  void _itemClickedCallback(Client client) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (_) => ClientPageCubit(client, context.read<DatabaseController>()),
        child: const ClientScreen(
          isInitialSetup: true,
        ),
      ),
    ));
  }
}
