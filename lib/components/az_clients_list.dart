import 'dart:typed_data';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:azlistview/azlistview.dart';
import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/components/list_section_header.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/components/pick_contact_list_item.dart';
import 'package:flutter/material.dart';

class AZClientsList extends StatelessWidget {
  const AZClientsList({
    Key? key,
    required this.clientsToDisplay,
    required this.itemScrollController,
    required this.itemClickedCallback,
  }) : super(key: key);

  final List<AZClientData> clientsToDisplay;
  final ItemScrollController itemScrollController;
  final void Function(AZClientData) itemClickedCallback;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AzListView(
        data: clientsToDisplay,
        physics: const BouncingScrollPhysics(),
        itemCount: clientsToDisplay.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItem(context, clientsToDisplay[index]);
        },
        itemScrollController: itemScrollController,
        indexHintBuilder: (BuildContext context, String tag) => Container(),
        indexBarData: _getIndexes(clientsToDisplay),
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          textStyle: CliaryTextStyle.get(
            fontSize: 12,
            color: CliaryColors.descriptionTextGray,
          ),
          selectTextStyle: CliaryTextStyle.get(
            fontSize: 12,
            color: Colors.white,
          ),
          selectItemDecoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: CliaryColors.cliaryMainBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, AZClientData client) {
    return Column(
      children: [
        Offstage(
          offstage: client.isShowSuspension != true,
          child: ListSectionHeader(text: client.getSuspensionTag()),
        ),
        CliaryInkWell(
          onTap: () => itemClickedCallback(client),
          child: ContactPickerListItem(
            photo: client.photo,
            name: client.displayName,
            phoneNumber: client.phoneNumber,
            isTicked: client.isSelected,
          ),
        ),
      ],
    );
  }

  List<String> _getIndexes(List<AZClientData> list) {
    List<String> indexData = [];
    if (list.isNotEmpty) {
      String? tempTag;
      for (int i = 0, length = list.length; i < length; i++) {
        String tag = list[i].getSuspensionTag();
        if (tempTag != tag) {
          indexData.add(tag);
          tempTag = tag;
        }
      }
    }
    return indexData;
  }
}

class AZClientData extends ISuspensionBean {
  AZClientData({
    required this.displayName,
    required this.phoneNumber,
    this.photo,
  });

  String displayName;
  String phoneNumber;
  Uint8List? photo;

  bool isSelected = false;

  @override
  String getSuspensionTag() {
    String tag = displayName.substring(0, 1).toUpperCase();
    if (RegExp("[A-Z]").hasMatch(tag)) {
      return tag;
    } else {
      return "#";
    }
  }
}
