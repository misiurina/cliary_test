import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:cliary_test/resources/cliary_text_style.dart';
import 'package:cliary_test/screens/about/about_screen.dart';
import 'package:cliary_test/screens/all_clients/all_clients_screen.dart';
import 'package:cliary_test/screens/main/main_screen.dart';
import 'package:cliary_test/screens/set_up_services/set_up_services_screen.dart';
import 'package:cliary_test/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CliaryDrawer extends StatelessWidget {
  const CliaryDrawer({
    Key? key,
    required this.selected,
  }) : super(key: key);

  final SelectedDrawerItem selected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildHeader(),
            const Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            _buildItem(
              Icons.event,
              'Kalendarz',
              selected == SelectedDrawerItem.calendar,
              () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const MainScreen(),
                ));
              },
            ),
            _buildItem(
              Icons.group,
              'Klienci',
              selected == SelectedDrawerItem.clients,
              () {
                Navigator.pop(context);
                selected == SelectedDrawerItem.calendar
                ? Navigator.push(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const AllClientsScreen(
                    hasDrawer: true,
                  ),
                ))
                : Navigator.pushReplacement(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const AllClientsScreen(
                    hasDrawer: true,
                  ),
                ));
              },
            ),
            _buildItem(
              Icons.favorite,
              'Usługi',
              selected == SelectedDrawerItem.services,
              () {
                Navigator.pop(context);
                selected == SelectedDrawerItem.calendar
                    ? Navigator.push(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const SetUpServicesScreen(
                    isInitialSetup: false,
                  ),
                ))
                    : Navigator.pushReplacement(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const SetUpServicesScreen(
                    isInitialSetup: false,
                  ),
                ));
              },
            ),
            _buildItem(
              Icons.settings,
              'Ustawienia',
              selected == SelectedDrawerItem.settings,
              () {
                Navigator.pop(context);
                selected == SelectedDrawerItem.calendar
                    ? Navigator.push(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const SettingsScreen(),
                ))
                    : Navigator.pushReplacement(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const SettingsScreen(),
                ));
              },
            ),
            _buildItem(
              Icons.info_outline,
              'O aplikacji',
              selected == SelectedDrawerItem.about,
              () {
                Navigator.pop(context);
                selected == SelectedDrawerItem.calendar
                    ? Navigator.push(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const AboutScreen(),
                ))
                    : Navigator.pushReplacement(context, PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 100),
                  child: const AboutScreen(
                    hasDrawer: true,
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // const Image(image: AssetImage('graphics/sidebar_header.png')),
        SizedBox(
          height: 190,
          child: CustomPaint(
            size: const Size(double.infinity, 190),
            painter: CirclePainter(),
          ),
        ),
        Positioned(
          left: 20,
          top: 25,
          child: Text(
            'Witaj w Cliary!',
            style: CliaryTextStyle.get(
              fontSize: 34,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 60,
          top: 90,
          child: Text(
            'Masz dzisiaj 4 wydarzenia',
            style: CliaryTextStyle.get(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(IconData icon, String label, bool isSelected, void Function() callback) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? CliaryColors.cliaryMainBlue : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : CliaryColors.textBlack,
        ),
        title: Text(
          label,
          style: CliaryTextStyle.get(
            color: isSelected ? Colors.white : CliaryColors.textBlack,
          ),
        ),
        onTap: callback,
      ),
    );
  }
}

enum SelectedDrawerItem {
  calendar,
  clients,
  services,
  settings,
  about,
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = CliaryColors.cliaryMainBlue
      ..style = PaintingStyle.fill;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawCircle(const Offset(100, -320), 500, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
