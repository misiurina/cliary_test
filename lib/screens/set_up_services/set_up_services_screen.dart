import 'package:cliary_test/screens/navigation/cliary_drawer.dart';
import 'package:cliary_test/components/cliary_elevated_button.dart';
import 'package:cliary_test/components/bottom_action_buttons.dart';
import 'package:cliary_test/components/cliary_scroll_view.dart';
import 'package:cliary_test/components/cliary_sliver_app_bar.dart';
import 'package:cliary_test/components/helper_text_header.dart';
import 'package:cliary_test/model/database_controller.dart';
import 'package:cliary_test/screens/set_up_clients/set_up_clients_screen.dart';
import 'package:cliary_test/screens/set_up_services/components/services_list.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class SetUpServicesScreen extends StatefulWidget {
  const SetUpServicesScreen({
    Key? key,
    this.isInitialSetup = true,
  }) : super(key: key);

  final bool isInitialSetup;

  @override
  State<SetUpServicesScreen> createState() => _SetUpServicesScreenState();
}

class _SetUpServicesScreenState extends State<SetUpServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => EditServicesCubit(context.read<DatabaseController>()),
        child: Scaffold(
          drawer: !widget.isInitialSetup
          ? const CliaryDrawer(
            selected: SelectedDrawerItem.services,
          )
          : null,
          body: CliaryScrollView(
            appBar: CliarySliverAppBar(
              title: widget.isInitialSetup ? 'cliary' : 'Twoje usługi',
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const HelperTextHeader(
                    text:
                        'Dodaj tu usługi, które wykonujesz. Możesz je podzielić na grupy i wybrać dla każdej grupy nazwę i kolor, który zadecyduje o kolorze wydarzenia na linii czasu.\nPrzytrzymaj usługę aby wprowadić dodatkowe informacje o czasie trwania i cenie usługi. Ułatwi Ci to i przyśpieszy proces dodania wydarzenia.',
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: EditableServicesList(
                      isInitialSetup: widget.isInitialSetup,
                    ),
                  ),
                  const Spacer(),
                  if (widget.isInitialSetup) BottomActionButtons(
                    leftButton: CliaryElevatedButton(
                      label: 'Wróć',
                      reverseColors: true,
                      callback: ()  => Navigator.pop(context),
                    ),
                    rightButton: BlocBuilder<EditServicesCubit, SetUpServicesState>(
                      builder: (context, state) {
                        return CliaryElevatedButton(
                          label: 'Dalej',
                          callback: () => Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: const SetUpClientsScreen(),
                          )),
                          isActive: _isNextButtonActive(context.read<EditServicesCubit>().state),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool _isNextButtonActive(SetUpServicesState state) {
    for (final group in state.groups) {
      if (group!.services.isNotEmpty) return true;
    }
    return false;
  }
}
