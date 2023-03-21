import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/headed_fragment.dart';
import 'package:cliary_test/screens/navigation/cliary_drawer.dart';
import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CliaryDrawer(
        selected: SelectedDrawerItem.settings,
      ),
      appBar: AppBar(
        backgroundColor: CliaryColors.cliaryMainBlue,
        title: Text(
          'Ustawienia',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: _buildStartTimePicker(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: _buildEndTimePicker(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: _buildMinutesBetweenEventsPicker(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: _buildMinutesToNotifyPicker(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: _buildLabeledCheckBox(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: _buildExportToExcelBtn(),
          ),
        ],
      ),
    );
  }

  Widget _buildStartTimePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: HeadedFragment(
        header: 'Czas rozpoczęcia dnia roboczego:',
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: NumberPicker(
              value: 8 * 60,
              minValue: 0,
              maxValue: 24 * 60,
              step: 5,
              itemHeight: 30,
              itemWidth: 80,
              haptics: true,
              axis: Axis.horizontal,
              textStyle: CliaryTextStyle.get(
                color: CliaryColors.descriptionTextGray.withOpacity(0.5),
              ),
              selectedTextStyle: CliaryTextStyle.get(
                fontSize: 20,
                color: CliaryColors.cliaryMainBlue,
              ),
              onChanged: (value) => {},
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CliaryColors.descriptionTextGray),
              ),
              textMapper: (number) {
                final hours = int.parse(number) ~/ 60;
                final minutes = int.parse(number) % 60;
                return '$hours : ${minutes < 10 ? '0$minutes' : minutes}';
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndTimePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: HeadedFragment(
        header: 'Czas zakończenia dnia roboczego:',
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: NumberPicker(
              value: 22 * 60,
              minValue: 8 * 60,
              maxValue: 24 * 60,
              step: 5,
              itemHeight: 30,
              itemWidth: 80,
              haptics: true,
              axis: Axis.horizontal,
              textStyle: CliaryTextStyle.get(
                color: CliaryColors.descriptionTextGray.withOpacity(0.5),
              ),
              selectedTextStyle: CliaryTextStyle.get(
                fontSize: 20,
                color: CliaryColors.cliaryMainBlue,
              ),
              onChanged: (value) => {},
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CliaryColors.descriptionTextGray),
              ),
              textMapper: (number) {
                final hours = int.parse(number) ~/ 60;
                final minutes = int.parse(number) % 60;
                return '$hours : ${minutes < 10 ? '0$minutes' : minutes}';
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinutesBetweenEventsPicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: HeadedFragment(
        header: 'Ile minut musi być zarezerwowano pomiędzy klientami:',
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: NumberPicker(
              value: 15,
              minValue: 0,
              maxValue: 60,
              step: 5,
              itemHeight: 30,
              itemWidth: 80,
              haptics: true,
              axis: Axis.horizontal,
              textStyle: CliaryTextStyle.get(
                color: CliaryColors.descriptionTextGray.withOpacity(0.5),
              ),
              selectedTextStyle: CliaryTextStyle.get(
                fontSize: 20,
                color: CliaryColors.cliaryMainBlue,
              ),
              onChanged: (value) => {},
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CliaryColors.descriptionTextGray),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinutesToNotifyPicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: HeadedFragment(
        header: 'Ile minut przed wydarzeniem chcesz otzymywać notyfikacje:',
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: NumberPicker(
              value: 15,
              minValue: 0,
              maxValue: 300,
              step: 5,
              itemHeight: 30,
              itemWidth: 80,
              haptics: true,
              axis: Axis.horizontal,
              textStyle: CliaryTextStyle.get(
                color: CliaryColors.descriptionTextGray.withOpacity(0.5),
              ),
              selectedTextStyle: CliaryTextStyle.get(
                fontSize: 20,
                color: CliaryColors.cliaryMainBlue,
              ),
              onChanged: (value) => {},
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CliaryColors.descriptionTextGray),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledCheckBox() {
    return CheckboxListTile(
      title: Text(
        'Otrzymuj powiadomienia, gdy odbierasz połączenia z nieznanych numerów',
        style: CliaryTextStyle.get(),
      ),
      value: true,
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: CliaryColors.cliaryMainBlue,
      onChanged: (value) => {},
    );
  }

  Widget _buildExportToExcelBtn() {
    return SizedBox(
      width: double.infinity,
      child: CliaryElevatedButton(
        label: 'Pobierz dane do pliku MS Excel',
        icon: const Icon(Icons.file_download),
        callback: () {},
      ),
    );
  }

}
