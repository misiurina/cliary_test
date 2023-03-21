import 'package:azlistview/azlistview.dart';
import 'package:cliary_test/components/az_clients_list.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/components/search_bar.dart';
import 'package:cliary_test/model/models.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AddClientsFromContactsScreen extends StatefulWidget {
  const AddClientsFromContactsScreen({
    Key? key,
    this.alreadyInContacts = const [],
  }) : super(key: key);

  final List<Client?> alreadyInContacts;

  @override
  State<AddClientsFromContactsScreen> createState() =>
      _AddClientsFromContactsScreenState();
}

class _AddClientsFromContactsScreenState
    extends State<AddClientsFromContactsScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  List<AZClientData>? contacts;
  List<bool>? cachedSelections;
  List<AZClientData>? contactsToDisplay;
  TextEditingController controller = TextEditingController(text: '');
  bool isSelectAllChecked = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CliaryColors.cliaryMainBlue,
        foregroundColor: Colors.white,
        title: Text(
          'Wybierz klientów',
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
      body: contacts != null
          ? _buildLayout()
          : FutureBuilder<List<Contact>>(
              future: _loadContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  contacts = _getContactData(snapshot.data!);
                  contacts = [for (final contact in contacts!)
                    if (!widget.alreadyInContacts.any((element) => element!.phoneNumber.replaceAll('', ' ') == contact.phoneNumber.replaceAll('', ' ')))
                      contact
                  ];
                  contactsToDisplay = List.from(contacts!);
                  return _buildLayout();
                }
                return _buildProgressIndicator();
              },
            ),
    );
  }

  Future<List<Contact>> _loadContacts() async {
    return await ContactsService.getContacts(withThumbnails: false);
  }

  Widget _buildLayout() {
    return SafeArea(
      child: Column(
        children: [
          SearchBar(
            controller: controller,
            callback: _filter,
            hint: 'Wyszukaj kontakt',
          ),
          _buildSelectAllButton(),
          AZClientsList(
            clientsToDisplay: contactsToDisplay!,
            itemScrollController: itemScrollController,
            itemClickedCallback: _itemClickedCallback,
          ),
          _buildBottomActionButtons(),
        ],
      ),
    );
  }

  void _filter(String value) {
    if (value.isEmpty) {
      setState(() {
        contactsToDisplay = List.from(contacts!);
      });
      return;
    }
    setState(() {
      contactsToDisplay = [
        for (final contact in contacts!)
          if (_contactContains(contact, value)) contact
      ];
    });
  }

  bool _contactContains(AZClientData contact, String value) {
    if (value.length < 3) {
      return contact.displayName
              .toUpperCase()
              .startsWith(value.toUpperCase()) ||
          contact.phoneNumber.toUpperCase().startsWith(value.toUpperCase());
    } else {
      return contact.displayName.toUpperCase().contains(value.toUpperCase()) ||
          contact.phoneNumber.toUpperCase().contains(value.toUpperCase());
    }
  }

  Widget _buildSelectAllButton() {
    return CliaryInkWell(
      onTap: _toggleSelectAll,
      child: Row(
        children: [
          isSelectAllChecked
              ? Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: CliaryColors.cliaryMainDarkBlue,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: const Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                )
              : Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: CliaryColors.textBlack,
                        width: 2,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                ),
          Text(
            'Zaznacz wszystkich',
            style: CliaryTextStyle.get(),
          ),
        ],
      ),
    );
  }

  void _toggleSelectAll() {
    if (isSelectAllChecked && cachedSelections != null) {
      for (int i = 0; i < contacts!.length; i++) {
        contacts![i].isSelected = cachedSelections![i];
      }
    } else {
      cachedSelections = [for (final contact in contacts!) contact.isSelected];
      for (final contact in contacts!) {
        contact.isSelected = true;
      }
    }
    setState(() {
      isSelectAllChecked = !isSelectAllChecked;
    });
  }

  Widget _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: CliaryColors.cliaryMainBlue,
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return BottomActionButtons(
      leftButton: CliaryElevatedButton(
        label: 'Wróć',
        reverseColors: true,
        callback: () => Navigator.pop(context),
      ),
      rightButton: CliaryElevatedButton(
        label: 'Zapisz',
        callback: () {
          final clientsToAdd = [
            for (final contact in contacts!) if (contact.isSelected) Client(
              displayName: contact.displayName,
              phoneNumber: contact.phoneNumber,
              photo: contact.photo,
            ),
          ];
          Navigator.of(context).pop(clientsToAdd);
        },
      ),
    );
  }

  void _itemClickedCallback(AZClientData client) {
    if (isSelectAllChecked) {
      isSelectAllChecked = false;
    }
    setState(() {
      client.isSelected = !client.isSelected;
    });
  }

  List<AZClientData> _getContactData(List<Contact> contacts) {
    List<AZClientData> listData = [];
    for (final contact in contacts) {
      if (contact.displayName != null &&
          contact.phones != null &&
          contact.phones!.isNotEmpty &&
          contact.phones![0].value != null) {
        listData.add(AZClientData(
          displayName: contact.displayName!,
          phoneNumber: contact.phones![0].value!,
        ));
      }
    }
    SuspensionUtil.sortListBySuspensionTag(listData);
    SuspensionUtil.setShowSuspensionStatus(listData);
    return listData;
  }
}
