import 'package:cliary_test/screens/set_up_services/components/add_service_list_item.dart';
import 'package:cliary_test/components/headed_card_list.dart';
import 'package:cliary_test/screens/set_up_services/components/service_list_item.dart';
import 'package:cliary_test/screens/set_up_services/components/add_service_group_button.dart';
import 'package:cliary_test/cubit/set_up_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'editable_service_group_header.dart';

class EditableServicesList extends StatefulWidget {
  const EditableServicesList({
    Key? key,
    this.isInitialSetup = false,
  }) : super(key: key);

  final bool isInitialSetup;

  @override
  State<EditableServicesList> createState() => _EditableServicesListState();
}

class _EditableServicesListState extends State<EditableServicesList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditServicesCubit, SetUpServicesState>(
        builder: (context, state) {
          return IntrinsicHeight(
            child: Column(
              children: [
                for (var group in state.groups) ...[
                  HeadedCardList(
                    header: EditableServiceGroupHeader(
                      key: UniqueKey(),
                      group: group!,
                      isEditMode: group.displayName.isEmpty && group.services.isEmpty,
                    ),
                    items: [
                      for (var service in group.services) ...[
                        ServiceListItem(
                          key: UniqueKey(),
                          service: service,
                        )
                      ],
                      AddServiceListItem(
                        key: UniqueKey(),
                        group: group,
                        isEditMode: group.displayName.isNotEmpty && state.groups.last == group && widget.isInitialSetup,
                      ),
                    ],
                  ),
                ],
                const AddServiceGroupButton(),
              ],
            ),
          );
        });
  }
}
