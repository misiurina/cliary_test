import 'package:cliary_test/components/cliary_ink_well.dart';
import 'package:cliary_test/components/count_service_list_item.dart';
import 'package:cliary_test/components/headed_card_list.dart';
import 'package:cliary_test/components/service_group_header.dart';
import 'package:cliary_test/model/models.dart';
import 'package:flutter/material.dart';

class SelectServicesList extends StatelessWidget {
  SelectServicesList({
    Key? key,
    required this.groups,
    this.favourites,
    required this.serviceToTimesUsedMap,
    required this.itemClickedCallback,
    required this.selectedItemsMap,
  }) : super(key: key);

  final List<ServiceGroup?> groups;
  final List<Service?>? favourites;
  final Map<Service, int> serviceToTimesUsedMap;
  final void Function(Service) itemClickedCallback;
  final Map<Service, bool> selectedItemsMap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          if (favourites != null && favourites!.isNotEmpty)
            HeadedCardList(
              header: const ServiceGroupHeader(
                text: 'Najczęściej używane',
                color: Colors.yellow,
                icon: Icons.star,
              ),
              items: [
                for (final service in favourites!) ...[
                  CliaryInkWell(
                    onTap: () => itemClickedCallback(service!),
                    child: CountServiceListItem(
                      service: service!,
                      count: serviceToTimesUsedMap[service]!,
                      isSelected: selectedItemsMap[service]!,
                    ),
                  ),
                ]
              ],
            ),
          for (var group in groups) ...[
            HeadedCardList(
              header: ServiceGroupHeader(
                text: group!.displayName,
                color: Color(group.color),
              ),
              items: [
                for (final service in group.services) ...[
                  CliaryInkWell(
                    onTap: () => itemClickedCallback(service),
                    child: CountServiceListItem(
                      service: service,
                      count: serviceToTimesUsedMap[service]!,
                      isSelected: selectedItemsMap[service]!,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
