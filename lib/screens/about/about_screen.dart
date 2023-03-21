import 'package:cliary_test/components/headed_fragment.dart';
import 'package:cliary_test/components/helper_text_header.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/screens/navigation/cliary_drawer.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({
    Key? key,
    this.hasDrawer = false,
  }) : super(key: key);

  final bool hasDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: hasDrawer
          ? const CliaryDrawer(
              selected: SelectedDrawerItem.about,
            )
          : null,
      appBar: AppBar(
        backgroundColor: CliaryColors.cliaryMainBlue,
        title: Text(
          'O aplikacji',
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
      body: ListView(
        children: [
          HelperTextHeader(
            text: 'Witaj w cliary!\nPrzy pomocy tej aplikacji możesz w jednym miejscu przechowywać listę swoich klientów i wykonywanych usług oraz planować spotkania z klientami!\n\nWersja aplikacji: 1.0.0',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: HeadedFragment(
              header: 'Licencje open source:',
              child: Container(),
            ),
          ),
          ListTile(
            title: Text(
              'contacts_service',
              style: CliaryTextStyle.get(),
            ),
          ),
          ListTile(
            title: Text(
              'objectbox',
              style: CliaryTextStyle.get(),
            ),
          ),
          ListTile(
            title: Text(
              'analyzer',
              style: CliaryTextStyle.get(),
            ),
          ),
          ListTile(
            title: Text(
              'bloc',
              style: CliaryTextStyle.get(),
            ),
          ),
          ListTile(
            title: Text(
              'flutter_bloc',
              style: CliaryTextStyle.get(),
            ),
          ),
          ListTile(
            title: Text(
              'equatable',
              style: CliaryTextStyle.get(),
            ),
          ),
          ListTile(
            title: Text(
              'objectbox_flutter_libs',
              style: CliaryTextStyle.get(),
            ),
          ),
          ListTile(
            title: Text(
              'path_provider',
              style: CliaryTextStyle.get(),
            ),
          ),
        ],
      ),
    );
  }
}
