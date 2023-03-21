import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/screens/about/about_screen.dart';
import 'package:cliary_test/screens/set_up_services/set_up_services_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1565C0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Witaj w cliary!',
                      style: GoogleFonts.varelaRound(
                        fontSize: 34,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(
                        //'Tu cos tam skonfigurujesz.',
                        'Zacznij od szybkiej konfiguracji',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.varelaRound(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomActionButtons(
              leftButton: CliaryElevatedButton(
                icon: const Icon(Icons.info_outline),
                label: 'O aplikacji',
                reverseColors: true,
                callback: () => Navigator.push(context, PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: const AboutScreen(),
                  )),
              ),
              rightButton: CliaryElevatedButton(
                label: 'Zacznij',
                reverseColors: true,
                callback: () => Navigator.push(context, PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                      child: const SetUpServicesScreen(
                        isInitialSetup: true,
                      ),
                  )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
