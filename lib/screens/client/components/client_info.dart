import 'dart:typed_data';

import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_input_decoration.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/cubit/all_clients_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../../cubit/client_cubit.dart';

class ClientInfo extends StatefulWidget {
  const ClientInfo({
    Key? key,
    this.avatar,
    required this.name,
    required this.phoneNumber,
    this.info,
    required this.nameController,
    required this.phoneController,
    required this.nameFocus,
  }) : super(key: key);

  final Uint8List? avatar;
  final String name;
  final String phoneNumber;
  final String? info;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final FocusNode nameFocus;

  @override
  State<ClientInfo> createState() => _ClientInfoState();
}

class _ClientInfoState extends State<ClientInfo> {
  TextEditingController? infoController;

  @override
  void initState() {
    super.initState();
    infoController = TextEditingController(
      text: context.read<ClientPageCubit>().state.client.description ?? '',
    );
  }

  @override
  void dispose() {
    infoController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          _buildAvatar(),
          Padding(
              padding: const EdgeInsets.only(top: 5),
              child: _buildNameTextField()),
          _buildPhoneNumberTextField(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: _buildInfoTextField(),
          ),
        ],
      ),
    );
  }

  Container _buildAvatar() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color: const Color(0xFFEFF0F4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          highlightColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: const Center(
              child: Icon(
            Icons.camera_alt,
            size: 40,
            color: Colors.grey,
          )),
        ),
      ),
    );
  }

  TextField _buildNameTextField() {
    return TextField(
      controller: widget.nameController,
      autofocus: widget.name.isEmpty,
      focusNode: widget.nameFocus,
      cursorColor: CliaryColors.cliaryMainBlue,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      onChanged: (text) => _submitChanges(),
      textAlign: TextAlign.center,
      // textCapitalization: TextCapitalization.words,
      style: CliaryTextStyle.get(
        fontSize: 24,
      ),
      decoration: CliaryInputDecoration.none(
        hintText: "Imię klienta",
      ),
    );
  }

  TextField _buildPhoneNumberTextField() {
    return TextField(
      controller: widget.phoneController,
      cursorColor: CliaryColors.cliaryMainBlue,
      keyboardType: TextInputType.phone,
      onChanged: (text) => _submitChanges(),
      textAlign: TextAlign.center,
      style: CliaryTextStyle.get(
        fontSize: 18,
      ),
      decoration: CliaryInputDecoration.none(
        hintText: "Numer telefonu",
      ),
    );
  }

  TextField _buildInfoTextField() {
    return TextField(
      controller: infoController,
      cursorColor: CliaryColors.cliaryMainBlue,
      keyboardType: TextInputType.text,
      onChanged: (text) => _submitChanges(),
      maxLines: 1,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      style: CliaryTextStyle.get(
        color: CliaryColors.descriptionTextGray,
      ),
      decoration: CliaryInputDecoration.none(
        hintText: "Dodatkowe informacje",
      ),
    );
  }

  void _submitChanges() {
    final client = context.read<ClientPageCubit>().state.client;
    client.displayName = widget.nameController.text;
    client.phoneNumber = widget.phoneController.text;
    client.description = infoController!.text;
    if (client.displayName!.replaceAll(' ', '').isNotEmpty &&
        client.phoneNumber.replaceAll(' ', '').isNotEmpty) {
      context
          .read<ClientPageCubit>()
          .saveClient(context.read<AllClientsPageCubit>());
    }
  }
}
