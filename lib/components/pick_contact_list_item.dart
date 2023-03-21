import 'dart:typed_data';

import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';

class ContactPickerListItem extends StatelessWidget {
  const ContactPickerListItem({
    Key? key,
    this.photo,
    required this.name,
    required this.phoneNumber,
    required this.isTicked,
  }) : super(key: key);

  final Uint8List? photo;
  final String name;
  final String phoneNumber;

  final bool isTicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 30, 0),
      child: _buildListTile(),
      decoration: BoxDecoration(
        color: isTicked
            ? CliaryColors.cliaryMainBlue.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildTickedThumbnail() {
    return Container(
      child: const Icon(
        Icons.done,
        color: Colors.white,
      ),
      decoration: const BoxDecoration(
        color: CliaryColors.cliaryMainBlue,
        shape: BoxShape.circle,
      ),
      width: 50.0,
      height: 50.0,
      padding: const EdgeInsets.all(5.0),
    );
  }

  Widget _buildInitialsThumbnail() {
    List<String> names = name.split(' ');
    String? lastName = names.length > 1 ? names[names.length - 1] : null;

    return Container(
      child: Center(
        child: Text(
          '${name[0].toUpperCase()}${lastName != null ? lastName[0].toUpperCase() : ''}',
          style: CliaryTextStyle.get(
            color: Colors.white,
            fontSize: 20,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: CliaryColors.cliaryMainBlue.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      width: 50.0,
      height: 50.0,
      padding: const EdgeInsets.all(5.0),
    );
  }

  Widget _buildImageThumbnail() {
    return Container(
      child: Center(
        child: Image.memory(photo!),
      ),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      width: 50.0,
      height: 50.0,
      padding: const EdgeInsets.all(5.0),
    );
  }

  Widget _buildLeading() {
    return isTicked
        ? _buildTickedThumbnail()
        : photo == null
        ? _buildInitialsThumbnail()
        : _buildImageThumbnail();
  }

  Widget _buildListTile() {
    return ListTile(
      leading: _buildLeading(),
      title: Text(
        name,
        style: CliaryTextStyle.get(),
      ),
      subtitle: Text(
        phoneNumber,
        style: CliaryTextStyle.get(
          fontSize: 13,
          color: CliaryColors.descriptionTextGray,
        ),
      ),
    );
  }
}
