import 'package:cliary_test/components/count_service_list_item.dart';
import 'package:cliary_test/components/headed_card_list.dart';
import 'package:cliary_test/components/service_group_header.dart';
import 'package:cliary_test/model/models.dart';
import 'package:flutter/material.dart';

class ClientsServicesList extends StatelessWidget {
  const ClientsServicesList({
    Key? key,
    required this.groups,
    this.favourites,
    required this.serviceToTimesUsedMap,
    required this.isGroupUsedMap,
  }) : super(key: key);

  final List<ServiceGroup?> groups;
  final List<Service?>? favourites;
  final Map<Service, int> serviceToTimesUsedMap;
  final Map<ServiceGroup, bool> isGroupUsedMap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          if (favourites != null)
            HeadedCardList(
              header: const ServiceGroupHeader(
                text: 'Najczęściej używane',
                color: Colors.yellow,
                icon: Icons.star,
              ),
              items: [
                for (final service in favourites!) ...[
                  if (serviceToTimesUsedMap[service] != 0)
                    CountServiceListItem(
                      service: service!,
                      count: serviceToTimesUsedMap[service]!,
                    ),
                ]
              ],
            ),
          for (var group in groups) ...[
            if (isGroupUsedMap[group] == true)
              HeadedCardList(
                header: ServiceGroupHeader(
                  text: group!.displayName,
                  color: Color(group.color),
                ),
                items: [
                  for (final service in group.services) ...[
                    if (serviceToTimesUsedMap[service] != 0)
                      CountServiceListItem(
                        service: service,
                        count: serviceToTimesUsedMap[service]!,
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
